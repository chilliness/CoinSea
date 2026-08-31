//
//  CoinImgViewModel.swift
//  CoinSea
//
//  Created by xiaohan on 2026/5/19.
//

import SwiftUI

@MainActor
@Observable
class CoinImgViewModel {
    var coin: CoinMod
    var dataService = CoinImageViewService()
    var image: UIImage?
    var isLoading: Bool = false
    
    init(coin: CoinMod) {
        self.coin = coin
    }
    
    func handleDll() async {
        // 1. 尝试从沙盒缓存读取
        if let cachedImg = await dataService.handleFetchCache(imgName: coin.id) {
            image = cachedImg
            return
        }
        
        // 2. 缓存没有，发起网络下载
        isLoading = true
        
        // 3. 异步下载并在后台线程解析图片，避免卡顿主线程
        if let downloadedImg = await dataService.handleLoadAndSave(coin: coin) {
            // 💡 关键优化：让图片赋值和加载状态关闭落在同一个主线程周期，避免多重帧重绘
            image = downloadedImg
            isLoading = false
        } else {
            isLoading = false
        }
    }
}

struct CoinImageViewService {
    private var fileShared = XFile.shared
    private var folderName = "imgCoin"
    
    // 从沙盒缓存异步获取图片
    func handleFetchCache(imgName: String) async -> UIImage? {
        await fileShared.handleGetImg(imgName: imgName, folderName: folderName)
    }
    
    // 下载图片并自动保存到缓存
    func handleLoadAndSave(coin: CoinMod) async -> UIImage? {
        guard let url = URL(string: coin.image) else { return nil }
        
        // 发起异步网络请求
        guard let (data, res) = try? await URLSession.shared.data(from: url), res.isOK else { return nil }
        
        // 在后台线程将 Data 转换为 UIImage
        guard let img = UIImage(data: data) else { return nil }
        
        // 后台异步保存图片
        await fileShared.handleSaveImg(img: img, imgName: coin.id, folderName: folderName)
        
        return img
    }
}

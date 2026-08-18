//
//  XUtils.swift
//  CoinSea
//
//  Created by xiaohan on 2026/4/21.
//

import SwiftUI
import UserNotifications

// 振动管理
class XHaptic {
    static let shared = XHaptic()
    
    private init() {}
    
    func handleNotifi(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    func handleImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}

// 文件管理
actor XFile {
    static let shared = XFile()
    
    private init() {}
    
    func handleSaveImg(img: UIImage, imgName: String, folderName: String) async {
        handleCreateFolder(folderName: folderName)
        
        guard let data = img.pngData(),
              let url = handleGetImgUrl(imgName: imgName, folderName: folderName) else { return }
        
        try? data.write(to: url, options: [.atomic])
    }
    
    func handleGetImg(imgName: String, folderName: String) async -> UIImage? {
        guard let url = handleGetImgUrl(imgName: imgName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else { return nil }
        
        return UIImage(contentsOfFile: url.path)
    }
    
    private func handleCreateFolder(folderName: String) {
        guard let url = handleGetFolderUrl(folderName: folderName) else { return }
        
        guard !FileManager.default.fileExists(atPath: url.path) else { return }
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    }
    
    private func handleGetFolderUrl(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        return url.appending(path: folderName)
    }
    
    private func handleGetImgUrl(imgName: String, folderName: String) -> URL? {
        guard let url = handleGetFolderUrl(folderName: folderName) else { return nil }
        
        return url.appending(path: imgName + ".png")
    }
}

struct XModiTheme: ViewModifier {
    var scheme: ColorScheme = .dark
    
    func body(content: Content) -> some View {
        content
            .background(Color(.systemBackground))
            .colorScheme(scheme)
    }
}

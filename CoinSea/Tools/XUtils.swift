//
//  XUtils.swift
//  CoinSea
//
//  Created by xiaohan on 2026/4/21.
//

import SwiftUI
import AVKit
import UserNotifications

// 工具函数
class XUtils {
    static func handleGeo(geo: GeometryProxy, coef: Double = 20) -> Double {
        let maxW = geo.frame(in: .global).width / 2
        let curr = geo.frame(in: .global).midX
        
        return Double(1 - (curr / maxW)) * coef
    }
}

// 振动管理
class XHaptic {
    static let shared = XHaptic()
    
    private init() {}
    
    func handleNotifi(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare() // 触发前准备，减少延迟
        generator.notificationOccurred(type)
    }
    
    func handleImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare() // 触发前准备
        generator.impactOccurred()
    }
}

// 声音管理
class XSound {
    static let shared = XSound()
    var player: AVAudioPlayer?
    
    private init() {}
    
    func handleSound(name: String, ext: String = "mp3") {
        // 保证手机开静音模式时也能放声音
        guard (try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)) != nil else { return }
        guard (try? AVAudioSession.sharedInstance().setActive(true)) != nil else { return }
        
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else { return }
        
        player = try? AVAudioPlayer(contentsOf: url)
        player?.prepareToPlay()
        player?.play()
    }
}

// 文件管理丨actor多线程，避免卡顿
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

struct XCorner: Shape {
    var size: CGSize
    var conrner: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: conrner, cornerRadii: size)
        
        return Path(path.cgPath)
    }
}

struct XTriang: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        }
    }
}

struct XModiText: ViewModifier {
    var bgc: Color = .blue
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundStyle(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(bgc)
            .isRounded(10)
            .shadow(radius: 10)
            .padding()
    }
}

struct XModiTrans: ViewModifier {
    var ang: Double = 45
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(ang))
            .visualEffect { ctx, geo in
                let flag = ang != 0
                
                return ctx.offset(x: flag ? geo.size.width : 0, y: flag ? geo.size.height : 0)
            }
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

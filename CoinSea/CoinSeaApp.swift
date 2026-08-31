//
//  CoinSeaApp.swift
//  CoinSea
//
//  Created by xiaohan on 2026/5/15.
//

import SwiftUI
import SwiftData

@main
struct CoinSeaApp: App {
    @AppStorage("theme") var theme: Theme = .dark
    
    @State var vm: HomeViewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbar(.hidden)
            }
            .preferredColorScheme(theme.colorScheme)
            .environment(vm)
        }
        .modelContainer(for: [PortfolioMod.self])
    }
}

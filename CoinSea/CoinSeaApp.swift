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
    @State var vm: HomeViewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbar(.hidden)
            }
            .environment(vm)
        }
        .modelContainer(for: [PortfolioModel.self])
    }
}

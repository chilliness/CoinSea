//
//  MarketViewModel.swift
//  CoinSea
//
//  Created by xiaohan on 2026/5/22.
//

import SwiftUI

@Observable
class MarketViewModel {}

@MainActor
@Observable
class MarketViewService {
    var marketData: MarketModel?
    var isLoading: Bool = false
    
    init() {
        Task {
            await handleDll()
        }
    }
    
    func handleDll() async {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        guard let (data, res) = try? await URLSession.shared.data(from: url), res.isOK else { return }
        
        guard let temp = try? JSONDecoder().decode(GlobalData.self, from: data).data else { return }
        marketData = temp
    }
}

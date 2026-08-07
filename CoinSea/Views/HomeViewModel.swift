//
//  HomeViewModel.swift
//  CoinSea
//
//  Created by xiaohan on 2026/5/18.
//

import SwiftUI

@MainActor
@Observable
class HomeViewModel {
    var marketService = MarketViewService()
    var filterCoins: [CoinModel] = []
    var searchTask: Task<Void, Never>?
    var homeService = HomeViewService()
    var sortOption: SortOption = .rank
    var keyStr: String = "" {
        didSet { handleDebounce() }
    }
    var dataCoins: [CoinModel] {
        let temp = homeService.allCoins
        
        switch sortOption {
        case .rank:
            return temp.sorted { $0.rank < $1.rank }
        case .rankDesc:
            return temp.sorted { $0.rank > $1.rank }
        case .price:
            return temp.sorted { $0.currentPrice > $1.currentPrice }
        case .priceDesc:
            return temp.sorted { $0.currentPrice < $1.currentPrice }
        }
    }
    var portfolioModel: [PortfolioModel] = []
    var portfolioCoins: [CoinModel] {
        let temp = dataCoins.compactMap { coin in
            if let portfolio = portfolioModel.first(where: { $0.id == coin.id }) {
                return coin.updateHoldings(amount: portfolio.amount)
            }
            return nil
        }
        return temp.filter { keyStr.isEmpty ? true : $0.symbol.localizedStandardContains(keyStr) }
    }
    var allCoins: [CoinModel] {
        keyStr.isEmpty ? dataCoins : filterCoins
    }
    var statList: [StatModel] {
        guard let marketData = marketService.marketData else { return [] }
        
        let portValue = portfolioCoins.map({ $0.currentHoldingsValue }).reduce(0, +)
        let prevValue = portfolioCoins.map({ $0.currentHoldingsValue / (1 + ($0.priceChangePercentage24H ?? 0) / 100) }).reduce(0, +)
        // 避免出现除数为0，后续显示nan的情况
        let percent = prevValue <= 0 ? 0 : ((portValue - prevValue) / prevValue) * 100
        
        return [
            StatModel(title: "Market Cap", value: marketData.marketCap, percent: marketData.marketCapChangePercentage24HUsd),
            StatModel(title: "24h Volume", value: marketData.volume),
            StatModel(title: "BTC Dominance", value: marketData.btcDomin),
            StatModel(title: "Portfolio Value", value: portValue.asCurrencyWith2Decimals(), percent: percent)
        ]
    }
    
    enum SortOption {
        case rank, rankDesc, price, priceDesc
    }
    
    func handleReload() async {
        defer { XHaptic.shared.handleNotifi(type: .success) }
        
        _ = await (homeService.handleDll(), marketService.handleDll())
    }
    
    func handleDebounce() {
        searchTask?.cancel()
        
        guard !keyStr.isEmpty else { return }
        
        let listCoins = dataCoins
        
        searchTask = Task {
            try? await Task.sleep(for: .seconds(0.5))
            
            guard !Task.isCancelled else { return }
            
            filterCoins = listCoins.filter { $0.symbol.localizedStandardContains(keyStr) }
        }
    }
    
    func handleFilter(with query: String) -> [CoinModel] {
        let listCoins = homeService.allCoins
        
        guard !query.isEmpty else {
            let holdCoins = listCoins.compactMap { coin in
                if let portfolio = portfolioModel.first(where: { $0.id == coin.id }) {
                    return coin.updateHoldings(amount: portfolio.amount)
                }
                return nil
            }
            return !holdCoins.isEmpty ? holdCoins : listCoins
        }
        
        return listCoins.filter { $0.symbol.localizedStandardContains(query) }
    }
}

@MainActor
@Observable
class HomeViewService {
    var allCoins: [CoinModel] = []
    var isLoading: Bool = false
    
    init() {
        Task {
            await handleDll()
        }
    }
    
    func handleDll() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string:  "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        guard let (data, res) = try? await URLSession.shared.data(from: url), res.isOK else { return }
        
        guard let temp = try? JSONDecoder().decode([CoinModel].self, from: data) else { return }
        allCoins = temp
    }
}

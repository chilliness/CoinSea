//
//  DetailViewModel.swift
//  CoinSea
//
//  Created by xiaohan on 2026/6/1.
//

import SwiftUI

@MainActor
@Observable
class DetailViewModel {
    var detailService: DetailViewService
    var overStats: [StatModel] = []
    var addiStats: [StatModel] = []
    var coin: CoinModel
    var coinDesc: String?
    var webUrl: String?
    var redUrl: String?
    
    init(coin: CoinModel) {
        self.coin = coin
        self.detailService = DetailViewService(coin: coin)
        
        Task {
            // 1. 先用现有的本地 coin 数据，把界面上的基础数据（价格、市值、成交量）渲染出来，让用户无需等待加载完成
            handleMapData(coinDetailModel: nil, coinModel: coin)
            
            // 2. 异步调用网络请求，并挂起等待它执行完毕
            await detailService.handleDll(coin: coin)
            
            // 3. 当网络数据平安抵达，重新映射一次，把追加的数据（区块时间、哈希算法）补齐到界面上
            handleMapData(coinDetailModel: detailService.coinDetail, coinModel: coin)
        }
    }
    
    private func handleMapData(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) {
        let defStr = "N/A"
        let overPrice = coinModel.currentPrice.asCurrencyWith6Decimals()
        let overPriceChange = coinModel.priceChangePercentage24H
        let overPriceStat = StatModel(title: "Current Price", value: overPrice, percent: overPriceChange)
        
        let overMarketCap = "$" + (coinModel.marketCap?.asWithAbbr() ?? "")
        let overMarketCapChange = coinModel.marketCapChangePercentage24H
        let overMarketCapStat = StatModel(title: "Market Capitalization", value: overMarketCap, percent: overMarketCapChange)
        
        let overRank = "\(coinModel.rank)"
        let overRankStat = StatModel(title: "Rank", value: overRank)
        
        let overVolume = "$" + (coinModel.totalVolume?.asWithAbbr() ?? "")
        let overVolumeStat = StatModel(title: "Volume", value: overVolume)
        
        overStats = [overPriceStat, overMarketCapStat, overRankStat, overVolumeStat]
        
        let addiHigh = coinModel.high24H?.asCurrencyWith6Decimals() ?? defStr
        let addiHighStat = StatModel(title: "24h High", value: addiHigh)
        
        let addiLow = coinModel.low24H?.asCurrencyWith6Decimals() ?? defStr
        let addiLowStat = StatModel(title: "24h Low", value: addiLow)
        
        let addiPrice = coinModel.priceChange24H?.asCurrencyWith2Decimals() ?? defStr
        let addiPriceChange = coinModel.priceChangePercentage24H
        let addiPriceStat = StatModel(title: "24h Price Change", value: addiPrice, percent: addiPriceChange)
        
        let addiMarketCap = coinModel.marketCap?.asCurrencyWith2Decimals() ?? defStr
        let addiMarketCapChange = coinModel.marketCapChangePercentage24H
        let addiMarketCapStat = StatModel(title: "24h Market Cap Change", value: addiMarketCap, percent: addiMarketCapChange)
        
        if let detailModel = coinDetailModel {
            let addiBlockTime = "\(detailModel.blockTimeInMinutes ?? 0) min"
            let addiBlockTimeStat = StatModel(title: "Block Time", value: addiBlockTime)
            
            let addiHashing = detailModel.hashingAlgorithm ?? defStr
            let addiHashingStat = StatModel(title: "Hashing Algorithm", value: addiHashing)
            
            coinDesc = detailModel.description?.en?.handleRemoveHTML()
            webUrl = detailModel.links?.homepage?.first
            redUrl = detailModel.links?.subredditURL
            
            addiStats = [addiHighStat, addiLowStat, addiPriceStat, addiMarketCapStat, addiBlockTimeStat, addiHashingStat]
        } else {
            let loadStr = "Loading..."
            addiStats = [
                StatModel(title: "24h High", value: loadStr),
                StatModel(title: "24h Low", value: loadStr),
                StatModel(title: "24h Price Change", value: loadStr),
                StatModel(title: "24h Market Cap Change", value: loadStr),
                StatModel(title: "Block Time", value: loadStr),
                StatModel(title: "Hashing Algorithm", value: loadStr)
            ]
        }
    }
}

@MainActor
@Observable
class DetailViewService {
    var coinDetail: CoinDetailModel?
    
    init(coin: CoinModel) {}
    
    func handleDll(coin: CoinModel) async {
        guard let url = URL(string:  "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        guard let (data, res) = try? await URLSession.shared.data(from: url), res.isOK else { return }
        
        guard let temp = try? JSONDecoder().decode(CoinDetailModel.self, from: data) else { return }
        coinDetail = temp
    }
}

//
//  ComMod.swift
//  CoinSea
//
//  Created by xiaohan on 2026/5/18.
//

import Foundation
import SwiftData
import SwiftUI

// https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h

struct CoinModel: Identifiable, Codable, Hashable {
    let id: String
    var symbol, name, image: String
    var currentPrice: Double
    var marketCap, marketCapRank, fullyDilutedValuation: Double?
    var totalVolume, high24H, low24H: Double?
    var priceChange24H, priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H: Double?
    var circulatingSupply, totalSupply, maxSupply, ath: Double?
    var athChangePercentage: Double?
    var athDate: String?
    var atl, atlChangePercentage: Double?
    var atlDate: String?
    var lastUpdated: String?
    var sparklineIn7D: SparklineIn7D?
    var priceChangePercentage24HInCurrency: Double?
    var currentHoldings: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case ath
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case atl
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case currentHoldings = "current_holdings"
    }
    
    func updateHoldings(amount: Double) -> CoinModel {
        return CoinModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: amount)
    }
    
    var currentHoldingsValue: Double {
        (currentHoldings ?? 0) * currentPrice
    }
    
    var rank: Int {
        Int(marketCapRank ?? 0)
    }
}

struct SparklineIn7D: Codable, Hashable {
    var price: [Double]?
}

// https://api.coingecko.com/api/v3/global

struct GlobalData: Codable {
    var data: MarketModel?
}

struct MarketModel: Codable {
    var totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    var marketCapChangePercentage24HUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String {
        guard let item = totalMarketCap.first(where: { $0.key == "usd" }) else { return "" }
        
        return "$" + item.value.asWithAbbr()
    }
    
    var volume: String {
        guard let item = totalVolume.first(where: { $0.key == "usd" }) else { return "" }
        
        return "$" + item.value.asWithAbbr()
    }
    
    var btcDomin: String {
        guard let item = marketCapPercentage.first(where: { $0.key == "btc" }) else { return "" }
        
        return item.value.asPercentString()
    }
}

// https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false

struct CoinDetailModel: Codable {
    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let description: Description?
    let links: Links?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, description, links
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
    }
    
    var readableDescription: String? {
        return description?.en?.handleRemoveHTML()
    }
}

struct Links: Codable {
    let homepage: [String]?
    let subredditURL: String?
    
    enum CodingKeys: String, CodingKey {
        case homepage
        case subredditURL = "subreddit_url"
    }
}

struct Description: Codable {
    let en: String?
}

@Model
class PortfolioModel {
    @Attribute(.unique) var id: String
    var amount: Double
    
    init(id: String, amount: Double) {
        self.id = id
        self.amount = amount
    }
}

struct StatModel: Identifiable {
    let id = UUID()
    var title: String
    var value: String
    var percent: Double?
}

enum Themes: String, CaseIterable, Identifiable {
    case light = "浅色模式"
    case dark = "深色模式"
    
    var id: String { self.rawValue }
    
    var colorScheme: ColorScheme {
        switch self {
        case .light: return .light
        case .dark: return .dark
        }
    }
}

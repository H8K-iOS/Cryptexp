import Foundation
/*
Coin geko
 https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h
 
 
 JSON Resp
 
 {
        "id": "bitcoin",
        "symbol": "btc",
        "name": "Bitcoin",
        "image": "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
        "current_price": 55481,
        "market_cap": 1092547965841,
        "market_cap_rank": 1,
        "fully_diluted_valuation": 1162498194712,
        "total_volume": 73901063201,
        "high_24h": 56262,
        "low_24h": 49665,
        "price_change_24h": 5294.68,
        "price_change_percentage_24h": 10.54997,
        "market_cap_change_24h": 101755412072,
        "market_cap_change_percentage_24h": 10.2701,
        "circulating_supply": 19736381.0,
        "total_supply": 21000000.0,
        "max_supply": 21000000.0,
        "ath": 73738,
        "ath_change_percentage": -24.84748,
        "ath_date": "2024-03-14T07:10:36.635Z",
        "atl": 67.81,
        "atl_change_percentage": 81623.54869,
        "atl_date": "2013-07-06T00:00:00.000Z",
        "roi": null,
        "last_updated": "2024-08-06T12:30:02.803Z",
        "sparkline_in_7d": {
            "price": [
                66489.48680529871,
                ...
            ]
        },
        "price_change_percentage_24h_in_currency": 10.549965588741275
    },
 */


struct Coin: Identifiable, Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String
    let atl, atlChangePercentage: Double?
    let atlDate: String
    let lastUpdated: String
    let sparklineIn7D: SparklineIn7D
    let priceChangePercentage24HInCurrency: Double?
    let currentHoldings: Double?
    
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
            case circulatingSupply = "circulating_supply"
            case totalSupply = "total_supply"
            case maxSupply = "max_supply"
            case ath
            case athChangePercentage = "ath_change_percentage"
            case athDate = "ath_date"
            case atl
            case atlChangePercentage = "atl_change_percentage"
            case atlDate = "atl_date"
            case lastUpdated = "last_updated"
            case sparklineIn7D = "sparkline_in_7d"
            case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
            case currentHoldings
        }
    
    func updateHoldings(amount: Double) -> Coin {
        return Coin(
            id: id,
            symbol: symbol,
            name: name,
            image: image,
            currentPrice: currentPrice,
            marketCap: marketCap,
            marketCapRank: marketCapRank,
            fullyDilutedValuation: fullyDilutedValuation,
            totalVolume: totalVolume,
            high24H: high24H,
            low24H: low24H,
            priceChange24H: priceChange24H,
            priceChangePercentage24H: priceChangePercentage24H,
            marketCapChange24H: marketCapChange24H,
            marketCapChangePercentage24H: marketCapChangePercentage24H,
            circulatingSupply: circulatingSupply,
            totalSupply: totalSupply,
            maxSupply: maxSupply,
            ath: ath,
            athChangePercentage: athChangePercentage,
            athDate: athDate,
            atl: atl,
            atlChangePercentage: atlChangePercentage,
            atlDate: atlDate,
            lastUpdated: lastUpdated,
            sparklineIn7D: sparklineIn7D,
            priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency,
            currentHoldings: amount
        )
        
    }
    
    var currentHoldingValue: Double {
        (self.currentHoldings ?? 0) * self.currentPrice
    }
    
    var rank: Int {
        Int(self.marketCapRank ?? 0) 
    }
}

// MARK: - SparklineIn7D
struct SparklineIn7D: Codable {
    let price: [Double]
}


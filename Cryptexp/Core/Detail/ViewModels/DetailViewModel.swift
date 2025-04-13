import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    @Published var overviewStatistic: [StatisticModel] = []
    @Published var additionalStatistic: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    private let coinDetailDataService: CoinDetailDataService
    private var cancelables = Set<AnyCancellable>()
    @Published var coin: Coin
    
    
    init(coin: Coin) {
        self.coin = coin
        self.coinDetailDataService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailDataService.$coinDetails
            .combineLatest($coin)
            .map(mapDetailToStatistic)
        
            .sink { [weak self] returnedArray in
                self?.overviewStatistic = returnedArray.overview
                self?.additionalStatistic = returnedArray.additional
                
            }
            .store(in: &cancelables)
        
        coinDetailDataService.$coinDetails
            .sink { [weak self] returnedCoinDetails in
                self?.coinDescription = returnedCoinDetails?.readableDescription
                self?.websiteURL = returnedCoinDetails?.links?.homepage.first
                self?.redditURL = returnedCoinDetails?.links?.subredditURL
            }
            .store(in: &cancelables)
    }
    
    private func mapDetailToStatistic(coinDetailModel: CoinDetailModel?, coin: Coin) -> (overview: [StatisticModel], additional: [StatisticModel]) {

        let overview = createOverviewArray(coin: coin)
        let additional = createAdditionalArray(coin: coin, coinDetailModel: coinDetailModel)
    
        return (overview, additional)
    }
    
   private func createOverviewArray(coin: Coin) -> [StatisticModel] {
        
        //overview
        let price = coin.currentPrice.asCurrencyWith6Decimals()
        let pricePercentageChange = coin.priceChangePercentage24H
        let pricePercentageStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentageChange)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentageChange = coin.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentageChange)
        
        let rank = "\(coin.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [
            pricePercentageStat, marketCapStat, rankStat, volumeStat
        ]
        
        return overviewArray
    }
    
   private func createAdditionalArray(coin: Coin, coinDetailModel: CoinDetailModel?) -> [StatisticModel] {
        //additional
        let high = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "High 24h", value: high)
        
        let low = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "Low 24h", value: low)
        
        let priceChange = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentageChange = coin.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price change", value: priceChange, percentageChange: pricePercentageChange)
        
        let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentageChange = coin.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentageChange)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockTimeStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [StatisticModel] = [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blockTimeStat, hashingStat
        ]
        
        return additionalArray
    }
}

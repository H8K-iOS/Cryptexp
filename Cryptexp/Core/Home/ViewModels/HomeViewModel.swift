import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var statisctic: [StatisticModel] = []
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchedText = ""
    private let coinService = CoinDataService()
    private let statisticService = MarketDataService()
    private var cancelables = Set<AnyCancellable>()
    
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        // updates all coins
        $searchedText
            .combineLatest(coinService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancelables)
        
        //Market Data / Statistic
        statisticService.$statistic
            .map(statisticData)
        
            .sink { [weak self] stat in
                self?.statisctic = stat
            }
            .store(in: &cancelables)
    }
}

private extension HomeViewModel {
    //MARK: filtering
    func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else {
            return coins
        }
        let lowercasedText = text.lowercased()
        return coins.filter { coin in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    func statisticData(marketData: MarketData?) -> [StatisticModel]{
        var stats: [StatisticModel] = []
        
        guard let data = marketData else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let statisticVolume = StatisticModel(title: "24h Volume", value: data.marketCap)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        
        stats.append(contentsOf: [
            marketCap,
            statisticVolume,
            btcDominance,
            portfolio
        ])
        
        return stats
    }
}

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var statisctic: [StatisticModel] = []
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchedText = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    private let coinService = CoinDataService()
    private let statisticService = MarketDataService()
    private let portfolioService = PortfolioDataSevice()
    private var cancelables = Set<AnyCancellable>()
    
    enum SortOption {
        case holdings, holdingsReverse, rank, rankReverse, price, priceReverse
    }
    
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        // updates all coins
        $searchedText
            .combineLatest(coinService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancelables)
        
        //Portfolio
        $allCoins
            .combineLatest(portfolioService.$savedEntity)
            .map(mapAllCoins)
            
            .sink { [weak self] coins in
                guard let self else { return }
                
                self.portfolioCoins = sortCoinsHoldingsIfNeeded(coins: coins)
            }
            .store(in: &cancelables)
        
        //Market Data / Statistic
        statisticService.$statistic
            .combineLatest($portfolioCoins)
            .map(statisticData)
        
            .sink { [weak self] stat in
                self?.statisctic = stat
                self?.isLoading = false
            }
            .store(in: &cancelables)
        

    }
    
    public func updatePortfolio(coin: Coin, ammount: Double) {
        portfolioService.updatePortfolio(coin: coin, ammount: ammount)
    }
    
    public func reloadData() {
        isLoading = true
        self.coinService.update()
        self.statisticService.update()
        HapticManager.notification(type: .success)
    }
}

private extension HomeViewModel {
    //MARK: filtering
    func filterAndSortCoins(text: String, coins: [Coin], sortOption: SortOption) -> [Coin] {
        var coins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sortOption, coins: &coins)
        return coins
    }
    
    func sortCoins(sort: SortOption, coins: inout [Coin]){
        switch sort {
        case .rank, .holdings:
            coins.sort(by: {$0.rank < $1.rank})
        case .rankReverse, .holdingsReverse:
            coins.sort(by: {$0.rank > $1.rank})
        case .price:
            coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case .priceReverse:
            coins.sort(by: {$0.currentPrice < $1.currentPrice})
        }
    }
    
    func sortCoinsHoldingsIfNeeded(coins: [Coin]) -> [Coin] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingValue > $1.currentHoldingValue})
        case .holdingsReverse:
            return coins.sorted(by: {$0.currentHoldingValue < $1.currentHoldingValue})
        default:
            return coins
        }
    }
    
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
    
    func mapAllCoins(allcoins: [Coin], portfolioEntities: [Portfolio]) -> [Coin] {
        allcoins
            .compactMap { coin -> Coin? in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else { return nil}
                return coin.updateHoldings(amount: entity.ammount)
            }
    }
    
    func statisticData(marketData: MarketData?, portfolioCoins: [Coin] ) -> [StatisticModel]{
        var stats: [StatisticModel] = []
        
        guard let data = marketData else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let statisticVolume = StatisticModel(title: "24h Volume", value: data.marketCap)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue
            =
            portfolioCoins
            .map({$0.currentHoldingValue})
            .reduce(0, +)
        
        let previusPortfolioValue
            =
            portfolioCoins
            .map { coin -> Double  in
                let current = coin.currentHoldingValue
                let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                //let previusValue = current*percentChange
                let previusValue = current / (1 + percentChange)
                return previusValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previusPortfolioValue) / previusPortfolioValue)
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            statisticVolume,
            btcDominance,
            portfolio
        ])
        
        return stats
    }
}

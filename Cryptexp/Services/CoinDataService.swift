import Foundation
import Combine

final class CoinDataService {
    @Published var allCoins: [Coin] = []
    var cancelable = Set<AnyCancellable>()
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        //TODO: - Network Layer / Endpoint / Errors
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        NetworkManager.download(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handle, receiveValue: { [weak self] coins in
                self?.allCoins = coins
            })
            .store(in: &cancelable)
    }
}

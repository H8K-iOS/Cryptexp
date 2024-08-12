import Foundation
import Combine

final class MarketDataService {
    @Published var statistic: MarketData? = nil
    var cancelable = Set<AnyCancellable>()
    
    init() {
        getStats()
    }
    
    private func getStats() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        NetworkManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handle, receiveValue: { [weak self] statistic in
                self?.statistic = statistic.data
            })
            .store(in: &cancelable)
    }
}

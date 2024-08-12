import Foundation
import Combine

final class NetworkManager {
    enum NetworkingError: LocalizedError {
        case badUrlressponse(_ url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badUrlressponse(let url):
                return "[🔥] Bad response from url: - \(url)"
            case .unknown:
                return "[‼️] Unknown Error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error>
    {
       return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { try handle(urlResp: $0, url: url)}
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handle(urlResp: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = urlResp.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badUrlressponse(url)
        }
        
        return urlResp.data
    }
    
    static func handle(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure:
            print(NetworkingError.unknown)
        }
    }
    
}

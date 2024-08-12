import SwiftUI
import Combine

final class CoinImageService {
    private let fileManage = LocalFileManager.shared
    private let coin: Coin
    private let folderName = "coin_images"
    private let imageName: String
    
    @Published var image: UIImage? = nil
    private var cancelable = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManage.getImage(imageName: imageName, folderName: folderName) {
            self.image = savedImage
        } else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        NetworkManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.handle) { [weak self] returnedImage in
                guard let self = self,
                      let image = returnedImage
                else { return }
                self.image = returnedImage
                self.fileManage.saveImage(image: image, imageName: self.imageName, folderName: self.folderName)
            }
            .store(in: &cancelable)
    }
}

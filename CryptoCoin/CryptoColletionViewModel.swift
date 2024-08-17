
import Foundation

final class CryptoColletionViewModel {
    private(set) var cryptoData = [CryptoModel]()
    private(set) var sortedCryptoData = [CryptoModel]()
    
    var didUpdateData: (() -> Void)?
    var didFailWithError: ((String) -> Void)?
    
    func fetchCryptos() {
        NetworkManager.shared.fetchCrytos { [weak self] cryptos, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    self.didFailWithError?(error.localizedDescription)
                    return
                }
                
                self.cryptoData = cryptos ?? []
                self.sortedCryptoData = self.cryptoData
                self.didUpdateData?()
            }
        }
    }
    
    func sort(by option: SortOption) {
        switch option {
        case .priceChangeDescending:
            sortedCryptoData = cryptoData.sorted { $0.percentChangeUsdLast24Hours > $1.percentChangeUsdLast24Hours }
        case .priceChangeAscending:
            sortedCryptoData = cryptoData.sorted { $0.percentChangeUsdLast24Hours < $1.percentChangeUsdLast24Hours }
        }
        didUpdateData?()
    }
    
    enum SortOption {
        case priceChangeDescending
        case priceChangeAscending
    }
}

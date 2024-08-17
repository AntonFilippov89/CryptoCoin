
import Foundation

final class CryptoColletionViewModel {
    
    private(set) var cryptoData = [CryptoModel]()
    private(set) var sortedCryptoData = [CryptoModel]()
    
    var didUpdateData: (() -> Void)?
    var didFailWithError: ((String) -> Void)?
    
    func fetchCryptos() {
        NetworkManager.shared.fetchCryptos { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cryptos):
                    self?.cryptoData = cryptos
                    self?.sortedCryptoData = cryptos
                    self?.didUpdateData?()
                case .failure(let error):
                    self?.didFailWithError?(error.localizedDescription)
                }
            }
        }
    }
    
    func sort(by option: SortOption) {
        sortedCryptoData = cryptoData.sorted {
            switch option {
            case .priceChangeDescending:
                return $0.percentChangeUsdLast24Hours > $1.percentChangeUsdLast24Hours
            case .priceChangeAscending:
                return $0.percentChangeUsdLast24Hours < $1.percentChangeUsdLast24Hours
            }
        }
        didUpdateData?()
    }
    
    enum SortOption {
        case priceChangeDescending
        case priceChangeAscending
    }
}


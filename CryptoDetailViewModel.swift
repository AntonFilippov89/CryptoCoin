import UIKit

class CryptoDetailViewModel {
    private var crypto: CryptoModel
    
    var cryptoName: String {
        return crypto.name
    }
    
    var cryptoPrice: String {
        return String(format: "$%.2f", crypto.priceUsd)
    }
    
    var cryptoChange: String {
        return String(format: "%.2f%%", crypto.percentChangeUsdLast24Hours)
    }
    
    var changeColor: UIColor {
        return crypto.percentChangeUsdLast24Hours >= 0 ? ColorPalette.darkGreen : ColorPalette.darkRed
    }
    
    init(crypto: CryptoModel) {
        self.crypto = crypto
    }
}



import Foundation

struct CryptoResponse: Decodable {
    let data: [CryptoModel]
}

struct CryptoModel: Decodable {
    let name: String
    let id: String
    let metrics: Metrics
    
    struct Metrics: Decodable {
        let marketData: MarketData
    }

    struct MarketData: Decodable {
        let priceUsd: Double
        let percentChangeUsdLast24Hours: Double?
    }
}

extension CryptoModel {
    //auto computable property
    var priceUsd: Double {
        metrics.marketData.priceUsd
    }
    
    var percentChangeUsdLast24Hours: Double {
        metrics.marketData.percentChangeUsdLast24Hours ?? 0
    }
}

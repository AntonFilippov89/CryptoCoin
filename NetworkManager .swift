
import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let dataURL = "https://data.messari.io/api/v1/assets"
    private let apiKey = "aly6nJGKDDrnFH+CjUe6q1ER23lNSUClFbdP7ZkwYhC26VFC"
    
    func fetchCryptos(completion: @escaping (Result<[CryptoModel], Error>) -> Void) {
        guard let url = URL(string: dataURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "x-messari-api-key")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let cryptoResponse = try decoder.decode(CryptoResponse.self, from: data)
                completion(.success(cryptoResponse.data))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
}

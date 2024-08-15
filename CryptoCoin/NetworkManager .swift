 
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    let dataURL = "https://data.messari.io/api/v1/assets"
    let apiKey = "aly6nJGKDDrnFH+CjUe6q1ER23lNSUClFbdP7ZkwYhC26VFC"
    
    func fetchCrytos(completion: @escaping ([CryptoModel]?, Error?) -> Void) {
        guard let url = URL(string: dataURL) else { return }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "x-messari-api-key")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                return
                }
                        
            guard let data = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"]))
                return
                }
                        
            do {
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("Response JSON: \(json)")
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let cryptoResponse = try decoder.decode(CryptoResponse.self, from: data)
                
                completion(cryptoResponse.data, nil)
                
            } catch {
                print("Decoding error: \(error)")
                completion(nil, error)
            }
        }
        task.resume()
    }
}

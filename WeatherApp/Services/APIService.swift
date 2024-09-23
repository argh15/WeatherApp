//
//  APIService.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/21/24.
//

import Foundation

final class APIService {
    
    static let sharedInstance = APIService()
    
    private init() {}
    
    func getData(from urlString: String,
                 dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970,
                 completion: @escaping (Result<WeatherModel, CustomError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.error(NSLocalizedString("Error: Invalid URL", comment: ""))))
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.error("Error: \(error.localizedDescription)")))
            }
            
            guard let data = data else {
                completion(.failure(.error(NSLocalizedString("Error: Data is corrupt/bad", comment: ""))))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decodedData = try decoder.decode(WeatherModel.self, from: data)
                completion(.success(decodedData))
            } catch let decodingError {
                completion(.failure(.error("Error: \(decodingError.localizedDescription)")))
            }
        }.resume()
        
    }
}

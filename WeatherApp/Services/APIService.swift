//
//  APIService.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/21/24.
//

import Foundation

protocol APIServiceProtocol {
    func getData(from endpoint: ApiEndpoint,
                 dateDecodingStrategy: JSONDecoder.DateDecodingStrategy,
                 completion: @escaping (Result<WeatherModel, CustomError>) -> Void)
}

final class APIService: APIServiceProtocol {
    
    static let sharedInstance = APIService()
    
    private init() {}
    
    func getData(from endpoint: ApiEndpoint,
                 dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970,
                 completion: @escaping (Result<WeatherModel, CustomError>) -> Void) {
        
        guard let url = endpoint.url else {
            completion(.failure(.error(NSLocalizedString("Error: Invalid URL", comment: ""))))
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.error("Error: \(error.localizedDescription)")))
                return
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


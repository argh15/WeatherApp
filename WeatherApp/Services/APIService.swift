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
            
            do {
                let decodedData = try decoder.decode(WeatherModel.self, from: data)
                completion(.success(decodedData))
            } catch let decodingError {
                completion(.failure(.error("Error: \(decodingError.localizedDescription)")))
            }
        }.resume()
        
    }
}

//final class APIService {
//
//    typealias NetworkResponse = (data: Data, response: URLResponse)
//
//    static let sharedInstance = APIService()
//
//    private let baseURL = ""
//    private let session = URLSession.shared
//    private let encoder = JSONEncoder()
//    private let decoder = JSONDecoder()
//
//    func getData<D: Decodable>(from endpoint: APIEndpoint) async throws -> D {
//        let request = try createRequest(from: endpoint, with: .GET)
//        let response: NetworkResponse = try await session.data(for: request)
//        return try decoder.decode(D.self, from: response.data)
//    }
//}
//
//private extension APIService {
//    func createRequest(from endpoint: APIEndpoint,
//                       with method: APIRequestMethod) throws -> URLRequest {
//        guard
//            let urlPath = URL(string: baseURL.appending(endpoint.path)),
//            var urlComponents = URLComponents(string: urlPath.path)
//        else {
//            throw APIError.invalidPath
//        }
//
//        if let parameters = endpoint.parameters {
//            urlComponents.queryItems = parameters
//        }
//
//        var request = URLRequest(url: urlPath)
//        request.httpMethod = method.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        return request
//    }
//}

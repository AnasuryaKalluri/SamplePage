//
//  API_HANDLER.swift
//  Asset_Task
//
//  Created by Anasurya on 7/25/24.
//

import UIKit

struct API_HANDLER {
    static func getParse<E:Encodable, D: Decodable >(urlString: String, parameters: E!, completion: @escaping (Result<D, APIError>)-> Void){
        guard let url = URL(string: urlString) else{
            completion(.failure(.forbidden))
            return
        }
        print("URL", url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(parameters)
        URLSession.shared.dataTask(with: request){ data, urlResponse, error in
            if let error = error {
                completion(.failure(.error(error: error)))
                return
            }
            guard let httpResponse = urlResponse as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.badRequest(status: (urlResponse as? HTTPURLResponse)?.statusCode ?? 400)))
                return
            }
            print(httpResponse.statusCode)
            guard let data = data else {
                completion(.failure(.unexpected))
                return
            }
            do{
                if let responseJson = try? JSONDecoder().decode(D.self, from: data){
                    completion(.success(responseJson))
                }else{
                    completion(.failure(.unexpected))
                }
            }
        }.resume()
    }
}


enum APIError: Error{
    case forbidden
    case error(error: Error)
    case badRequest(status: Int)
    case unexpected
}

extension APIError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .forbidden:
            return "URL forbidden"
        case .error(error: let error):
            return "Error with fetching  \(error)"
        case .badRequest(status: let status):
            return "Error with the response, unexpected status code: \(status)"
        case .unexpected:
            return "unexpected error"
        }
    }
}


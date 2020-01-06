//
//  Webservice.swift
//  Zomato
//
//  Created by vikash sahu on 04/01/20.
//  Copyright © 2020 Aripra. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

struct Resource<T: Decodable> {
    let url: URL
    var httpMethod: HttpMethod = .get
    var body: Data? = nil
}

extension Resource {
    init(url: URL) {
        self.url = url 
    }
}

class Webservice {
    private let apiKey : String = "a9ab29fa48cc1d34f06bb799c55ce065"
    
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(apiKey, forHTTPHeaderField: "user-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                completion(.failure(.domainError))
                return
            }
            
            let result = try? JSONDecoder().decode(T.self, from: data)
            
            if let result = result {
                DispatchQueue.main.async {
                    print("api successfull Excecute")
                    completion(.success(result))
                }
            } else {
                completion(.failure(.decodingError))
            }
            
        }.resume()
        
    }
    
}

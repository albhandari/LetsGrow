//
//  NetworkManager.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 1/6/24.
//

import Foundation

protocol NetworkingManager {
    func fetchData(passedUrl: String) async throws -> Data
}


class NetworkingManagerImpl: NetworkingManager {
    
    enum NetworkingError: Error{
        case invalidUrl
        case invalidResponse
    }
    
    func fetchData(passedUrl: String) async throws -> Data{
        print("URL passed: \(passedUrl)")
        guard let url = URL(string: passedUrl) else{
            throw NetworkingError.invalidUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw NetworkingError.invalidResponse
        }
        return data
    }
    
}

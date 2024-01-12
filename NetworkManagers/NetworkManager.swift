//
//  NetworkManager.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 1/6/24.
//

import Foundation

protocol NetworkingManager {
    func fetchData(source: URL) async throws -> Data
}


class NetworkingManagerImpl: NetworkingManager {
    
    static let shared = NetworkingManagerImpl()
    
    private init() {}
    
    enum NetworkingError: Error{
        case invalidUrl
        case invalidResponse
    }
    
    func fetchData(source: URL) async throws -> Data{
        let (data, response) = try await URLSession.shared.data(from: source)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw NetworkingError.invalidResponse
        }
        return data
    }
    
}

import Foundation

//Network Errors
enum NetworkError: Error {
    case invalidURL
    case badResponse(statusCode: Int)
    case decodingError(Error)
    case requestFailed(Error)
}

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(request: URLRequest) async throws -> T
}

final class NetworkManager: NetworkServiceProtocol {
    //Shared Singleton
    static let shared = NetworkManager()
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.badResponse(statusCode: 0)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.badResponse(statusCode: httpResponse.statusCode)
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch let error as NetworkError {
            throw error // Re-throw custom errors
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}

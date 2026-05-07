import Foundation

protocol PersistenceManagerProtocol {
    func saveSession(_ session: UserSession) async throws
    func loadSession() async throws -> UserSession
}

final class LocalPersistenceManager: PersistenceManagerProtocol {
    
    private let fileURL: URL
    
    
    init(fileURL: URL = URL.documentsDirectory.appending(path: "LetsGrow_UserSession.json")) {
        self.fileURL = fileURL
    }
    
    func saveSession(_ session: UserSession) async throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let data = try encoder.encode(session)
        try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
    }
    
    func loadSession() async throws -> UserSession {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return UserSession()
        }
        
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode(UserSession.self, from: data)
    }
}

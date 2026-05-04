import Foundation


protocol PersistenceManagerProtocol {
    func saveSession(_ session: UserSession) async throws
    func loadSession() async throws -> UserSession
}

//Implementation for Local State management using FileManager
final class LocalPersistenceManager: PersistenceManagerProtocol {
    
    func saveSession(_ session: UserSession) async throws {
        
    }
    
    func loadSession() async throws -> UserSession {
        
        return UserSession()
    }
}

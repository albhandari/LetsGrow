import Foundation

//User's gamified state
//Used both locally and synced to Database
struct UserSession: Codable, Equatable {
    var totalCoins: Int = 0
    var activeStreak: Int = 0
    var lastLoginDate: Date = Date()
    
    mutating func addCoins(_ amount: Int) {
        totalCoins += amount
    }
    
    mutating func deductCoins(_ amount: Int) throws {
        guard totalCoins >= amount else {
            throw StoreError.insufficientFunds
        }
        totalCoins -= amount
    }
}

enum StoreError: Error {
    case insufficientFunds
}

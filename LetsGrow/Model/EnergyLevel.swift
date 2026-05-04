import Foundation

//Used for user's current Energy Level
//Will be crucial for timer and task creation
enum EnergyLevel: String, Codable, CaseIterable {
    
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
}

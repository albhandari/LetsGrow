import Foundation


protocol AIProviderProtocol {
    func generateTaskPlan(goal: String, energy: EnergyLevel) async throws -> [TaskItem]
}


//For OpenAI
final class OpenAIProvider: AIProviderProtocol {
    
    
    func generateTaskPlan(goal: String, energy: EnergyLevel) async throws -> [TaskItem] {
        
        return []
    }
}

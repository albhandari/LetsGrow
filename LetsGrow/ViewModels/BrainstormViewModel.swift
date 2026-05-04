import Foundation
import SwiftUI

@Observable
@MainActor
final class BrainstormViewModel {
    // MARK: - Local Form State
    var draftGoal: String = ""
    var draftEnergy: EnergyLevel = .medium
    var isLoading: Bool = false
    
    // MARK: - Local Service
    private let aiProvider: AIProviderProtocol
    
    // Dependency Injection for testability
    init(aiProvider: AIProviderProtocol) {
        self.aiProvider = aiProvider
    }
    
    // MARK: - Local Intent
    //Asks the AI for a plan and returns it to the caller (the View)
    func generateActionPlan() async -> [TaskItem]? {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let generatedTasks = try await aiProvider.generateTaskPlan(goal: draftGoal, energy: draftEnergy)
            // Clear the form on success
            self.draftGoal = ""
            return generatedTasks
        } catch {
            print("Failed to generate plan: \(error)")
            return nil
        }
    }
    
    var isFormValid: Bool {
        !draftGoal.trimmingCharacters(in: .whitespaces).isEmpty && !isLoading
    }
}

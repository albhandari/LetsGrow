import Foundation

// Mock AIProvider Service for testing without hitting endpoint
final class MockAIProvider: AIProviderProtocol {
    
    
    func generateTaskPlan(userInput: String, energy: EnergyLevel) async throws -> TaskItem {
        
        // Simulate network wait time
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        //Mock subtasks
        let mockSubtasks = [
            Subtask(title: "Step 1: Gather your materials", estimatedMinutes: 5),
            Subtask(title: "Step 2: Execute the core work", estimatedMinutes: energy == .low ? 15 : 30),
            Subtask(title: "Step 3: Review and cool down", estimatedMinutes: 5)
        ]
        
        //Calculate the total time for all the steps
        let totalMinutes = mockSubtasks.reduce(0) { $0 + $1.estimatedMinutes }
        
        return TaskItem(
            title: userInput,
            estimatedMinutes: totalMinutes,
            subtasks: mockSubtasks
        )
    }
}

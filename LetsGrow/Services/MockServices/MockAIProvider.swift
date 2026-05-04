import Foundation

//Mock AIProvider Service for testing without hitting endpoint
final class MockAIProvider: AIProviderProtocol {
    func generateTaskPlan(goal: String, energy: EnergyLevel) async throws -> [TaskItem] {
        
        //Simulate wait time
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return [
            TaskItem(title: "Step 1: Just open the app", estimatedMinutes: 2),
            TaskItem(title: "Step 2: Breathe for 30 seconds", estimatedMinutes: 1),
            TaskItem(title: "Step 3: Write one line of code", estimatedMinutes: 5)
        ]
    }
}

import Observation
import Foundation

@Observable
@MainActor
final class AppStore {
    // MARK: - Global Variables
    var session = UserSession()
    var activeTasks: [TaskItem] = []
    
    //Running Timer properties shared across app
    var timeRemaining: Int = 0
    var isTimerRunning: Bool = false
    
    // MARK: - Global Intents
    func saveNewPlan(tasks: [TaskItem]) {
        self.activeTasks = tasks
        // Trigger local persistence save here
    }
    
    func completeTask(id: UUID) {
        if let index = activeTasks.firstIndex(where: { $0.id == id }) {
            activeTasks[index].isCompleted = true
        }
    }
}

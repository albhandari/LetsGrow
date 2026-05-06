import Observation
import Foundation

@Observable
@MainActor
final class AppStore {
    // MARK: - Global State
    
    // The Master Session (Volatile for now, resets on app close)
    var session = UserSession()
    
    // Timer State (Shared across the app)
    var timeRemaining: Int = 0
    var isTimerRunning: Bool = false
    
    // MARK: - Global Intents
    
    // Adds a newly generated parent task (and its subtasks) to the session
    func addNewTask(_ task: TaskItem) {
        session.activeTasks.append(task)
    }
    
    // Finds the specific subtask inside the specific parent task and toggles it
    func toggleSubtask(taskId: UUID, subtaskId: UUID) {
        // 1. Find the parent task
        guard let taskIndex = session.activeTasks.firstIndex(where: { $0.id == taskId }),
              // 2. Find the child subtask inside that parent task
              let subtaskIndex = session.activeTasks[taskIndex].subtasks.firstIndex(where: { $0.id == subtaskId }) else {
            return
        }
        
        // 3. Toggle the completion status
        session.activeTasks[taskIndex].subtasks[subtaskIndex].isCompleted.toggle()
        
        // Future Gamification Hook: Reward the user for checking it off!
        if session.activeTasks[taskIndex].subtasks[subtaskIndex].isCompleted {
             session.addCoins(5)
        }
    }
}

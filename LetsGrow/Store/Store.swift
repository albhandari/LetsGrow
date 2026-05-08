import Observation
import Foundation

@Observable
@MainActor
final class AppStore {
    // MARK: - Global State
    
    // The Master Session (Now tied to the hard drive!)
    var session = UserSession()
    
    // Timer State
    var timeRemaining: Int = 0
    var isTimerRunning: Bool = false
    
    // MARK: - Dependencies
    private let persistenceManager: PersistenceManagerProtocol
    
    //Make parameter optional to allow for dependency injection
    init(persistenceManager: PersistenceManagerProtocol? = nil) {
        //Creates the default instance inside MainActor
        self.persistenceManager = persistenceManager ?? LocalPersistenceManager()
        
        // As soon as the AppStore is created, load the saved data
        Task {
            await initializeSession()
        }
    }
    
    // MARK: - Core Persistence Logic
    private func initializeSession() async {
        do {
            self.session = try await persistenceManager.loadSession()
            print("Successfully loaded session with \(session.activeTasks.count) tasks.")
        } catch {
            print("Failed to load session, starting fresh. Error: \(error)")
        }
    }
    
    private func saveToDisk() {
        // Capture the current session to safely save it in the background
        let currentSession = self.session
        Task {
            do {
                try await persistenceManager.saveSession(currentSession)
                print("Session saved securely to disk.")
            } catch {
                print("Failed to save session: \(error)")
            }
        }
    }
    
    // MARK: - Global Intents
    
    func toggleSubtask(taskId: UUID, subtaskId: UUID) {
        // 1. Iterate through the Tasks to find the exact indexes of the task and the subtask
        guard let taskIndex = session.activeTasks.firstIndex(where: { $0.id == taskId }),
              let subtaskIndex = session.activeTasks[taskIndex].subtasks.firstIndex(where: { $0.id == subtaskId }) else {
            return
        }
        
        // 2. Toggle the visual UI state
        session.activeTasks[taskIndex].subtasks[subtaskIndex].isCompleted.toggle()
        
        // 3. Assess the payout math
        processSubtaskPayout(taskIndex: taskIndex, subtaskIndex: subtaskIndex)
        
        // 4. Check if all subtasks are completed for the main task
        checkParentCompletion(taskIndex: taskIndex)
        
        // 5. Save to hard drive
        saveToDisk()
    }
    
    // MARK: - Private Logic Helpers
    
    //Handle payout per subtask and overall task without duplicates/exploit
    private func processSubtaskPayout(taskIndex: Int, subtaskIndex: Int) {
        let isDone = session.activeTasks[taskIndex].subtasks[subtaskIndex].isCompleted
        let alreadyPaid = session.activeTasks[taskIndex].subtasks[subtaskIndex].hasAwardedCoins
        
        if isDone && !alreadyPaid {
            session.addCoins(5)
            session.activeTasks[taskIndex].subtasks[subtaskIndex].hasAwardedCoins = true
            print("Payout successful! 5 coins added.")
        } else if isDone && alreadyPaid {
            print("Exploit blocked: User already received coins for this task.")
        }
    }
    
    //Check wether the main task is completed by checking wether all the subtasks are completed
    private func checkParentCompletion(taskIndex: Int) {
        let allSubtasksDone = session.activeTasks[taskIndex].subtasks.allSatisfy { $0.isCompleted }
        let isParentAlreadyDone = session.activeTasks[taskIndex].isCompleted
        
        // Only trigger the bonus if it's transitioning from incomplete to complete
        if allSubtasksDone && !isParentAlreadyDone {
            session.activeTasks[taskIndex].isCompleted = true
            session.addCoins(20)
            print("Parent Task Complete! 20 Bonus Coins awarded.")
            
        } else if !allSubtasksDone {
            // Un-complete parent if a subtask gets unchecked
            session.activeTasks[taskIndex].isCompleted = false
        }
    }
}

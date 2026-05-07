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
    
    func addNewTask(_ task: TaskItem) {
        session.activeTasks.append(task)
        saveToDisk() // Trigger a save
    }
    
    func toggleSubtask(taskId: UUID, subtaskId: UUID) {
        guard let taskIndex = session.activeTasks.firstIndex(where: { $0.id == taskId }),
              let subtaskIndex = session.activeTasks[taskIndex].subtasks.firstIndex(where: { $0.id == subtaskId }) else {
            return
        }
        
        // 1. Toggle the visual completion status
        session.activeTasks[taskIndex].subtasks[subtaskIndex].isCompleted.toggle()
        
        // 2. The Exploit Fix: Check the vault lock
        let isDone = session.activeTasks[taskIndex].subtasks[subtaskIndex].isCompleted
        let alreadyPaid = session.activeTasks[taskIndex].subtasks[subtaskIndex].hasAwardedCoins
        
        if isDone && !alreadyPaid {
            session.addCoins(5)
            session.activeTasks[taskIndex].subtasks[subtaskIndex].hasAwardedCoins = true
            print("💰 Payout successful! 5 coins added.")
        } else if isDone && alreadyPaid {
            print("🛡️ Exploit blocked: User already received coins for this task.")
        }
        
        
        // 3. Check if EVERY subtask inside this parent is now completed
        let allSubtasksDone = session.activeTasks[taskIndex].subtasks.allSatisfy { $0.isCompleted == true }
        
        if allSubtasksDone {
            // 4. Mark the parent as complete!
            session.activeTasks[taskIndex].isCompleted = true
            
            // 5. THE BIG PAYOUT: Give a bonus for finishing the whole goal
            session.addCoins(20)
            print("🎉 Parent Task Complete! 20 Bonus Coins awarded.")
            
        } else {
            // If they uncheck a subtask, un-complete the parent just in case
            session.activeTasks[taskIndex].isCompleted = false
        }
        
        saveToDisk() // Trigger a background save
    }
}

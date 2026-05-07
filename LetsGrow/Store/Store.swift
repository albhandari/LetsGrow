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
        
        //Toggle the visual completion status so the UI updates immediately
        session.activeTasks[taskIndex].subtasks[subtaskIndex].isCompleted.toggle()
        
        // The Exploit Fix: make sure the task isn't being re-done for duplicate payment
        let isDone = session.activeTasks[taskIndex].subtasks[subtaskIndex].isCompleted
        let alreadyPaid = session.activeTasks[taskIndex].subtasks[subtaskIndex].hasAwardedCoins
        
        if isDone && !alreadyPaid {
            //First time completing so pay the user.
            session.addCoins(5)
            
            //Lock the vault so they can't farm this subtask again
            session.activeTasks[taskIndex].subtasks[subtaskIndex].hasAwardedCoins = true
            
            print("Payout successful! 5 coins added!")
        } else if isDone && alreadyPaid {
            // They are trying to spam the button. Block the payout.
            print("User already received coins for this task.")
        }
        
        saveToDisk() // Trigger a background save
    }
}

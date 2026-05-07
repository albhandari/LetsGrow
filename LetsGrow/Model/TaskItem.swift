import Foundation


struct TaskItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    let title: String
    let estimatedMinutes: Int
    var isCompleted: Bool = false
    var targetDate: Date?
    
    var subtasks: [Subtask] = []
    
}

struct Subtask: Identifiable, Codable, Equatable{
    var id: UUID = UUID()
    var title: String
    var estimatedMinutes: Int
    var isCompleted: Bool = false
    var scheduledDate: Date?
    
    var hasAwardedCoins: Bool = false
}

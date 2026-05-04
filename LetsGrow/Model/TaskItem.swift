import Foundation


struct TaskItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    let title: String
    let estimatedMinutes: Int
    var isCompleted: Bool = false
    
    
    enum CodingKeys: String, CodingKey {
        case title
        case estimatedMinutes
    }
}

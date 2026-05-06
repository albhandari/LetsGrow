import Foundation

struct AITaskResponse: Codable {
    let title: String
    let estimatedMinutes: Int
    let targetDate: Date?
    let subtasks: [AISubtaskResponse]
    
    //Converts AI Response into TaskItem Object
    func toDomainModel() -> TaskItem {
        let mappedSubtasks = subtasks.map {
            Subtask(title: $0.title, estimatedMinutes: $0.estimatedMinutes, scheduledDate: $0.scheduledDate)
        }
        return TaskItem(title: title, estimatedMinutes: estimatedMinutes, targetDate: targetDate, subtasks: mappedSubtasks)
    }
}

struct AISubtaskResponse: Codable {
    let title: String
    let estimatedMinutes: Int
    let scheduledDate: Date?
}

struct OpenAIResponseWrapper: Codable {
    let choices: [Choice]
    struct Choice: Codable { let message: Message }
    struct Message: Codable { let content: String }
}

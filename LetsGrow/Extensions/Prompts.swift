import Foundation

enum AIPrompts {
    static func taskBreakdown(userInput: String, energy: EnergyLevel) -> String {
        
        //get current date to make tasks for AI context
        let todayISO = ISO8601DateFormatter().string(from: Date())
        
        return """
        You are a high-performance productivity coach. 
        The user's main task is: "\(userInput)".
        Today's date and time is: \(todayISO).
        The user's energy capacity is: \(energy.rawValue).
        
        Your job is to atomize this main task into actionable steps. 
        Analyze the complexity of the user's task and break it down into an appropriate number of subtasks (between 2 and 6 steps).
        
        Rules:
        1. Adjust estimatedMinutes based on the energy level and the complexity of each specific step.
        2. All dates must be strictly in ISO8601 format.
        3. Respond ONLY with valid JSON matching this exact structure, expanding the subtasks array as needed:
        { "title": "Clean title", "estimatedMinutes": 45, "targetDate": "2026-05-20T00:00:00Z", "subtasks": [ { "title": "Step", "estimatedMinutes": 15, "scheduledDate": "2026-05-06T10:00:00Z" } ] }
        """
    }
}

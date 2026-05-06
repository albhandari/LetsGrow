import Foundation

protocol AIProviderProtocol {
    
    func generateTaskPlan(goal: String, energy: EnergyLevel) async throws -> TaskItem
}

final class OpenAIProvider: AIProviderProtocol {
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkManager.shared) {
        self.networkService = networkService
    }
    
    func generateTaskPlan(goal: String, energy: EnergyLevel) async throws -> TaskItem {
        guard let url = URL(string: endpoint) else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(Secrets.openAIKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Give the AI the current date so it can calculate "tomorrow", "next week", etc.
        let todayISO = ISO8601DateFormatter().string(from: Date())
        
        let systemPrompt = """
        You are a high-performance productivity coach. 
        The user's goal is: "\(goal)".
        Today's date and time is: \(todayISO).
        The user's energy capacity is: \(energy.rawValue).
        
        Your job is to atomize this goal into exactly 3 actionable steps, calculate the estimated time, and assign logical dates based on today's date.
        
        Rules:
        1. Adjust estimatedMinutes based on the energy level.
        2. All dates must be strictly in ISO8601 format (e.g., "2026-05-15T10:00:00Z").
        3. Respond ONLY with valid JSON matching this exact structure:
        {
          "title": "Clean, verb-driven title based on the goal",
          "estimatedMinutes": 45,
          "targetDate": "2026-05-20T00:00:00Z",
          "subtasks": [
            {
              "title": "Step description",
              "estimatedMinutes": 15,
              "scheduledDate": "2026-05-06T10:00:00Z"
            }
          ]
        }
        """
        
        let requestBody: [String: Any] = [
            "model": "gpt-4o-mini",
            "response_format": ["type": "json_object"],
            "messages": [
                ["role": "system", "content": systemPrompt]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let openAIResponse: OpenAIResponseWrapper = try await networkService.fetch(request: request)
        
        guard let jsonString = openAIResponse.choices.first?.message.content,
              let jsonData = jsonString.data(using: .utf8) else {
            throw NetworkError.decodingError(NSError(domain: "OpenAI JSON string missing", code: -1))
        }
        
        //Decode the json to TaskItem
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // Tells Swift how to read the AI's dates
        
        let generatedTask = try decoder.decode(TaskItem.self, from: jsonData)
        return generatedTask
    }
}


private struct OpenAIResponseWrapper: Codable {
    let choices: [Choice]
    struct Choice: Codable { let message: Message }
    struct Message: Codable { let content: String }
}

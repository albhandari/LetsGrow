import Foundation


protocol AIProviderProtocol {
    func generateTaskPlan(goal: String, energy: EnergyLevel) async throws -> [TaskItem]
}


final class OpenAIProvider: AIProviderProtocol {
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    
    //NetworkService Dependency
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkManager.shared) {
        self.networkService = networkService
    }
    
    func generateTaskPlan(goal: String, energy: EnergyLevel) async throws -> [TaskItem] {
        guard let url = URL(string: endpoint) else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(Secrets.openAIKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let systemPrompt = """
        You are a high-performance productivity coach. The user will provide a high-level goal and their current energy capacity (\(energy.rawValue)).
        Your job is to atomize this goal into EXACTLY 3 highly actionable, low-friction steps.
        
        Rules:
        1. Keep titles short and punchy (start with a verb).
        2. Adjust estimatedMinutes based on the energy level (low energy = shorter tasks).
        3. Respond ONLY with valid JSON matching this exact structure:
        {
          "tasks": [
            { "title": "Step description", "estimatedMinutes": 5 }
          ]
        }
        """
        
        let requestBody: [String: Any] = [
            "model": "gpt-4o-mini",
            "response_format": ["type": "json_object"],
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": "Goal: \(goal)"]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        // Networking Manager handles fetching raw data
        let openAIResponse: OpenAIResponseWrapper = try await networkService.fetch(request: request)
        
        // Data gets decoded into Swift object to [TaskItem]
        guard let jsonString = openAIResponse.choices.first?.message.content,
              let jsonData = jsonString.data(using: .utf8) else {
            throw NetworkError.decodingError(NSError(domain: "OpenAI JSON string missing", code: -1))
        }
        
        let taskList = try JSONDecoder().decode(TaskList.self, from: jsonData)
        return taskList.tasks
    }
}

// MARK: - Private DTOs
private struct OpenAIResponseWrapper: Codable {
    let choices: [Choice]
    struct Choice: Codable { let message: Message }
    struct Message: Codable { let content: String }
}

private struct TaskList: Codable {
    let tasks: [TaskItem]
}

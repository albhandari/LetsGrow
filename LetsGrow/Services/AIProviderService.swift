import Foundation

protocol AIProviderProtocol {
    
    func generateTaskPlan(userInput: String, energy: EnergyLevel) async throws -> TaskItem
}

final class OpenAIProvider: AIProviderProtocol {
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkManager.shared) {
        self.networkService = networkService
    }
    
    func generateTaskPlan(userInput: String, energy: EnergyLevel) async throws -> TaskItem {
        
        //Get prompt from AIPrompts (Prompts.swift)
        let systemPrompt = AIPrompts.taskBreakdown(userInput: userInput, energy: energy)
        
        //Generate the request that will be sent to OpenAI
        let request = try buildOpenAIRequest(prompt: systemPrompt, userInput: userInput)
        
        //Fetch Data
        let openAIResponse: OpenAIResponseWrapper = try await networkService.fetch(request: request)
        
        //Extract and Decode the response to JSON (if valid)
        guard let jsonString = openAIResponse.choices.first?.message.content,
              let jsonData = jsonString.data(using: .utf8) else {
            throw NetworkError.decodingError(NSError(domain: "OpenAI JSON missing", code: -1))
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        //Decode the JSON into AITaskResponse
        let aiResponse = try decoder.decode(AITaskResponse.self, from: jsonData)
        
        //Convert the AITaskResponse to TaskItem Object
        return aiResponse.toDomainModel()
        
    }
    
    
    private func buildOpenAIRequest(prompt: String, userInput: String) throws -> URLRequest {
        guard let url = URL(string: endpoint) else{
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(Secrets.openAIKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "model": "gpt-4o-mini",
            "response_format": ["type": "json_object"],
            "messages": [
                ["role": "system", "content": prompt],
                ["role": "user", "content": userInput]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        return request
        
        
    }
}


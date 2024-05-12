//
//  ChatbotViewModel.swift
//  DHC
//
//  Created by Trio on 8.05.2024.
//

import Foundation

class ChatbotViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var chatHistory: [Message] = []
    
    private let chatbotClient = ChatbotClient()
    
    func sendMessage() {
        let userInput = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userInput.isEmpty else { return }
        
        let userMessage = Message(text: "You: " + userInput, isFromUser: true)
        chatHistory.append(userMessage)
        
        inputText = ""
        
        chatbotClient.sendMessage(prompt: userInput) { [weak self] response in
            DispatchQueue.main.async {
                if let response = response {
                    // Add bot message to chat history
                    let botMessage = Message(text: "Assistant: " + response, isFromUser: false)
                    self?.chatHistory.append(botMessage)
                } else {
                    // Add error message to chat history
                    let errorMessage = Message(text: "Assistant: Error fetching response", isFromUser: false)
                    self?.chatHistory.append(errorMessage)
                }
            }
        }
    }
}

struct Message: Hashable {
    let id = UUID()
    let text: String
    let isFromUser: Bool
    
}

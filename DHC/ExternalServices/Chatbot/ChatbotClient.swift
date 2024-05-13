//
//  ChatbotClient.swift
//  DHC
//
//  Created by Trio on 8.05.2024.
//

import Foundation

class ChatbotClient {
    private let baseURL = URL(string: "http://localhost:5000/chat")!
    
    func sendMessage(prompt: String, completion: @escaping (String?) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestData: [String: String] = ["prompt": prompt]
        let jsonData = try? JSONSerialization.data(withJSONObject: requestData)
        request.httpBody = jsonData
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 240
        
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
            } else if let data = data,
                      let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 {
                if let responseData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let responseText = responseData["response"] as? String {
                    completion(responseText)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
}

//
//  ChatbotView.swift
//  DHC
//
//  Created by Trio on 8.05.2024.
//

//
//  ChatbotView.swift
//  DHC
//
//  Created by Trio on 8.05.2024.
//

import SwiftUI

struct ChatbotView: View {
    @ObservedObject var viewModel = ChatbotViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.chatHistory, id: \.self) { message in
                        Text(message.text)
                            .foregroundColor(message.isFromUser ? Color.blue : Color.black)
                            .padding(Spacing.spacing_2)
                            .background(message.isFromUser ? Color.gray.opacity(0.2) : Color.white)
                            .cornerRadius(Radius.radius_2)
                            .padding(.horizontal, Spacing.spacing_2)
                    }
                }
            }
            
            HStack {
                TextField("Enter your message", text: $viewModel.inputText)
                    .padding(Spacing.spacing_2)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(Radius.radius_2)
                    .disableAutocorrection(true)
                
                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Text("Send")
                        .padding(Spacing.spacing_2)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(Radius.radius_2)
                }
            }
            .padding()
        }
    }
}

struct ChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotView()
    }
}

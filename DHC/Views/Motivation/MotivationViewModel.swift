//
//  MotivationViewModel.swift
//  DHC
//
//  Created by Lab on 28.03.2024.
//

import Foundation
import UserNotifications

class MotivationViewModel: ObservableObject {
    func sendMotivationQuote() {
        let motivationQuotes = [
            "Life is not a marathon, it's like a sprint. Give your best performance!",
            "Success comes as a result of hard work. Never give up!",
            "Push your limits and go beyond them. That's the only way you'll grow.",
            "Every workout is an investment. Work for your future success today.",
            "Victory comes with the taste of sweat. Every drop of sweat brings you closer.",
            "Exercising is good not only for your body but also for your mind.",
            "Always give your best for success, results will come naturally.",
            "Exercising is a way to discover and improve your strength.",
            "Obstacles are only limitations existing in our minds. We can overcome them!",
            "Exercise is not just an activity, it's a lifestyle."
               
        ]
        let identifier = "my-morning-notification"
        let title = "Time to Move"
               
        let randomQuote = motivationQuotes.randomElement() ?? ""

               
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = randomQuote
               
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60*5, repeats: true)
               
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
               
        notificationCenter.add(request) { (error) in
                   if let error = error {
                       print("Error when adding notification: \(error)")
                   } else {
                       print("Notification added succesfully.")
                   }

                   
               }
           }
    
}

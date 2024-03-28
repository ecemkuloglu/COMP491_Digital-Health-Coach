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
            "Hayat bir maraton değil, sprint gibidir. En iyi performansınızı sergileyin!",
            "Sıkı çalışmanın sonucunda başarı gelir. Asla vazgeçmeyin!",
            "Sınırlarınızı zorlayın ve sınırlarınızın ötesine geçin. Sadece bu şekilde gelişirsiniz.",
            "Her antrenman bir yatırımdır. Gelecekteki başarınız için bugün çalışın.",
            "Zafer terinin tadıyla gelir. Her ter damlası size daha yaklaştırır.",
            "Spor yapmak, bedeninizin yanı sıra zihniniz için de iyidir.",
            "Başarı için her zaman en iyisini verin, sonuçlar kendiliğinden gelecektir.",
            "Spor yapmak, gücünüzü keşfetmenin ve geliştirmenin bir yoludur.",
            "Engeller sadece zihnimizde var olan sınırlamalardır. Onları aşabiliriz!",
            "Spor sadece bir aktivite değil, bir yaşam tarzıdır.",
               
        ]
        let identifier = "my-morning-notification"
        let title = "Hadi Hareketlen"
               
        let randomQuote = motivationQuotes.randomElement() ?? ""

               
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = randomQuote
               
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60*5, repeats: true)
               
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
               
        notificationCenter.add(request) { (error) in
                   if let error = error {
                       print("Bildirim ekleme hatası: \(error)")
                   } else {
                       print("Bildirim başarıyla eklendi.")
                   }

                   
               }
           }
    
}

//
//  DHCApp.swift
//  DHC
//
//  Created by Aylin Melek on 5.03.2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if let error = error {
                print("Bildirim izni isteği hatası: \(error)")
            } else {
                print("Bildirim izni başarıyla alındı.")
            }
        }
        UNUserNotificationCenter.current().delegate = self
        MotivationViewModel().sendMotivationQuote()
        
        //Task {
        //          do {
        //            let exercises = try await ExerciseDoneManager.shared.fetchAllExercises()
        //          exercises.forEach { exercise in
        //            print("Exercise: \(exercise.exercise), Duration: \(exercise.duration), Date: \(exercise.date)")
        //    }
        //} catch {
        //  print("Error fetching exercises: \(error)")
        //}
        //}
        
        return true
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
}

@main
struct DHCApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}




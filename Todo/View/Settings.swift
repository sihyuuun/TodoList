//
//  Settings.swift
//  Todo
//
//  Created by 이시현 on 3/17/24.
//

import SwiftUI

struct Settings: View {
    @State private var isNotificationsEnabled: Bool = UserDefaults.standard.bool(forKey: "isNotificationsEnabled")
    @State private var notificationTime: Date = UserDefaults.standard.object(forKey: "notificationTime") as? Date ?? Date()
    
    var body: some View {
        Form {
            Toggle("Enable Notifications", isOn: $isNotificationsEnabled)
                .onChange(of: isNotificationsEnabled) {
                    UserDefaults.standard.set(isNotificationsEnabled, forKey: "isNotificationsEnabled")
                    if !isNotificationsEnabled {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    }
                }
            
            if isNotificationsEnabled {
                DatePicker("Notification Time", selection: $notificationTime, displayedComponents: .hourAndMinute)
                    .onChange(of: notificationTime) {
                        UserDefaults.standard.set(notificationTime, forKey: "notificationTime")
                        scheduleNotifications()
                    }
            }
        }
        .navigationTitle("Settings")
    }
    
    func scheduleNotifications() {
        // Ensure notifications are enabled before scheduling
        guard UserDefaults.standard.bool(forKey: "isNotificationsEnabled") else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Todo List"
        content.body = "Don't forget to check your todo list!"
        content.sound = UNNotificationSound.default
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: notificationTime)
        // Configure the trigger for a repeating notification
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create the request and add our notification request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

#Preview {
    Settings()
}

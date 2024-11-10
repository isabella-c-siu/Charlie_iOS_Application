import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    // Check and request notification permission
    func checkAndRequestPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                print("Notification permission: Authorized")
                self.scheduleNotification()
                
            case .denied:
                print("Notification permission: Denied")
                // Optionally, you could direct the user to Settings if denied
                
            case .notDetermined:
                print("Notification permission: Not Determined")
                // Request permission as user hasn't been asked yet
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        print("User granted permission.")
                        self.scheduleNotification()
                    } else {
                        print("User denied permission.")
                    }
                }
                
            @unknown default:
                print("Notification permission: Unknown status")
            }
        }
    }
    
    // Schedule a notification every 30 seconds
    private func scheduleNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Charlie says:"
        content.body = "Time to get hydrated!"
        content.sound = .default
        
        // Set up the time interval trigger for 30 seconds, with repeating enabled
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        let request = UNNotificationRequest(identifier: "hydration-notification", content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }
}

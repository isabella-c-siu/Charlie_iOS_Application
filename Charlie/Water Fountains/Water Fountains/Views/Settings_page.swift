//
//  Settings_page.swift
//  Water Fountains
//
//  Created by Jay Zhao on 11/9/24.
//

//import SwiftUI
//
//// MARK: - Views Folder: SettingsView.swift
//// This file will be located under Water Fountains/Views
//struct SettingsView: View {
//    @Binding var intakeGoal: Double
//    @State private var userName: String = "User"// New state for user name input
//    @Environment(\EnvironmentValues.presentationMode) private var presentationMode // Corrected environment declaration
//    @State private var notificationsEnabled: Bool = false // State for toggle
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Goal")) {
//                    TextField("Enter daily water intake in mL", value: $intakeGoal, format: .number)
//                        .keyboardType(.decimalPad)
//                }
//
//                Section(header: Text("User Information")) {
//                    TextField("Enter your name", text: $userName)
//                        .onChange(of: userName) { newValue in
//                            if !newValue.isEmpty {
//                                userName = newValue
//                            }
//                        }
//                }
//                Section(header: Text("Notifications")) {
//                    Toggle(isOn: $notificationsEnabled) {
//                        Text("Enable Notifications")
//                    }
//                    .onChange(of: notificationsEnabled) { isEnabled in
//                        if isEnabled {
//                            requestNotificationPermission()
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Hey, \(userName)!") // Dynamic title using user name
//            .navigationBarItems(trailing: Button(action: { presentationMode.wrappedValue.dismiss() }) {
//                Image(systemName: "xmark")
//                    .foregroundColor(.primary)
//            })
//        }
//    }
//    private func requestNotificationPermission() {
//        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.getNotificationSettings { settings in
//            DispatchQueue.main.async {
//                switch settings.authorizationStatus {
//                case .authorized:
//                    print("Notifications are already authorized.")
//                case .denied:
//                    notificationsEnabled = false // Turn off toggle if denied
//                    showSettingsAlert()
//                case .notDetermined:
//                    notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
//                        DispatchQueue.main.async {
//                            notificationsEnabled = didAllow
//                            if !didAllow {
//                                showSettingsAlert()
//                            }
//                        }
//                    }
//                default:
//                    break
//                }
//            }
//        }
//    }
//
//    private func showSettingsAlert() {
//        let alert = UIAlertController(
//            title: "Enable Notifications",
//            message: "To receive notifications, enable them in Settings.",
//            preferredStyle: .alert
//        )
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
//            if let url = URL(string: UIApplication.openSettingsURLString),
//               UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url)
//            }
//        })
//        
//        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
//    }
//}
//
//
//
//struct SettingsView_Previews: PreviewProvider {
//    @State static var previewIntakeGoal: Double = 1000.0
//
//    static var previews: some View {
//        SettingsView(intakeGoal: $previewIntakeGoal)
//    }
//}

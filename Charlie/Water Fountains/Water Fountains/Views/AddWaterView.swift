//
//  AddWaterView.swift
//  Water Fountains
//
//  Created by Jay Zhao on 11/8/24.
//

import SwiftUI

struct AddWaterView: View {
    @Binding var totalIntake: Double // Binding to update the total intake in ContentView
    @State private var intakeAmount: String = "" // State to hold the input value
    @Binding var isPresented: Bool // Binding to control the presentation of the view

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter amount (mL)")) {
                    TextField("Amount", text: $intakeAmount)
                        .keyboardType(.decimalPad) // Ensuring the keyboard shows numbers and decimals
                }
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false // Dismiss the view if "Cancel" is tapped
                },
                trailing: Button("Add") {
                    // Try to convert the input string to a double and check if it's greater than 0
                    if let amount = Double(intakeAmount), amount > 0 {
                        // Debugging statement to confirm successful conversion
                        print("Debug: Successfully converted intakeAmount to Double. Amount is \(amount)")
                        
                        // Update the total intake in ContentView
                        totalIntake += amount
                        
                        // Dismiss the view after saving
                        isPresented = false
                    } else {
                        // Debugging statement if conversion fails or amount is not greater than 0
                        print("Debug: Conversion failed or amount is not greater than 0. intakeAmount: \(intakeAmount)")
                    }
                }
            )
            .navigationTitle("Add Water")
        }
    }
}




struct AddWaterView_Previews: PreviewProvider {
    @State static var totalIntake: Double = 0.0 // Track total intake in the preview
    @State static var isPresented = true

    static var previews: some View {
        AddWaterView(totalIntake: $totalIntake, isPresented: $isPresented)
            .onAppear {
                // Print the initial total intake value when the preview appears
                print("Preview - Initial Total Intake: \(totalIntake) mL")
            }
            .onChange(of: totalIntake) { newValue in
                // Print the total intake when it changes in the preview
                print("Preview - Total Intake updated to: \(newValue) mL")
            }
    }
}

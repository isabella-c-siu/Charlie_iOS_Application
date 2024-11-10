//
//  GoalReachedView.swift
//  Water Fountains
//
//  Created by Jay Zhao on 11/9/24.
//

import SwiftUI

struct GoalReachedView: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("You've reached your goal! 🎉")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("Congratulations on hitting your water intake goal!")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: {
                isPresented = false // Dismiss the pop-up
            }) {
                Text("Continue")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .frame(maxWidth: 300)
    }
}

struct GoalReachedView_Previews: PreviewProvider {
    @State static var isPresented = true

    static var previews: some View {
        GoalReachedView(isPresented: $isPresented)
    }
}

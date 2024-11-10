//
//  ContentView.swift
//  Water Fountains
//
//  Created by Jay Zhao on 11/8/24.
//

// MARK: - Views Folder: ContentView.swift
// This file will be located under Water Fountains/Views
import SwiftUI
import UIKit
import UserNotifications

// MARK: - Views Folder: ContentView.swift
// This file will be located under Water Fountains/Views

// MARK: - Views Folder: ContentView.swift
// This file will be located under Water Fountains/Views

// MARK: - Views Folder: ContentView.swift
// This file will be located under Water Fountains/Views

// MARK: - Views Folder: ContentView.swift
// This file will be located under Water Fountains/Views

// MARK: - Views Folder: ContentView.swift
// This file will be located under Water Fountains/Views

// MARK: - Views Folder: ContentView.swift
// This file will be located under Water Fountains/Views

// MARK: - Views Folder: ContentView.swift
// This file will be located under Water Fountains/Views

// MARK: - Views Folder: ContentView.swift

//struct WaterIntakeView: View {
//    @State private var waterIntakes: [WaterIntake] = []
//    @State private var currentIntake: Double = 0.0
//    @State private var showingAddWaterSheet = false
//    @State private var totalIntake: Double = 0.0
//    @State private var intakeGoal: Double = 100.0
//    @State private var showGoalReachedPopup = false
//    @State private var waveOffset = Angle(degrees: 0) // For wave animation
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                Text("Water Tracker")
//                    .font(.system(size: 36, weight: .bold))
//                    .padding(.top, 40)
//
//                ZStack(alignment: .bottom) {
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color.gray.opacity(0.2))
//                        .frame(width: 200, height: 400)
//                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 2))
//
//                    // Blue rectangle with wave overlay
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 20)
//                            .fill(Color.blue.opacity(0.5))
//                            .frame(width: 200, height: min((CGFloat(totalIntake) / intakeGoal * 400), 400))
//                            .animation(.easeInOut, value: totalIntake)
//
//                        // Wave overlay
//                        Wave(offSet: waveOffset, percent: min(totalIntake / intakeGoal * 100, 100))
//                            .fill(Color.blue)
//                            .frame(width: 200, height: min((CGFloat(totalIntake) / intakeGoal * 400), 400))
//                            .clipShape(RoundedRectangle(cornerRadius: 20)) // Clip to rounded rectangle shape
//                            .animation(.easeInOut, value: totalIntake)
//                    }
//                }
//                .padding()
//                .onChange(of: totalIntake) { newValue in
//                    if newValue >= intakeGoal {
//                        showGoalReachedPopup = true
//                        let overflow = newValue - intakeGoal
//                        totalIntake = overflow
//                    }
//                }
//                .onAppear {
//                    withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
//                        self.waveOffset = Angle(degrees: 360)
//                    }
//                }
//
//                Button(action: {
//                    showingAddWaterSheet.toggle()
//                }) {
//                    HStack {
//                        Image(systemName: "plus")
//                            .font(.system(size: 20, weight: .heavy, design: .rounded))
//                        Text("WATER")
//                            .font(.system(.body, design: .rounded))
//                            .fontWeight(.heavy)
//                    }
//                    .padding()
//                    .frame(width: 200)
//                    .background(Color.black)
//                    .foregroundColor(.white)
//                    .cornerRadius(25)
//                }
//                .padding()
//            }
//            .sheet(isPresented: $showGoalReachedPopup) {
//                GoalReachedView(isPresented: $showGoalReachedPopup)
//            }
//            .sheet(isPresented: $showingAddWaterSheet) {
//                AddWaterView(totalIntake: $totalIntake, isPresented: $showingAddWaterSheet)
//            }
//            .navigationBarHidden(true)
//        }
//    }
//}
//
//// Wave Shape Implementation
//struct Wave: Shape {
//    var offSet: Angle
//    var percent: Double
//
//    var animatableData: Double {
//        get { offSet.degrees }
//        set { offSet = Angle(degrees: newValue) }
//    }
//
//    func path(in rect: CGRect) -> Path {
//        var p = Path()
//
//        let lowestWave = 0.02
//        let highestWave = 1.00
//        let newPercent = lowestWave + (highestWave - lowestWave) * (percent / 100)
//        let waveHeight = 0.015 * rect.height
//        let yOffSet = CGFloat(1 - newPercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
//        let startAngle = offSet
//        let endAngle = offSet + Angle(degrees: 360 + 10)
//
//        p.move(to: CGPoint(x: 0, y: yOffSet + waveHeight * CGFloat(sin(offSet.radians))))
//
//        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
//            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
//            p.addLine(to: CGPoint(x: x, y: yOffSet + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
//        }
//
//        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
//        p.addLine(to: CGPoint(x: 0, y: rect.height))
//        p.closeSubpath()
//
//        return p
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        WaterIntakeView()
//    }
//}







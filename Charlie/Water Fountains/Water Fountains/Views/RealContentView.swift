//
//  RealContentView.swift
//  Water Fountains
//
//  Created by Jay Zhao on 11/10/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var showWelcome = true  // Track whether to show the welcome screen
    @State private var selectedTab = 0  // Track the selected tab
    @State private var selectedLocationName = ""  // Store the location name for the review tab
    //@State private var intakeGoal: Double = 100.0  // Shared goal state for both views
    @State private var previewIntakeGoal: Double = 1000.0

    var body: some View {
        if showWelcome {
            // Show the Welcome Screen initially
            WelcomeView(showWelcome: $showWelcome)
        } else {
            // Show the Main App Content after tapping "Continue"
            TabView(selection: $selectedTab) {
                MainMapView(selectedTab: $selectedTab, selectedLocationName: $selectedLocationName)
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
                    .tag(0)

                // Water Tracker Tab
                WaterIntakeView(intakeGoal: $previewIntakeGoal)
                    .tabItem {
                        Label("Tracker", systemImage: "drop")
                    }
                    .tag(1)

                // Settings Tab
                SettingsView(intakeGoal: $previewIntakeGoal)
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
                    .tag(2)

                RatingsView(locationName: $selectedLocationName)
                    .tabItem {
                        Label("Ratings", systemImage: "star")
                    }
                    .tag(3)
            }
        }
    }
}
extension Color {
    static let darkGreen = Color(red: 0.0, green: 0.5, blue: 0.0)
}
struct WelcomeView: View {
    @Binding var showWelcome: Bool
    @State private var isLoading = true
    @State private var showArrow = false
    
    var body: some View {
        VStack {
            Spacer().frame(height: 50)
            
            // Wavy "Welcome!" Title
            WavyText(text: "Welcome!", color: .yellow)
                .padding(.bottom, 20)
            
            // Center Greeting Message
            Text("Hi! My name is Charlie! Let’s drink some water together!")
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundColor(.darkGreen)
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            
            // Image display under the greeting
            Image("Welcome_charlie") // Replace "welcomeImage" with the name of your image file
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 200)
                .padding(.bottom, 20)
            
            Spacer()
            
        // Small Arrow Button
        if isLoading {
            ProgressView("Loading...")
                .padding()
                .onAppear {
                    // Delay showing the arrow
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading = false
                        showArrow = true
                    }
                }
        } else if showArrow {
            Button(action: {
                showWelcome = false
            }) {
                Image(systemName: "arrow.right.circle.fill") // Small arrow icon
                    .font(.largeTitle)
                    .foregroundColor(.blue)
            }
            .padding(.bottom, 20)
            .transition(.opacity)
        }
    }
        .padding()
    }
}

// Custom WavyText view to create a wavy effect for "Welcome!"
struct WavyText: View {
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(text.enumerated()), id: \.offset) { index, letter in
                Text(String(letter))
                    .font(.system(size: 48, weight: .bold))
                    .fontWeight(.bold)
                    .foregroundColor(color)
                    .rotationEffect(self.rotationForLetter(at: index))
                    .offset(y: self.verticalOffsetForLetter(at: index))
            }
        }
    }

    private func rotationForLetter(at index: Int) -> Angle {
        // Alternate rotation for each letter to create a wavy effect
        let rotationAngles: [Double] = [-20, 10, -10, 15, -15, 20, -5]
        return Angle.degrees(rotationAngles[index % rotationAngles.count])
    }

    private func verticalOffsetForLetter(at index: Int) -> CGFloat {
        // Alternate vertical offset for each letter for a wavy look
        let offsets: [CGFloat] = [-5, 10, -10, 5, -5, 10, -10]
        return offsets[index % offsets.count]
    }
}

struct CustomPlace: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let name: String
}

struct MainMapView: View {
    @Binding var selectedTab: Int  // Binding to the selectedTab from ContentView
    @Binding var selectedLocationName: String  // Binding to location name
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.0902, longitude: -95.7129),
        span: MKCoordinateSpan(latitudeDelta: 40.0, longitudeDelta: 40.0)
    )
    @State private var searchText = ""
    @State private var placesToDisplay: [CustomPlace] = []
    @State private var selectedPlace: CustomPlace?  // Track selected place for actions
    @State private var showingActionSheet = false  // Control the action sheet display

    var body: some View {
        VStack {
            Map(coordinateRegion: $region, interactionModes: [.all], showsUserLocation: true, annotationItems: placesToDisplay) { place in
                MapAnnotation(coordinate: place.coordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.blue)  // Change the color to blue
                        .onTapGesture {
                            selectedPlace = place
                            selectedLocationName = place.name  // Set location name on pin tap
                            showingActionSheet = true
                        }
                }
            }
            .edgesIgnoringSafeArea(.all)

            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(
                    title: Text("Choose an option"),
                    message: Text("What would you like to do?"),
                    buttons: [
                        .default(Text("Open in Apple Maps")) {
                            if let destination = selectedPlace {
                                openDirectionsInMaps(to: destination.coordinate)
                            }
                        },
                        .default(Text("Rate this Location")) {
                            if let place = selectedPlace {
                                openRatingsTab(for: place)
                            }
                        },
                        .cancel()
                    ]
                )
            }

            HStack {
                TextField("Search for a place", text: $searchText, onCommit: {
                    searchLocation()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                Button(action: {
                    searchLocation()
                }) {
                    Text("Search")
                }
                .padding(.trailing)
            }
        }
        .navigationTitle("Interactive Map")
        .onAppear {
            loadPlaces()
        }
    }
    
    private func searchLocation() {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            if let response = response {
                if let mapItem = response.mapItems.first {
                    withAnimation {
                        region.center = mapItem.placemark.coordinate
                        region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    }
                }
            } else if let error = error {
                print("Error searching for location: \(error.localizedDescription)")
            }
        }
    }

    private func loadPlaces() {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            print("File not found")
            return
        }

        do {
            let data = try String(contentsOf: url)
            let lines = data.split(separator: "\n")

            placesToDisplay = lines.compactMap { line in
                let trimmedLine = line
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "\"", with: "")

                // Remove the "POINT (" and ")"
                let coordinatesAndName = trimmedLine
                    .replacingOccurrences(of: "POINT (", with: "")
                    .replacingOccurrences(of: ")", with: "")

                // Split into components by space, expecting 2 coordinates and a location name
                let components = coordinatesAndName.split(separator: " ", maxSplits: 2, omittingEmptySubsequences: true)

                // Check if we have two coordinates followed by a location name
                if components.count == 3,
                   let lon = Double(components[0]),
                   let lat = Double(components[1]) {
                    let locationName = String(components[2]) // The name is the third component
                    return CustomPlace(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), name: locationName)
                } else {
                    print("Failed to parse line: '\(line)'")
                    return nil
                }
            }
            print("Loaded \(placesToDisplay.count) places.")
        } catch {
            print("Error reading file: \(error)")
        }
    }


    private func openDirectionsInMaps(to destinationCoordinate: CLLocationCoordinate2D) {
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        let mapItem = MKMapItem(placemark: destinationPlacemark)
        mapItem.name = "Destination"
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
    
    private func openRatingsTab(for place: CustomPlace) {
        // Switch to Ratings tab and pass the location name
        selectedLocationName = place.name  // Pass the location name here
        selectedTab = 3
    }
}

struct Rating: Identifiable {
    let id = UUID()
    let locationName: String
    let stars: Int
    let comment: String
}

struct RatingsView: View {
    @Binding var locationName: String
    @State private var ratings: [Rating] = []
    @State private var stars = 3
    @State private var comment = ""
    @State private var showAllReviews = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Location Section
            HStack(spacing: 10) {
                Text("Add a Rating")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                Spacer()
                Button(action: {
                    // Action to close the review view
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
                .padding(.trailing)
            }
            
            TextField("Location Name", text: $locationName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Divider().padding(.horizontal)
            
            // Rating Section
            Text("How would you rate your experience?")
                .font(.headline)
                .padding(.horizontal)
            
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= stars ? "star.fill" : "star")
                        .foregroundColor(index <= stars ? .yellow : .gray)
                        .onTapGesture {
                            stars = index
                        }
                }
            }
            .padding(.horizontal)
            
            Divider().padding(.horizontal)
            
            // Tags Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Tell us about your experience")
                    .font(.headline)
                
                Text("A few things to consider in your review")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
            }
            .padding(.horizontal)
            
            // Comment Section
            TextField("Write your comments here...", text: $comment)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 100)
                .padding(.horizontal)
            
            Divider().padding(.horizontal)
            
            // Submit Button
            Button(action: addRating) {
                Text("Submit Rating")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.darkGreen)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            // Display List of Ratings
            ScrollView {
                LazyVStack {
                    ForEach(ratings.prefix(showAllReviews ? ratings.count : 2)) { rating in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(rating.locationName)
                                .font(.headline)
                            Text(String(repeating: "⭐", count: rating.stars))
                                .font(.title2)
                            Text(rating.comment)
                                .foregroundColor(.gray)
                            
                            // Delete button for each rating
                            Button(action: {
                                removeRating(rating)
                            }) {
                                Text("Delete")
                                    .foregroundColor(.red)
                                    .font(.subheadline)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
            }
            .frame(maxHeight: 300)
            
            if !showAllReviews && ratings.count > 2 {
                Button(action: { showAllReviews = true }) {
                    Text("See More")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .padding(.bottom)
            }
        }
        .onAppear {
            loadDefaultReviews()
        }
    }
    
    private func addRating() {
        let newRating = Rating(locationName: locationName, stars: stars, comment: comment)
        ratings.insert(newRating, at: 0)
        locationName = ""
        stars = 3
        comment = ""
    }
    
    private func loadDefaultReviews() {
        let defaultReviews = [
            Rating(locationName: locationName, stars: 4, comment: "Great place! Will visit again."),
            Rating(locationName: locationName, stars: 5, comment: "Fantastic experience, highly recommend!"),
            Rating(locationName: locationName, stars: 3, comment: "It was okay, but could use improvement.")
        ]
        ratings.append(contentsOf: defaultReviews)
    }
    
    private func removeRating(_ rating: Rating) {
        if let index = ratings.firstIndex(where: { $0.id == rating.id }) {
            ratings.remove(at: index)
        }
    }
}

struct SettingsView: View {
    @Binding var intakeGoal: Double
    @State private var userName: String = "User"// New state for user name input
    @Environment(\EnvironmentValues.presentationMode) private var presentationMode // Corrected environment declaration
    @State private var notificationsEnabled: Bool = false // State for toggle

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal")) {
                    TextField("Enter daily water intake in mL", value: $intakeGoal, format: .number)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("User Information")) {
                    TextField("Enter your name", text: $userName)
                        .onChange(of: userName) { newValue in
                            if !newValue.isEmpty {
                                userName = newValue
                            }
                        }
                }
                Section(header: Text("Notifications")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Text("Enable Notifications")
                    }
                    .onChange(of: notificationsEnabled) { isEnabled in
                        if isEnabled {
                            requestNotificationPermission()
                        }
                    }
                }
            }
            .navigationTitle("Hey, \(userName)!") // Dynamic title using user name
            .navigationBarItems(trailing: Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "xmark")
                    .foregroundColor(.primary)
            })
        }
    }
    private func requestNotificationPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized:
                    print("Notifications are already authorized.")
                case .denied:
                    notificationsEnabled = false // Turn off toggle if denied
                    showSettingsAlert()
                case .notDetermined:
                    notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                        DispatchQueue.main.async {
                            notificationsEnabled = didAllow
                            if !didAllow {
                                showSettingsAlert()
                            }
                        }
                    }
                default:
                    break
                }
            }
        }
    }

    private func showSettingsAlert() {
        let alert = UIAlertController(
            title: "Enable Notifications",
            message: "To receive notifications, enable them in Settings.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        })
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
}

struct WaterIntakeView: View {
    @State private var waterIntakes: [WaterIntake] = []
    @State private var currentIntake: Double = 0.0
    @State private var showingAddWaterSheet = false
    @State private var totalIntake: Double = 0.0
    @Binding var intakeGoal: Double
    @State private var showGoalReachedPopup = false
    @State private var waveOffset = Angle(degrees: 0) // For wave animation

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Water Tracker")
                    .font(.system(size: 36, weight: .bold))
                    .padding(.top, 40)

                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 200, height: 400)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 2))

                    // Blue rectangle with wave overlay
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue.opacity(0.5))
                            .frame(width: 200, height: min((CGFloat(totalIntake) / intakeGoal * 400), 400))
                            .animation(.easeInOut, value: totalIntake)

                        // Wave overlay
                        Wave(offSet: waveOffset, percent: min(totalIntake / intakeGoal * 100, 100))
                            .fill(Color.blue)
                            .frame(width: 200, height: min((CGFloat(totalIntake) / intakeGoal * 400), 400))
                            .clipShape(RoundedRectangle(cornerRadius: 20)) // Clip to rounded rectangle shape
                            .animation(.easeInOut, value: totalIntake)
                    }
                }
                .padding()
                .onChange(of: totalIntake) { newValue in
                    if newValue >= intakeGoal {
                        showGoalReachedPopup = true
                        let overflow = newValue - intakeGoal
                        totalIntake = overflow
                    }
                }
                .onAppear {
                    withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        self.waveOffset = Angle(degrees: 360)
                    }
                }

                Button(action: {
                    showingAddWaterSheet.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                        Text("WATER")
                            .font(.system(.body, design: .rounded))
                            .fontWeight(.heavy)
                    }
                    .padding()
                    .frame(width: 200)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                }
                .padding()
            }
            .sheet(isPresented: $showGoalReachedPopup) {
                GoalReachedView(isPresented: $showGoalReachedPopup)
            }
            .sheet(isPresented: $showingAddWaterSheet) {
                AddWaterView(totalIntake: $totalIntake, isPresented: $showingAddWaterSheet)
            }
            .navigationBarHidden(true)
        }
    }
}

// Wave Shape Implementation
struct Wave: Shape {
    var offSet: Angle
    var percent: Double

    var animatableData: Double {
        get { offSet.degrees }
        set { offSet = Angle(degrees: newValue) }
    }

    func path(in rect: CGRect) -> Path {
        var p = Path()

        let lowestWave = 0.02
        let highestWave = 1.00
        let newPercent = lowestWave + (highestWave - lowestWave) * (percent / 100)
        let waveHeight = 0.015 * rect.height
        let yOffSet = CGFloat(1 - newPercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offSet
        let endAngle = offSet + Angle(degrees: 360 + 10)

        p.move(to: CGPoint(x: 0, y: yOffSet + waveHeight * CGFloat(sin(offSet.radians))))

        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yOffSet + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }

        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()

        return p
    }
}


//
//  RatingView.swift
//  Water Fountains
//
//  Created by Jay Zhao on 11/10/24.
//


//struct Rating: Identifiable {
//    let id = UUID()
//    let locationName: String
//    let stars: Int
//    let comment: String
//}
//
//struct RatingsView: View {
//    @Binding var locationName: String
//    @State private var ratings: [Rating] = []
//    @State private var stars = 3
//    @State private var comment = ""
//    @State private var showAllReviews = false
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            
//            // Location Section
//            HStack(spacing: 10) {
//                Text("Add a Rating")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .padding(.leading)
//                Spacer()
//                Button(action: {
//                    // Action to close the review view
//                }) {
//                    Image(systemName: "xmark")
//                        .foregroundColor(.gray)
//                }
//                .padding(.trailing)
//            }
//            
//            TextField("Location Name", text: $locationName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding(.horizontal)
//            
//            Divider().padding(.horizontal)
//            
//            // Rating Section
//            Text("How would you rate your experience?")
//                .font(.headline)
//                .padding(.horizontal)
//            
//            HStack {
//                ForEach(1...5, id: \.self) { index in
//                    Image(systemName: index <= stars ? "star.fill" : "star")
//                        .foregroundColor(index <= stars ? .yellow : .gray)
//                        .onTapGesture {
//                            stars = index
//                        }
//                }
//            }
//            .padding(.horizontal)
//            
//            Divider().padding(.horizontal)
//            
//            // Tags Section
//            VStack(alignment: .leading, spacing: 10) {
//                Text("Tell us about your experience")
//                    .font(.headline)
//                
//                Text("A few things to consider in your review")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                
//            }
//            .padding(.horizontal)
//            
//            // Comment Section
//            TextField("Write your comments here...", text: $comment)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .frame(height: 100)
//                .padding(.horizontal)
//            
//            Divider().padding(.horizontal)
//            
//            // Submit Button
//            Button(action: addRating) {
//                Text("Submit Rating")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.darkGreen)
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//            }
//            
//            // Display List of Ratings
//            ScrollView {
//                LazyVStack {
//                    ForEach(ratings.prefix(showAllReviews ? ratings.count : 2)) { rating in
//                        VStack(alignment: .leading, spacing: 5) {
//                            Text(rating.locationName)
//                                .font(.headline)
//                            Text(String(repeating: "⭐", count: rating.stars))
//                                .font(.title2)
//                            Text(rating.comment)
//                                .foregroundColor(.gray)
//                            
//                            // Delete button for each rating
//                            Button(action: {
//                                removeRating(rating)
//                            }) {
//                                Text("Delete")
//                                    .foregroundColor(.red)
//                                    .font(.subheadline)
//                            }
//                        }
//                        .padding()
//                        .background(Color.gray.opacity(0.1))
//                        .cornerRadius(10)
//                        .padding(.horizontal)
//                    }
//                }
//            }
//            .frame(maxHeight: 300)
//            
//            if !showAllReviews && ratings.count > 2 {
//                Button(action: { showAllReviews = true }) {
//                    Text("See More")
//                        .font(.subheadline)
//                        .foregroundColor(.blue)
//                }
//                .padding(.bottom)
//            }
//        }
//        .onAppear {
//            loadDefaultReviews()
//        }
//    }
//    
//    private func addRating() {
//        let newRating = Rating(locationName: locationName, stars: stars, comment: comment)
//        ratings.insert(newRating, at: 0)
//        locationName = ""
//        stars = 3
//        comment = ""
//    }
//    
//    private func loadDefaultReviews() {
//        let defaultReviews = [
//            Rating(locationName: locationName, stars: 4, comment: "Great place! Will visit again."),
//            Rating(locationName: locationName, stars: 5, comment: "Fantastic experience, highly recommend!"),
//            Rating(locationName: locationName, stars: 3, comment: "It was okay, but could use improvement.")
//        ]
//        ratings.append(contentsOf: defaultReviews)
//    }
//    
//    private func removeRating(_ rating: Rating) {
//        if let index = ratings.firstIndex(where: { $0.id == rating.id }) {
//            ratings.remove(at: index)
//        }
//    }
//}
//
//// Tag View for the "Food," "Service," and "Ambiance" tags
//struct TagView: View {
//    var tagText: String
//
//    var body: some View {
//        Text(tagText)
//            .font(.subheadline)
//            .padding(.horizontal, 12)
//            .padding(.vertical, 6)
//            .background(Color.gray.opacity(0.2))
//            .cornerRadius(8)
//    }
//}

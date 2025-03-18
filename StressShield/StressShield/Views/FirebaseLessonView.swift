import SwiftUI
import FirebaseStorage
import Foundation
import SDWebImageSwiftUI
import AVKit

struct FirebaseLessonView: View {
    let inputLessonID: String
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel = FirebaseLessonViewModel()
    @State private var imageUrl: String? // Store the HTTP URL here
    @Environment(\.colorScheme) var colorScheme  // Detect system theme
    
    var progressFraction: Float {
        guard viewModel.currentLesson!.length! > 0 else { return 0 }
        return Float(viewModel.currentContentIndex) / Float(viewModel.currentLesson!.length!)
    }
    
    var body: some View {
        VStack {
            if viewModel.loading {
                ProgressView("Loading Lesson...")
                    .onAppear {
                        Task {
                            await viewModel.startLesson(lessonID: inputLessonID)
                        }
                    }
            } else if let content = viewModel.currentContent {
                VStack {
                    VStack {
                        HStack {
                            Button(action: {
                                viewModel.endLessonEarly()
                            }) {
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .foregroundColor(.primary) // Adjusts automatically
                            }
                            .padding()
                            
                            Spacer()
                                .frame(maxWidth: 200)
                            
                            ProgressBarView(progress: progressFraction)
                                .frame(width: 100, height: 24)
                        }
                        
                        Text(content.title ?? "")
                            .font(.title2.bold())
                            .foregroundColor(Color.white)
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.06, green: 0.45, blue: 0.56))
                    
                    if let file = content.file, let contentType = content.contentType {
                        if contentType == "Video" {
                            VideoPlayerView(storagePath: file)
                                .frame(height: 200)
                                .cornerRadius(10)
                                .padding()
                        } else if contentType == "Image" {
                            if let urlString = imageUrl, let url = URL(string: urlString) {
                                WebImage(url: url) // Uses SDWebImage for URL loading
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity, maxHeight: 180)
                                    .clipped()
                                    .cornerRadius(10)
                                //.padding(.top, 8)
                            } else {
                                Text("Loading image...")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    Text(content.text?.replacingOccurrences(of: "\\n", with: "\n") ?? "")
                        .foregroundColor(.primary) // Text adapts to mode
                        .padding()
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        // Handle button action
                        Task {
                            print("Attempting to continue")
                            await viewModel.continueLesson()
                        }
                    }) {
                        Text(content.proceedText ?? "")
                            .font(.headline)
                            .foregroundColor(colorScheme == .dark ? .black : .white) // Adjust button text
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.06, green: 0.45, blue: 0.56))
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .onAppear {
                    loadImageUrl()
                }
            }
        }
        .background(Color(.systemBackground).ignoresSafeArea()) // Background adjusts to theme
        .onChange(of: viewModel.endOfLesson) {
            dismiss()
        }
        .onChange(of: viewModel.endEarly) {
            dismiss()
        }
    }
    
    // Fetch the image URL from Firebase Storage
    func loadImageUrl() {
        let storage = Storage.storage()
        let reference = storage.reference(forURL: viewModel.currentContent!.file!) // Assuming lesson.image is the gs:// URL
        
        reference.downloadURL { url, error in
            if let error = error {
                print("Error loading image URL: \(error.localizedDescription)")
            } else if let url = url {
                // Convert the gs:// URL to a https:// URL
                self.imageUrl = url.absoluteString
            }
        }
    }
}

struct VideoPlayerView: View {
    let storagePath: String
    @State private var videoURL: URL?

    var body: some View {
        VStack {
            if let url = videoURL {
                VideoPlayer(player: AVPlayer(url: url))
            } else {
                Text("Loading video...")
                    .foregroundColor(.primary)
                    .onAppear {
                        fetchVideoUrl()
                    }
            }
        }
    }

    func fetchVideoUrl() {
        let storage = Storage.storage()
        let reference = storage.reference(forURL: storagePath)
        
        reference.downloadURL { url, error in
            if let error = error {
                print("Error fetching video URL: \(error.localizedDescription)")
            } else if let url = url {
                DispatchQueue.main.async {
                    self.videoURL = url
                }
            }
        }
    }
}

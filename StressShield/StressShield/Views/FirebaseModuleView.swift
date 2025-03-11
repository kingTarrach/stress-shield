import SwiftUI
import FirebaseStorage
import Foundation
import SDWebImageSwiftUI

// This struct manages the dropdown groupings of modules and their lessons
struct ModuleView: View {
    let module: ViewingModule
    let index: Int
    @State private var showLessons = false // Toggle lessons visibility
    @ObservedObject var viewModel: ModuleViewModel // Pass the viewModel down

    var body: some View {
        VStack {
            // Module Card as Button
            Button(action: {
                withAnimation {
                    showLessons.toggle()
                }
            }) {
                let moduleName = module.name
                ModuleCardView(
                    title: "Mission \(index)",
                    description: moduleName,
                    locked: module.locked
                )
            }
            .buttonStyle(PlainButtonStyle()) // Removes button styling
            
            // Show lessons when module is clicked
            if showLessons {
                VStack(spacing: 8) {
                    ForEach(module.lessons, id: \.id) { lesson in
                        LessonCardView(lesson: lesson, viewModel: viewModel) // Pass the viewModel here
                    }
                }
                .padding(.top, 4) // Space between module and lessons
            }
        }
    }
}

struct ModuleCardView: View {
    let title: String
    let description: String
    let locked: Bool

    var body: some View {
        HStack {
            Image(locked ? "ModuleLocked" : "ModuleUnlocked") // Custom asset for lock/unlock
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40) // Adjust size as needed
                // .foregroundColor(locked ? nil : .white) doesn't work for some reason
                .padding(.leading, 8)

            Spacer(minLength: 8) // Small spacing between the icon and text

            VStack(alignment: .center, spacing: 4) {
                Text(title)
                    .font(.custom("Jost", size: 20).weight(.heavy))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.custom("Jost", size: 16))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .center) // Ensure text is centered

            Spacer() // Push content to center
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 74, alignment: .center) // Ensure proper height
        .background(locked ? Color(red: 91/255, green: 91/255, blue: 91/255) : Color(red: 0.06, green: 0.45, blue: 0.56))
        .cornerRadius(10)
    }
}

struct ProgressBarView: View {
    var progress: Float

    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .frame(height: 8)
                .foregroundColor(Color.white.opacity(0.2))

            Capsule()
                .frame(width: CGFloat(progress) * 100, height: 8) // The width is based on progress
                .foregroundColor(.green) // You can customize the color
        }
    }
}

struct LessonCardView: View {
    let lesson: ViewingLesson
    @State private var imageUrl: String? // Store the HTTP URL here
    @State private var isLessonPresented = false
    @ObservedObject var viewModel: ModuleViewModel // Add a reference to the ViewModel

    var progressFraction: Float {
        guard lesson.length > 0 else { return 0 }
        return Float(lesson.progress) / Float(lesson.length)
    }
    
    // Determine the correct icon based on lesson state
    var iconName: String {
        if lesson.locked {
            return "LessonLocked" // Locked icon
        } else if lesson.progress == lesson.length {
            return "LessonComplete" // Completed icon
        } else {
            return "LessonNotComplete" // Incomplete icon
        }
    }

    var body: some View {
        VStack {
            HStack {
                // Locked/Unlocked Icon (Top Left)
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(.leading, 8)
                
                Spacer()
                
                // Progress Bar (Top Right)
                ProgressBarView(progress: progressFraction)
                    .frame(width: 100, height: 24)
            }
            .padding(.top, 8)

            // Load Image from Firebase Storage if imageUrl is available
            if let urlString = imageUrl, let url = URL(string: urlString) {
                WebImage(url: url) // Uses SDWebImage for URL loading
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180) // Adjust the height of the image
                    .clipped()
                    .cornerRadius(10)
            } else {
                Text("Loading image...")
                    .foregroundColor(.white)
            }

            Spacer()

            // Text below the image (Lesson Name and Super Name)
            VStack {
                Text(lesson.superName)
                    .font(.custom("Jost", size: 18).weight(.bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 2)
                
                Text(lesson.name)
                    .font(.custom("Jost", size: 16))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.bottom, 8)
        }
        .padding()
        .background(lesson.locked ? Color(red: 91/255, green: 91/255, blue: 91/255) : Color(red: 0.06, green: 0.45, blue: 0.56))
        .cornerRadius(10)
        .onAppear {
            loadImageUrl() // Load the URL when the view appears
        }
        .onTapGesture {
            isLessonPresented = true // Show the lesson when tapped
        }
        .fullScreenCover(isPresented: $isLessonPresented) {
            FirebaseLessonView(inputLessonID: lesson.id)
                .onAppear {
                    print("Loading attempt")
                }
                .onDisappear {
                    Task {
                        // Call the createViewingModules function when the lesson view disappears
                        await viewModel.createViewingModules()
                    }
                }
        }
    }

    // Fetch the image URL from Firebase Storage
    func loadImageUrl() {
        let storage = Storage.storage()
        let reference = storage.reference(forURL: lesson.image) // Assuming lesson.image is the gs:// URL
        
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


struct ModulesView: View {
    @StateObject var viewModel = ModuleViewModel()

    var body: some View {
        ScrollView(.vertical){
            VStack {
                if viewModel.loading {
                    ProgressView("Loading Modules...")
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.viewingModules.indices, id: \.self) { index in
                                ModuleView(
                                    module: viewModel.viewingModules[index],
                                    index: index,
                                    viewModel: viewModel // Pass the viewModel here
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.createViewingModules()
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ModulesView()
//    }
//}

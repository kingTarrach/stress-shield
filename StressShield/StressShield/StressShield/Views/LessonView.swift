import SwiftUI

struct LessonView: View {
    let lessonNumber: Int
    let pages: [LessonPage] // Pages for this lesson
    
    @State private var currentPage = 0
    @State private var isAnsweredCorrectly = false
    @Environment(\.dismiss) var dismiss // Allows navigation back
    
    init(lessonNumber: Int) {
        self.lessonNumber = lessonNumber
        self.pages = LessonView.loadLessonContent(for: lessonNumber)
    }
    
    var body: some View {
        VStack {
            Text("Lesson \(lessonNumber)") // Display Lesson Number
                .font(.headline)
                .padding()
            
            Text("\(currentPage + 1)/\(pages.count)")
                .font(.subheadline)
            
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    PageView(page: pages[index], isAnsweredCorrectly: $isAnsweredCorrectly)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            if shouldShowContinueButton() {
                Button(action: {
                    if currentPage < pages.count - 1 {
                        currentPage += 1
                        isAnsweredCorrectly = false
                    } else {
                        dismiss() // Return to Main Menu when finishing
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Finish Lesson" : "Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(currentPage == pages.count - 1 ? Color.green : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true) // Prevents accidental back navigation
    }
    
    private func shouldShowContinueButton() -> Bool {
        switch pages[currentPage].type {
        case .content:
            return true
        case .question:
            return isAnsweredCorrectly
        }
    }
    
    static func loadLessonContent(for lessonNumber: Int) -> [LessonPage] {
        switch lessonNumber {
        case 1:
            return [
                LessonPage(type: .content(.text("Welcome to Lesson 1!"))),
                LessonPage(type: .content(.video("sampleVid.mp4"))),
                LessonPage(type: .question(.multipleChoice(question: "What is 2+2?", options: ["3", "4", "5"], correctAnswer: "4")))
            ]
        case 2:
            return [
                LessonPage(type: .content(.text("Lesson 2: Burnout Prevention"))),
                LessonPage(type: .content(.image("brainSample.jpg")))
            ]
        default:
            return [
                LessonPage(type: .content(.text("Default lesson content.")))
            ]
        }
    }
}

#Preview {
    LessonView(lessonNumber: 0)
}

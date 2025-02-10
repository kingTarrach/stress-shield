import SwiftUI
import AVKit

struct LessonPage: Identifiable {
    let id = UUID()
    
    enum PageType {
        case content(ContentType)
        case question(QuestionType)
    }
    
    enum ContentType {
        case text(String)
        case image(String) // Image name
        case video(String) // Video URL string
    }
    
    
    
    enum QuestionType {
        case multipleChoice(question: String, options: [String], correctAnswer: String)
    }
    
    let type: PageType
}



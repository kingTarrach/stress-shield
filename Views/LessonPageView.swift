import SwiftUI
import AVKit

struct PageView: View {
    let page: LessonPage
    @Binding var isAnsweredCorrectly: Bool
    
    @State private var selectedAnswer: String? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            switch page.type {
            case .content(let contentType):
                contentView(for: contentType)
            case .question(let questionType):
                questionView(for: questionType)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func contentView(for contentType: LessonPage.ContentType) -> some View {
        switch contentType {
        case .text(let text):
            Text(text)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
        case .image(let imageName):
            if let path = Bundle.main.path(forResource: imageName, ofType: nil),
               let uiImage = UIImage(contentsOfFile: path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            } else {
                Text("Image not found")
                    .foregroundColor(.red)
            }
            
        case .video(let videoName):
            if let path = Bundle.main.path(forResource: videoName, ofType: nil) {
                let player = AVPlayer(url: URL(fileURLWithPath: path))
                VideoPlayer(player: player)
                    .frame(height: 300)
                    .onAppear {
                        player.play()
                    }
            } else {
                Text("Video not found")
                    .foregroundColor(.red)
            }
        }
    }
    
    @ViewBuilder
    private func questionView(for questionType: LessonPage.QuestionType) -> some View {
        switch questionType {
        case .multipleChoice(let question, let options, let correctAnswer):
            VStack {
                Text(question)
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        if option == correctAnswer {
                            isAnsweredCorrectly = true
                        } else {
                            isAnsweredCorrectly = false
                        }
                        selectedAnswer = option // Track selected answer
                    }) {
                        Text(option)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedAnswer == option
                                ? (option == correctAnswer ? Color.green : Color.red) // Green if correct, Red if wrong
                                : Color.blue
                            )
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}

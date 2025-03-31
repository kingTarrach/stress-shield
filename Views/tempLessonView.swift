import SwiftUI

struct ModuleCardView: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Jost", size: 20).weight(.heavy))
                .foregroundColor(.white)
            
            Text(description)
                .font(.custom("Jost", size: 16))
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 74)
        .background(Color(red: 0.06, green: 0.45, blue: 0.56))
        .cornerRadius(10)
    }
}

// To use this shape, just add it to your SwiftUI View:
// Vector().fill().frame(width: 124.15000915527344, height: 481.30999755859375)

struct Vector: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: 0.0071688035 * width, y: 0.2730672718 * height))
        path.addLine(to: CGPoint(x: 0.8497784311 * width, y: 0.7000062644 * height))
        path.addLine(to: CGPoint(x: 0, y: height))
        return path
    }
}

struct DecorativeView: View {
    var body: some View {
        ZStack {
            Vector()
                .stroke(Color.primary, lineWidth: 8)
                .frame(width: 124.15000915527344, height: 481.30999755859375)
        }
        .padding(.horizontal)
    }
}


struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ModuleCardView(title: "Module 1 - Backstory", description: "Understand the overwhelming nature of stress")
                DecorativeView()
                ModuleCardView(title: "Module 2 - Coping Strategies", description: "Learn methods to manage and reduce stress")
                DecorativeView()
                ModuleCardView(title: "Module 3 - Building Resilience", description: "Develop skills to handle stress effectively")
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

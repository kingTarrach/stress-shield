import Foundation
import FirebaseFirestore

public struct FirebaseUser: Codable {
    let name: String
    //let id: String?
    let email: String?
    let joined: Double?
    let subscribed: Bool?
    let XP: Int?
    let lessonsCompleted: Int?
    let firstTime: Bool?
    
    enum CodingKeys: String, CodingKey {
        case name
        //case id
        case email
        case joined
        case subscribed
        case XP
        case lessonsCompleted
        case firstTime
    }
}

public struct Goal: Codable {
    let name: String
    //let id: String?
    let criteria: String?
    let goalDate: Double?
    let goalComplete: Bool?
    let user: String?

    
    enum CodingKeys: String, CodingKey {
        case name
        //case id
        case criteria
        case goalDate
        case goalComplete
        case user
    }
}

protocol HealthData: Codable, Identifiable {
    var id: UUID { get }
    var date: Timestamp? { get set }  // Stored as a Firestore timestamp (epoch time)
    var value: Int? { get set }  // Common value field for metrics
    static var minValue: CGFloat { get }
    static var maxValue: CGFloat { get }
    
}

public struct HRVAverage: HealthData {
    public let id = UUID()
    let name: String
    //let id: String?
    var value: Int?
    var date: Timestamp?
    var user: String?

    // Min/Max for data visualization
    static let minValue: CGFloat = 0
    static let maxValue: CGFloat = 110
    
    enum CodingKeys: String, CodingKey {
        case name
        //case id
        case value
        case date
        case user
    }
}

public struct SleepTotal: HealthData {
    public let id = UUID()
    let name: String
    //let id: String?
    var value: Int?
    var date: Timestamp?
    var user: String?
    
    // Min/Max for data visualization
    static let minValue: CGFloat = 0
    static let maxValue: CGFloat = 10

    
    enum CodingKeys: String, CodingKey {
        case name
        //case id
        case value
        case date
        case user
    }
}

public struct Stress: HealthData {
    public let id = UUID()
    let name: String
    //let id: String?
    var value: Int?
    var date: Timestamp?
    var user: String?

    
    // Min/Max for data visualization
    static let minValue: CGFloat = 0
    static let maxValue: CGFloat = 100
    
    enum CodingKeys: String, CodingKey {
        case name
        //case id
        case value
        case date
        case user
    }
}

public struct UserLessonProgress: Codable {
    let name: String
    //let id: String?
    let lastFinished: Int?
    let lessonComplete: Bool?
    let user: String?
    let lesson: String?

    
    enum CodingKeys: String, CodingKey {
        case name
        //case id
        case lastFinished
        case lessonComplete
        case user
        case lesson
    }
}

public struct LearnModule: Codable {
    let name: String
    //let id: String?
    let lessons: [String]?
    let length: Int?
    
    enum CodingKeys: String, CodingKey {
        case name
        //case id
        case lessons
        case length
    }
}

public struct Lesson: Codable {
    let name: String
    //let id: String?
    let contents: [String]?
    let length: Int?
    let module: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        //case id
        case contents
        case length
        case module
    }
}

public struct LessonContent: Codable {
    let name: String
    //let id: String?
    let text: String?
    let contentType: String?
    let file: String?
    let correctAnswer: String?
    let possibleAnswers: [String]?
    
    enum CodingKeys: String, CodingKey {
        case name
        //case id
        case text
        case contentType
        case file
        case correctAnswer
        case possibleAnswers
    }
}

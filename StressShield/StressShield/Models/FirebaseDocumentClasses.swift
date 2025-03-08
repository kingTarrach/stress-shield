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

public struct HRVAverage: Codable {
    let name: String
    //let id: String?
    let value: Int?
    let date: Double?
    let user: String?

    
    enum CodingKeys: String, CodingKey {
        case name
        //case id
        case value
        case date
        case user
    }
}

public struct SleepTotal: Codable {
    let name: String
    //let id: String?
    let value: Int?
    let date: Double?
    let user: String?

    
    enum CodingKeys: String, CodingKey {
        case name
        //case id
        case value
        case date
        case user
    }
}

public struct Stress: Codable {
    let name: String
    //let id: String?
    let value: Int?
    let date: Double?
    let user: String?

    
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
    let lessonName: String?

    
    enum CodingKeys: String, CodingKey {
        case name
        //case id
        case lastFinished
        case lessonComplete
        case user
        case lesson
        case lessonName
    }
}

public struct UserModuleProgress: Codable {
    let name: String
    //let id: String?
    let lastFinished: Int?
    let moduleComplete: Bool?
    let user: String?
    let module: String?
    let moduleName: String?

    
    enum CodingKeys: String, CodingKey {
        case name
        //case id
        case lastFinished
        case moduleComplete
        case user
        case module
        case moduleName
    }
}

public struct Lesson: Codable {
    let name: String
    //let id: String?
    let contents: [String]?
    let contentNames: [String]?
    let length: Int?
    let module: Int?
    
    enum CodingKeys: String, CodingKey {
        case name
        //case id
        case contents
        case contentNames
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

public struct LearnModule: Codable {
    let name: String
    //let id: String?
    let lessons: [String]?
    let lessonNames: [String]?
    let length: Int?
    let order: Int?
    
    enum CodingKeys: String, CodingKey {
        case name
        //case id
        case lessons
        case lessonNames
        case length
        case order
    }
}

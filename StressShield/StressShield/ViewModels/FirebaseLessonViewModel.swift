import Foundation
import SwiftUI
import FirebaseAuth

class FirebaseLessonViewModel: ObservableObject {
    @Published var loading:Bool = true
    @Published var currentLesson:Lesson?
    @Published var currentContent:LessonContent?
    @Published var currentLessonProgress:UserLessonProgress?
    @Published var currentModuleProgress:UserModuleProgress?
    @Published var firstTime:Bool = false
    @Published var currentContentIndex:Int = 0
    @Published var endOfLesson:Bool = false
    @Published var endEarly:Bool = false
    
    private let model = FirebaseTools()
    private var lessonContents: [LessonContent] = []
    private var modules: [LearnModule] = []
    
    // function to return lesson
    private func fetchLesson(
        documentID: String
    ) async -> Lesson? {
        return await model.getDocumentFromFirestore(collection: "Lesson", documentID: documentID, as: Lesson.self)
    }
    
    // function to return lesson contents
    private func fetchLessonContents(
    ) async -> [LessonContent]? {
        return await model.getCollectionFromFirestore(collection: "LessonContent", as: LessonContent.self)
    }
    
    // function to get user module progress
    private func fetchModuleProgress() async -> [UserModuleProgress]? {
        guard let userId = Auth.auth().currentUser?.uid else {
            return nil
        }
        return await model.getCollectionFromFirestore(collection: "UserModuleProgress", as: UserModuleProgress.self, userID: userId)
    }
    
    // function to get user lesson progress
    private func fetchLessonProgress() async -> [UserLessonProgress]? {
        guard let userId = Auth.auth().currentUser?.uid else {
            return nil
        }
        return await model.getCollectionFromFirestore(collection: "UserLessonProgress", as: UserLessonProgress.self, userID: userId)
    }
    
    // function to return modules
    private func fetchModules() async -> [LearnModule]? {
        return await model.getCollectionFromFirestore(collection: "LearnModule", as: LearnModule.self)
    }
    
    // function to update user lesson progress
    private func updateLessonProgress(
        userLessonProgress: UserLessonProgress
    ) async {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        await model.updateFullDocumentInFirestore(collection: "UserLessonProgress", field: "lessonName", value: userLessonProgress.lessonName!, userID: userID, data: userLessonProgress)
    }
    
    // function to update user module progress
    private func updateModuleProgress(
        userModuleProgress: UserModuleProgress
    ) async {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        await model.updateFullDocumentInFirestore(collection: "UserModuleProgress", field: "moduleName", value: userModuleProgress.moduleName!, userID: userID, data: userModuleProgress)
    }
    // function to create user lesson progress
    private func createUserLessonProgress(
        userLessonProgress: UserLessonProgress
    ) async {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        await model.addDocumentToFirestore(collection: "UserLessonProgress", document: userLessonProgress)
    }
    
    // function to create user module progress
    private func createUserModuleProgress(
        userModuleProgress: UserModuleProgress
    ) async {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        await model.addDocumentToFirestore(collection: "UserModuleProgress", document: userModuleProgress)
    }
    
    private func checkIfCompletedContent(
        currentModuleProgress: UserModuleProgress,
        currentLessonProgress: UserLessonProgress
    ) -> Bool {
        print("Module Progress: \(String(describing: currentModuleProgress.moduleComplete))")
        print("Lesson Progress: \(String(describing: currentLessonProgress.lessonComplete))")
        print("Current Lesson Progress: \(String(describing: currentLessonProgress.lastFinished))")
        print("Current Content Index: \(String(describing: currentContentIndex))")
        // Check if this is the first time completing this module
        if currentModuleProgress.moduleComplete == false {
            // Check if this is the first time completing this lesson
            if currentLessonProgress.lessonComplete == false {
                // Check if the index is equal lastComplete.
                // index starts at zero, and lastComplete starts at zero.
                // index should never be greater than last complete
                if currentLessonProgress.lastFinished == currentContentIndex {
                    return false
                }
            }
        }
        return true
    }
    
    public func startLesson(
        lessonID: String
    ) async {
        DispatchQueue.main.async {
            self.loading = true
        }
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        print(userId)
        let lesson = await fetchLesson(documentID: lessonID)
        guard let lesson else {
            return
        }
        let moduleProgress = await fetchModuleProgress()
        guard let moduleProgress else {
            return
        }
        let lessonProgress = await fetchLessonProgress()
        guard let lessonProgress else {
            return
        }
        let lessonContents = await fetchLessonContents()
        guard let lessonContents else {
            return
        }
        let modules = await fetchModules()
        guard let modules else {
            return
        }
        
        self.modules = modules.sorted { $0.order! < $1.order!}
        self.lessonContents = lessonContents
        
        //set content to first part of lesson
        let contentName = lesson.contentNames![0]
        
        //get that first lesson content
        if let currentContent = lessonContents.first(where: { $0.name == contentName }) {
            if let currentLessonProgress = lessonProgress.first(where: { $0.lessonName == lesson.name}) {
                if let currentModuleProgress = moduleProgress.first(where: { $0.moduleName == lesson.module}) {
                    // Now need to check if this is the user's first time through this particular lesson content
                    // If that's the case, the user's lesson progress last finished should be less than or equal to the index
                    
                    // Now that we know everything we need to know, we can publish these things.
                    DispatchQueue.main.async {
                        self.loading = false
                        self.currentLesson = lesson
                        self.currentContent = currentContent
                        self.currentLessonProgress = currentLessonProgress
                        self.currentModuleProgress = currentModuleProgress
                        self.currentContentIndex = 0
                        self.firstTime = !self.checkIfCompletedContent(currentModuleProgress: self.currentModuleProgress!, currentLessonProgress: self.currentLessonProgress!)
                    }
                    print(self.firstTime)
                    
                }
                else {
                    print("Related user progress for module not found")
                }
            }
            else
            {
                print("Related user progress for lesson not found")
            }
        }
        else {
            print("Failed to get lesson content")
        }
        
        
    }
    
    // Returns true if module needs updating
    private func incrementLessonProgress() async -> Bool {
        print("Incrementing progress")
        if self.firstTime {
            // Code for updating the lesson progress and communicating with server
            // Check if lesson complete
            print("This is the first time this user has completed this content")
            if currentContentIndex + 1 == currentLesson!.length! {
                print("We are at the end of lesson")
                let tempCurrentLessonProgress = UserLessonProgress(name: currentLessonProgress!.name, lastFinished: currentLessonProgress!.lastFinished! + 1, lessonComplete: true, user: currentLessonProgress!.user, lesson: currentLessonProgress!.lesson, lessonName: currentLesson!.name)
                // No need to update local
                // Server code to update progress
                await updateLessonProgress(userLessonProgress: tempCurrentLessonProgress)
                return true
            }
            else {
                print("We are in lesson")
                let tempCurrentLessonProgress = UserLessonProgress(name: currentLessonProgress!.name, lastFinished: currentLessonProgress!.lastFinished! + 1, lessonComplete: false, user: currentLessonProgress!.user, lesson: currentLessonProgress!.lesson, lessonName: currentLesson!.name)
                // Update local to the temp
                DispatchQueue.main.async{
                    self.currentLessonProgress = tempCurrentLessonProgress
                }
                // Server code to update progress
                await updateLessonProgress(userLessonProgress: tempCurrentLessonProgress)
            }
        }
        DispatchQueue.main.async {
            self.currentContentIndex += 1
            if self.currentContentIndex < self.currentLesson!.contentNames!.count {
                self.currentContent = self.lessonContents.first(where: {
                    $0.name == self.currentLesson!.contentNames![self.currentContentIndex]
                })
            } else {
                print("Reached end of lesson content")
            }
        }
        return false
    }
    
    private func incrementModuleProgress() async -> Bool {
        if self.firstTime {
            // Code for updating the module progress and communicating with server
            if currentModuleProgress!.lastFinished! + 1 == modules.first(where: { $0.name == currentModuleProgress!.moduleName!})!.length! {
                let tempModuleProgress = UserModuleProgress(name: currentModuleProgress!.name, lastFinished: currentModuleProgress!.lastFinished! + 1, moduleComplete: true, user: currentModuleProgress!.user, module: currentModuleProgress!.module, moduleName: currentModuleProgress!.moduleName)
                // Server code to update progress
                await updateModuleProgress(userModuleProgress: tempModuleProgress)
                return true
            }
            else {
                let tempModuleProgress = UserModuleProgress(name: currentModuleProgress!.name, lastFinished: currentModuleProgress!.lastFinished! + 1, moduleComplete: false, user: currentModuleProgress!.user, module: currentModuleProgress!.module, moduleName: currentModuleProgress!.moduleName)
                // Server code to update progress
                await updateModuleProgress(userModuleProgress: tempModuleProgress)
            }
            
        }
        return false
    }
    
    func continueLesson() async {
        DispatchQueue.main.async {
            self.firstTime = !self.checkIfCompletedContent(currentModuleProgress: self.currentModuleProgress!, currentLessonProgress: self.currentLessonProgress!)
        }
        print(self.firstTime)
        // Update the lesson progress
        print("Updating Lesson Progress")
        let moduleUpdate = await incrementLessonProgress()
        // now check if the module needs updating
        if moduleUpdate {
            // Update the module progress
            print("Lesson Complete. Updating Module Progress")
            let newModuleProgress = await incrementModuleProgress()
            // Now check if we need to make new user module progress
            if newModuleProgress {
                // Need to determine the next module.
                print("Making next module and lesson progress")
                if let index = modules.firstIndex(where: { $0.name == currentModuleProgress!.moduleName!}) {
                    // Don't overreach if end of modules
                    if index + 1 < modules.count {
                        //
                        let tempModuleProgress = UserModuleProgress(name: "User Module Progress", lastFinished: 0, moduleComplete: false, user: currentModuleProgress!.user, module: "I think this value should be removed later", moduleName: modules[index + 1].name)
                        let tempLessonProgress = UserLessonProgress(name: "User Lesson Progress", lastFinished: 0, lessonComplete: false, user: currentModuleProgress!.user, lesson: "I think this value should be removed later", lessonName: modules[index + 1].lessonNames![0])
                        // Add new data to server
                        await createUserModuleProgress(userModuleProgress: tempModuleProgress)
                        await createUserLessonProgress(userLessonProgress: tempLessonProgress)
                    }
                }
                else {
                    print("Modules empty or not found")
                }
            }
            // Make new user lesson progress since module didn't need to be made
            else if let currentModule = modules.first(where: {$0.name == currentModuleProgress!.moduleName!}) {
                dump(currentModule)
                print("Making new lesson progress for next lesson")
                if let index = currentModule.lessonNames!.firstIndex(where: {$0 == currentLesson!.name}) {
                    // Don't overreach if end of lessons
                    if index + 1 < currentModule.lessons!.count {
                        let tempLessonProgress = UserLessonProgress(name: "User Lesson Progress", lastFinished: 0, lessonComplete: false, user: currentLessonProgress!.user, lesson: "I think this value should be removed later", lessonName: currentModule.lessonNames![index + 1])
                        // Add new data to server
                        await createUserLessonProgress(userLessonProgress: tempLessonProgress)
                    }
                }
                else {
                    print("Lessons empty")
                }
            }
            else {
                print("Modules empty or not found")
            }
        }
        //check if end of lesson
        if currentContentIndex >= currentLesson!.length! - 1 {
            DispatchQueue.main.async{
                self.endOfLesson = true
            }
        }
    }
    
    func endLessonEarly() {
        DispatchQueue.main.async{
            self.endEarly = true
        }
    }
}

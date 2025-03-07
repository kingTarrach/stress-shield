import Foundation
import SwiftUI
import FirebaseAuth

class ModuleViewModel: ObservableObject {
    
    private let model = FirebaseTools()
    
    // function to return modules
    private func fetchModules() async -> [LearnModule]? {
        return await model.getCollectionFromFirestore(collection: "Modules", as: LearnModule.self)
    }
    
    // function to return lessons
    private func fetchLessons(
    ) async -> [Lesson]? {
        return await model.getCollectionFromFirestore(collection: "Lessons", as: Lesson.self)
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
    
    private func createViewingLessons(
        module: LearnModule,
        lessons: [Lesson],
        userLessonProgress: [UserLessonProgress]
    ) -> [ViewingLesson] {
        var viewingLessons: [ViewingLesson] = []
        for (index, lessonName) in module.lessonNames!.enumerated() {
            if let relatedLesson = lessons.first(where: { $0.name == lessonName}) {
                // associated lesson progress
                if let relatedLessonProgress = userLessonProgress.first(where: { $0.lessonName == lessonName}) {
                    viewingLessons.append(ViewingLesson(name: lessonName, progress: relatedLessonProgress.lastFinished!, length: relatedLesson.length!, locked: false, id: module.lessons![index]))
                }
                // no associated lesson progress
                else {
                    viewingLessons.append(ViewingLesson(name: lessonName, progress: 0, length: relatedLesson.length!, locked: true, id: module.lessons![index]))
                }
            }
        }
        return viewingLessons
    }
    
    func createViewingModules() async -> [ViewingModule] {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return []
        }
        let modules = await fetchModules()
        guard let modules else {
            return []
        }
        let moduleProgress = await fetchModuleProgress()
        guard let moduleProgress else {
            return []
        }
        let lessonProgress = await fetchLessonProgress()
        guard let lessonProgress else {
            return []
        }
        let lessons = await fetchLessons()
        guard let lessons else {
            return []
        }
        
        var viewingModules: [ViewingModule] = []
        for module in modules {
            let viewingLessons = createViewingLessons(module: module, lessons: lessons, userLessonProgress: lessonProgress)
            if let relatedModuleProgress = moduleProgress.first(where: { $0.moduleName == module.name}) {
                viewingModules.append(ViewingModule(name: module.name, progress: relatedModuleProgress.lastFinished!, length: module.length!, locked: false, lessons: viewingLessons))
            }
            else {
                viewingModules.append(ViewingModule(name: module.name, progress: 0, length: module.length!, locked: true, lessons: viewingLessons))
            }
        }
        print(viewingModules)
        return viewingModules
    }
    
}

class ViewingModule {
    let name: String
    let progress: Int
    let length: Int
    let locked: Bool
    let lessons: [ViewingLesson]
    
    init(name: String, progress: Int, length: Int, locked: Bool, lessons: [ViewingLesson]) {
        self.name = name
        self.progress = progress
        self.length = length
        self.locked = locked
        self.lessons = lessons
    }
}

class ViewingLesson {
    let name: String
    let progress: Int
    let length: Int
    let locked: Bool
    let id: String
    
    init(name: String, progress: Int, length: Int, locked: Bool, id: String) {
        self.name = name
        self.progress = progress
        self.length = length
        self.locked = locked
        self.id = id
    }
}

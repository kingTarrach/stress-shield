//
//  RegisterViewVM.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 10/4/24.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation

class RegisterViewVM: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMsg = ""
    
    private let model = FirebaseTools()
    
    init() {}
    
    func register() {
        guard validate() else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let userId = result?.user.uid else {
                self?.errorMsg = "User already exists."
                return
            }
            
            self?.insertUserRecord(id: userId)
            Task {
                await self?.createFirstLessonAndModule(id: userId)
            }
        }
    }
    
    private func insertUserRecord(id: String) {
        let newUser = User(id: id, name: name, email: email, joined: Date().timeIntervalSince1970)
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    private func createFirstLessonAndModule(id: String) async {
        let modules = await model.getCollectionFromFirestore(collection: "LearnModule", as: LearnModule.self)
        guard let modules else {
            return
        }
        let sortedModules = modules.sorted { $0.order! < $1.order!}
        let firstModule = sortedModules[0]
        let firstLesson = firstModule.lessons![0]
        let firstLessonName = firstModule.lessonNames![0]
        let tempLesson = UserLessonProgress(name: "user's first lesson", lastFinished: 0, lessonComplete: false, user: id, lesson: firstLesson, lessonName: firstLessonName)
        let tempModule = UserModuleProgress(name: "user's first module", lastFinished: 0, moduleComplete: false, user: id, module: "I think this value should be removed later", moduleName: firstModule.name)
        await model.addDocumentToFirestore(collection: "UserLessonProgress", document: tempLesson)
        await model.addDocumentToFirestore(collection: "UserModuleProgress", document: tempModule)
    }
    
    private func validate() -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMsg = "Please fill in all fields."
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMsg = "Please enter valid email."
            return false
        }
        
        guard password.count >= 6 else {
            errorMsg = "Password must be at least 6 characters long."
            return false
        }
        
        guard password == confirmPassword else {
            errorMsg = "Passwords do not match."
            return false
        }
        
        return true
    }
}

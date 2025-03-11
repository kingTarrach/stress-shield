import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Foundation

// Code for general queries, does not handle object transfers.

// May need 'async' in try statement to not block thread

class FirebaseTools {
    // Function to create new document.
    // Inputs:
    // - collection as a string refers to the name/grouping of documents
    // - documentFields as a String: Any dictionary refers to the fields being added to the document
    // Autogenerates id
    func addDocumentToFirestore(
        collection: String,
        documentFields: [String: Any],
        set: Bool = false
    ) async {
        let db = Firestore.firestore()
        let ref = db.collection(collection)
        
        do {
            try await ref.addDocument(data: documentFields)
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }

    // Function to update document with entire new fields.
    // Inputs:
    // - collection as a string refers to the name/grouping of documents
    // - documentID as a string refers to the name/id of document
    // - documentFields as a String: Any dictionary refers to the fields being added to the document
    // MAKE SURE THAT ID REFERS TO DOCUMENT THAT EXISTS OTHERWISE NEW DOCUMENT CREATED
    func updateFullDocumentInFirestore(
        collection: String,
        documentID: String,
        documentFields: [String: Any],
        set: Bool = false
    ) async {
        let db = Firestore.firestore()
        let ref = db.collection(collection).document(documentID)
        
        do {
            try await ref.setData(documentFields)
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }

    // Function to update only the fields specified.
    // Inputs:
    // - collection as a string refers to the name/grouping of documents
    // - documentID as a string refers to the name/id of document
    // - documentFields as a String: Any dictionary refers to the fields being changed in the document
    // MAKE SURE THAT ID REFERS TO DOCUMENT THAT EXISTS OTHERWISE NEW DOCUMENT CREATED
    func updateFieldsOfDocumentInFirestore(
        collection: String,
        documentID: String,
        documentFields: [String: Any],
        set: Bool = false
    ) async {
        let db = Firestore.firestore()
        let ref = db.collection(collection).document(documentID)
        
        do {
            try await ref.setData(documentFields, merge: true)
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }

    // Function to return document as dictionary based on collection and ID
    // Inputs:
    // - collection as a string refers to the name/grouping of documents
    // - documentID as a string refers to the name/id of document
    func getDocumentFromFirestore(
        collection: String,
        documentID: String) async -> [String: Any]? {
            let db = Firestore.firestore()
            let docRef = db.collection(collection).document(documentID)

            do {
              let document = try await docRef.getDocument()
              if document.exists {
                let dataDescription = document.data()
                print("Document found")
                return dataDescription;
              } else {
                print("Document does not exist")
              }
            } catch {
              print("Error getting document: \(error)")
            }
            return nil;
    }

    // Function to return full collection as snapshot based on collection
    // Inputs:
    // - collection as a string refers to the name/grouping of documents
    func getCollectionFromFirestore(
        collection: String) async -> QuerySnapshot? {
            let db = Firestore.firestore()
            let collectionRef = db.collection(collection)
            
            do {
              let querySnapshot = try await db.collection("cities").getDocuments()
                return querySnapshot;
            } catch {
              print("Error getting documents: \(error)")
            }
            return nil;
        }


    // Function to return document as a defined object based on collection and ID
    // Inputs:
    // - collection as a string refers to the name/grouping of documents
    // - documentID as a string refers to the name/id of document
    func getDocumentFromFirestore<T: Decodable>(
        collection: String,
        documentID: String,
        as type: T.Type
    ) async -> T? {
        let db = Firestore.firestore()
        let docRef = db.collection(collection).document(documentID)

        do {
            let document = try await docRef.getDocument()
            if document.exists {
                let decodedData = try document.data(as: T.self)
                print("Document successfully decoded")
                return decodedData
            } else {
                print("Document does not exist")
            }
        } catch {
            print("Error getting document: \(error)")
        }
        return nil
    }

    // Function to return full collection as list of defined objects based on collection
    // Inputs:
    // - collection as a string refers to the name/grouping of documents
    func getCollectionFromFirestore<T: Decodable>(
        collection: String,
        as type: T.Type
    ) async -> [T]? {
        let db = Firestore.firestore()
        let collectionRef = db.collection(collection)

        do {
            let querySnapshot = try await collectionRef.getDocuments()
            let documents = querySnapshot.documents.compactMap { document in
                try? document.data(as: T.self)
            }
            print("Successfully fetched \(documents.count) documents")
            return documents
        } catch {
            print("Error getting documents: \(error)")
        }
        return nil
    }

    // Function to create new document.
    // Inputs:
    // - collection as a string refers to the name/grouping of documents
    // - document as an object refers to the object being converted to dictionary
    // Autogenerates id
    func addDocumentToFirestore<T: Encodable>(
        collection: String,
        document: T,
        set: Bool = false
    ) async {
        let db = Firestore.firestore()
        let ref = db.collection(collection).document()
        
        do {
            try await ref.setData(from: document)
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }

    // Function to update document with entire new fields.
    // Inputs:
    // - collection as a string refers to the name/grouping of documents
    // - documentID as a string refers to the name/id of document
    // - document as a object refers to the object being added to the document
    // MAKE SURE THAT ID REFERS TO DOCUMENT THAT EXISTS OTHERWISE NEW DOCUMENT CREATED
    func updateFullDocumentInFirestore<T: Encodable>(
        collection: String,
        documentID: String,
        document: T,
        set: Bool = false
    ) async {
        let db = Firestore.firestore()
        let ref = db.collection(collection).document(documentID)
        
        do {
            try await ref.setData(from: document)
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
    // Function to return full collection as list of defined objects based on collection
    // Inputs:
    // - collection as a string refers to the name/grouping of documents
    // - userID as a string refers to the current user being checked against for user specific data
    func getCollectionFromFirestore<T: Decodable>(
        collection: String,
        as type: T.Type,
        userID: String
    ) async -> [T]? {
        let db = Firestore.firestore()
        let collectionRef = db.collection(collection).whereField("user", isEqualTo: userID)

        do {
            let querySnapshot = try await collectionRef.getDocuments()
            let documents = querySnapshot.documents.compactMap { document in
                try? document.data(as: T.self)
            }
            print("Successfully fetched \(documents.count) documents")
            return documents
        } catch {
            print("Error getting documents: \(error)")
        }
        return nil
    }
    
    func updateFullDocumentInFirestore<T: Encodable>(
        collection: String,
        field: String,
        value: String,
        userID: String,
        data: T
    ) async {
        let db = Firestore.firestore()
        // Step 1: Query for the document using the field and value
        let docRef = db.collection(collection).whereField(field, isEqualTo: value).whereField("user", isEqualTo: userID)
        
        do {
            let querySnapshot = try await docRef.getDocuments()
            let document = querySnapshot.documents.first
            guard let document else {
                print("No document found")
                return
            }
            let docID = document.documentID
            
            await updateFullDocumentInFirestore(collection: collection, documentID: docID, document: data)
        } catch {
            print("Error writing document: \(error)")
        }
    }
}



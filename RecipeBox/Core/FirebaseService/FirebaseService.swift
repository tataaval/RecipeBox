//
//  FirebaseService.swift
//  RecipeBox
//
//  Created by Tatarella on 10.11.24.
//

import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class FirebaseService {
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    static let shared = FirebaseService()
    
    func fetchAllRecipes(completion: @escaping (Result<[RecipeModel], Error>) -> Void) {
        db.collection("recipes").order(by: "created_at", descending: true)
            .getDocuments(source: .default) { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let recipes = documents.compactMap { doc -> RecipeModel? in
                    let data = doc.data()
                    return RecipeModel(from: data, with: doc.documentID)
                }
                
                completion(.success(recipes))
            }
    }
    
    func fetchUserRecipes(completion: @escaping (Result<[RecipeModel], Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        db.collection("recipes").order(by: "created_at", descending: true)
            .whereField("userId", isEqualTo: userId)
            .getDocuments(source: .default) { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let recipes = documents.compactMap { doc -> RecipeModel? in
                    let data = doc.data()
                    return RecipeModel(from: data, with: doc.documentID)
                }
                
                completion(.success(recipes))
            }
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef = storage.reference().child("recipe_images/\(UUID().uuidString).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.6) else {
            completion(.failure(NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to compress image"])))
            return
        }
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print (error)
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print(error)
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }
    }
    
    func saveRecipeData(_ data: RecipeData, imageURL: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        let recipeData: [String: Any] = [
            "name": data.title,
            "time": data.cookingTime,
            "ingredients": data.ingredients,
            "steps": data.steps,
            "userId": userId,
            "created_at": Timestamp(),
            "imageURL": imageURL ?? ""
        ]
        
        db.collection("recipes").addDocument(data: recipeData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func updateRecipeData(recipeId: String, data: RecipeData, image: UIImage?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Unauthenticated", code: 401, userInfo: nil)))
            return
        }
        
        let recipeRef = db.collection("recipes").document(recipeId)
        var updatedData: [String: Any] = [
            "name": data.title,
            "time": data.cookingTime,
            "ingredients": data.ingredients,
            "steps": data.steps,
            "userId": userId,
            "updated_at": Timestamp()
        ]
        
        if let image = image {
            uploadImage(image) { [weak self] result in
                switch result {
                case .success(let imageURL):
                    updatedData["imageURL"] = imageURL
                    recipeRef.updateData(updatedData) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(()))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            recipeRef.updateData(updatedData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    func fetchRecipes(withName name: String, completion: @escaping (Result<[RecipeModel], Error>) -> Void) {
        let db = Firestore.firestore()
        
        let recipesRef = db.collection("recipes")
        
        recipesRef.whereField("name", isGreaterThanOrEqualTo: name)
            .whereField("name", isLessThanOrEqualTo: name + "\u{f8ff}")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let recipes = documents.compactMap { doc -> RecipeModel? in
                    let data = doc.data()
                    return RecipeModel(from: data, with: doc.documentID)
                }
                
                completion(.success(recipes))
                
            }
    }
    
}

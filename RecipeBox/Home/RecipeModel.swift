//
//  recipeMOdel.swift
//  RecipeBox
//
//  Created by Tatarella on 26.10.24.
//

class RecipeModel: Codable {
    let id: String
    let name: String
    let time: String
    let ingredients: [String]
    let steps: [String]
    let userId: String
    let imageURL: String
    
    init?(from data: [String: Any], with id: String) {
        guard
            let name = data["name"] as? String,
            let time = data["time"] as? String,
            let ingredients = data["ingredients"] as? [String],
            let steps = data["steps"] as? [String],
            let userId = data["userId"] as? String,
            let imageURL = data["imageURL"] as? String
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.time = time
        self.ingredients = ingredients
        self.steps = steps
        self.userId = userId
        self.imageURL = imageURL
    }
    
}

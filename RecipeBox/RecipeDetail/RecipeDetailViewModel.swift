//
//  RecipeDetailViewModel.swift
//  RecipeBox
//
//  Created by Tatarella on 28.10.24.
//

import Foundation
import FirebaseAuth

protocol RecipeDetailViewModelInput {
    func updateFavorites()
}

class RecipeDetailViewModel {
    
    var input: RecipeDetailViewModelInput { self }
    
    var recipe: RecipeModel?
    
    var isEditAvaliable: Bool {
        guard let currentUserID = Auth.auth().currentUser?.uid,
              let recipeUserID = recipe?.userId else {
            return false
        }
        return currentUserID == recipeUserID
    }
    
    init(recipe: RecipeModel) {
        self.recipe = recipe
    }
}

extension RecipeDetailViewModel: RecipeDetailViewModelInput {
    func updateFavorites() {
        FavouritesManager.shared.toggleItem(self.recipe!)
    }
}

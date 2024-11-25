//
//  CreateRecipeViewModel.swift
//  RecipeBox
//
//  Created by Tatarella on 25.10.24.
//

import UIKit

protocol CreateRecipeViewModelType {
    var input: CreateRecipeViewModelInput { get }
    var output: CreateRecipeViewModelOutput? { get set }
}

protocol CreateRecipeViewModelInput {
    func saveRecipe(with data: RecipeData)
}

protocol CreateRecipeViewModelOutput: AnyObject {
    func recipeDidSave()
    func recipeSavingFailed()
}

class CreateRecipeViewModel: NSObject, CreateRecipeViewModelType {
    
    var input: CreateRecipeViewModelInput { self }
    
    weak var output: CreateRecipeViewModelOutput?
    
    var recipeToEdit: RecipeModel?
    
    init(recipe: RecipeModel? = nil) {
        self.recipeToEdit = recipe
    }
    
    private func createRecipe(with data: RecipeData) {
        if let image = data.selectedImage {
            FirebaseService.shared.uploadImage(image) { [weak self] result in
                switch result {
                case .success(let imageURL):
                    FirebaseService.shared.saveRecipeData(data, imageURL: imageURL) { [weak self] result in
                        switch result {
                        case .success:
                            self?.output?.recipeDidSave()
                        case .failure:
                            self?.output?.recipeSavingFailed()
                        }
                    }
                case .failure:
                    self?.output?.recipeSavingFailed()
                }
            }
        } else {
            FirebaseService.shared.saveRecipeData(data, imageURL: nil) { [weak self] result in
                switch result {
                case .success:
                    self?.output?.recipeDidSave()
                case .failure:
                    self?.output?.recipeSavingFailed()
                }
            }
        }
    }
    
    private func updateRecipe(_ recipeToEdit: RecipeModel, with data: RecipeData) {
        FirebaseService.shared.updateRecipeData(recipeId: recipeToEdit.id, data: data, image: data.selectedImage) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.recipeToEdit = nil 
                    self?.output?.recipeDidSave()
                }
                
            case .failure:
                self?.output?.recipeSavingFailed()
            }
        }
    }
}

extension CreateRecipeViewModel: CreateRecipeViewModelInput {
    func saveRecipe(with data: RecipeData) {
        if let recipeToEdit = recipeToEdit {
            updateRecipe(recipeToEdit, with: data)
        } else {
            createRecipe(with: data)
        }
    }
}

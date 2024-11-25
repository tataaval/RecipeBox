//
//  ProfileViewModel.swift
//  RecipeBox
//
//  Created by Tatarella on 03.11.24.
//

import UIKit

import FirebaseAuth

protocol ProfileViewModelType {
    var input: ProfileViewModelInput { get }
    var output: ProfileViewModelOutput? { get set }
}

protocol ProfileViewModelInput {
    func fetchData()
    func logout()
}

protocol ProfileViewModelOutput: AnyObject {
    func reloadData()
}

class ProfileViewModel: NSObject, ProfileViewModelType {
    
    var recipes: [RecipeModel] = []
    
    var input: ProfileViewModelInput { self }
    weak var output: ProfileViewModelOutput?
    
}

extension ProfileViewModel: ProfileViewModelInput {
    func fetchData() {
        FirebaseService.shared.fetchUserRecipes { [weak self] result in
            switch result {
            case .success(let recipes):
                self?.recipes = recipes
                self?.output?.reloadData()
            case .failure(let error):
                print("Error fetching recipes: \(error.localizedDescription)")
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            
            if let sceneDelegate = UIApplication.shared.connectedScenes
                .first?.delegate as? SceneDelegate {
                sceneDelegate.setRootViewControllerToAuthorization()
            }
            
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

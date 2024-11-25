//
//  HomeViewModel.swift
//  RecipeBox
//
//  Created by Tatarella on 26.10.24.
//

import Foundation

protocol HomeViewModelType {
    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput? { get set }
}

protocol HomeViewModelInput {
    func fetchData(with Keyword: String?)
}

protocol HomeViewModelOutput: AnyObject {
    func reloadData()
}

class HomeViewModel: NSObject, HomeViewModelType {
    
    var recipes: [RecipeModel] = []
    
    var input: HomeViewModelInput { self }
    weak var output: HomeViewModelOutput?
}

extension HomeViewModel: HomeViewModelInput {
    func fetchData(with Keyword: String?) {
        guard let keyword = Keyword, !keyword.isEmpty else {
            FirebaseService.shared.fetchAllRecipes { [weak self] result in
                switch result {
                case .success(let recipes):
                    self?.recipes = recipes
                    self?.output?.reloadData()
                case .failure(let error):
                    print("Error fetching recipes: \(error.localizedDescription)")
                }
            }
            return
        }
        FirebaseService.shared.fetchRecipes(withName: keyword) { [weak self] result in
            switch result {
            case .success(let recipes):
                self?.recipes = recipes
                self?.output?.reloadData()
            case .failure(let error):
                print("Error fetching recipes: \(error.localizedDescription)")
            }
        }
    }
}

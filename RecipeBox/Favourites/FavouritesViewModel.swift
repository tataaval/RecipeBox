//
//  FavouritesViewModel.swift
//  RecipeBox
//
//  Created by Tatarella on 09.11.24.
//

import Foundation

protocol FavouritesViewModelType {
    var input: FavouritesViewModelInput { get }
    var output: FavouritesViewModelOutput? { get }
}

protocol FavouritesViewModelInput {
    func loadFavourites()
}

protocol FavouritesViewModelOutput: AnyObject {
    func reloadData()
}

class FavouritesViewModel: NSObject, FavouritesViewModelType {
    var input: FavouritesViewModelInput { self }
    
    weak var output: FavouritesViewModelOutput?
    
    var favorites: [RecipeModel] = []
}

extension FavouritesViewModel: FavouritesViewModelInput{
    func loadFavourites() {
        self.favorites = FavouritesManager.shared.items
        self.output?.reloadData()
    }
}

extension FavouritesViewModel: FavouritesManagerDelegate {
    func favoritesDidUpdate() {
        self.loadFavourites()
    }
}

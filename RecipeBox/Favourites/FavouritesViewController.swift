//
//  FavouritesViewController.swift
//  RecipeBox
//
//  Created by Tatarella on 09.11.24.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    private var viewModel = FavouritesViewModel()
    
    private let titleLabel = PageTitle(text: "Favourites list")
    private let emptyList = EmptyList(title: "No favourites yet", text: "All recipes marked as favourite will be added here")
    
    private let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 13
        layout.minimumLineSpacing = 13
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.output = self
        FavouritesManager.shared.delegate = viewModel
        viewModel.loadFavourites()
    }
    
    private func setupUI(){
        setupTitle()
        setupCollectionView()
        setupMessageView()
    }
    
    private func setupTitle() {
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
        ])
    }
    private func setupMessageView() {
        view.addSubview(emptyList)
        emptyList.translatesAutoresizingMaskIntoConstraints = false
        emptyList.isHidden = true
        
        NSLayoutConstraint.activate([
            emptyList.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 62),
            emptyList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -62),
        ])
    }
    
    private func setupCollectionView() {
        collection.delegate = self
        collection.dataSource = self
        
        collection.register(FavouritesCollectionViewCell.self, forCellWithReuseIdentifier: "FavouritesCollectionViewCell")
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        collection.backgroundColor = .clear
        
        view.addSubview(collection)
        
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateView() {
        if viewModel.favorites.isEmpty {
            emptyList.isHidden = false
            collection.isHidden = true
        } else {
            emptyList.isHidden = true
            collection.isHidden = false
        }
    }
}

extension FavouritesViewController: FavouritesViewModelOutput {
    func reloadData() {
        DispatchQueue.main.async {
            self.collection.reloadData()
            self.updateView()
        }
    }
}

extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentRecipe = viewModel.favorites[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouritesCollectionViewCell", for: indexPath) as! FavouritesCollectionViewCell
        cell.configure(with: currentRecipe)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 26)
        return CGSize(width: width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let curr = viewModel.favorites[indexPath.row]
        let recipeDetailViewModel = RecipeDetailViewModel(recipe: curr)
        let detailVC = RecipeDetailViewController(viewModel: recipeDetailViewModel)
        present(detailVC, animated: true)
    }
}

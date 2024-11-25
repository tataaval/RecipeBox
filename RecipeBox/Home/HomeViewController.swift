//
//  HomeViewController.swift
//  RecipeBox
//
//  Created by Tatarella on 12.10.24.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    
    private let titleLabel = PageTitle(text: "Recipe Box")
    
    private var searchbar = SearchBar()
    
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
        view.backgroundColor = .white
        setupTitle()
        setupSearchBar()
        setupCollectionView()
        searchbar.delegate = self
        viewModel.output = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navController = navigationController {
            navController.popToRootViewController(animated: false)
        }
        viewModel.fetchData(with: nil)
    }
    
    
    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
        ])
    }
    
    private func setupSearchBar(){
        view.addSubview(searchbar)
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchbar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            searchbar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            searchbar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            searchbar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupCollectionView() {
        collection.delegate = self
        collection.dataSource = self
        
        collection.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: "RecipeCollectionViewCell")
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        collection.backgroundColor = .clear
        
        view.addSubview(collection)
        
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: searchbar.bottomAnchor, constant: 20),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension HomeViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCell", for: indexPath) as! RecipeCollectionViewCell
        let currentRecipe = viewModel.recipes[indexPath.row]
        cell.configure(with: currentRecipe)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let curr = viewModel.recipes[indexPath.row]
        let recipeDetailViewModel = RecipeDetailViewModel(recipe: curr)
        let detailVC = RecipeDetailViewController(viewModel: recipeDetailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 53) / 2
        return CGSize(width: width, height: 230)
    }
    
}

extension HomeViewController: HomeViewModelOutput {
    func reloadData() {
        DispatchQueue.main.async {
            self.collection.reloadData()
        }
    }
}

extension HomeViewController: SearchBarDelegate {
    func handleSearch(keyword: String) {
        viewModel.fetchData(with: keyword)
    }
}

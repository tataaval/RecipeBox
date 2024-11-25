//
//  ProfileViewController.swift
//  RecipeBox
//
//  Created by Tatarella on 03.11.24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    private let titleLabel = PageTitle(text: "My Recipes")
    
    private let emptyList = EmptyList(title: "No recipes yet", text: "After creating, your recipes will appear here")
    
    private let viewModel = ProfileViewModel()
    
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
        setupLogoutButton()
        setupUI()
        viewModel.output = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData()
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
        
        collection.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileCollectionViewCell")
        
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
    
    private func setupLogoutButton() {
        let logoutButton = UIBarButtonItem(image: UIImage(named: "logOut"), style: .plain, target: self, action: #selector(handleLogout))
        logoutButton.tintColor = .systemRed
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc private func handleLogout() {
        viewModel.logout()
    }
    
    private func redirectToLogin() {
        let authorizationVC = AuthorizationViewController()
        authorizationVC.modalPresentationStyle = .fullScreen
        present(authorizationVC, animated: true, completion: nil)
    }
    
    private func updateView() {
        if viewModel.recipes.isEmpty {
            emptyList.isHidden = false
            collection.isHidden = true
        } else {
            emptyList.isHidden = true
            collection.isHidden = false
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentRecipe = viewModel.recipes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        cell.configure(image: currentRecipe.imageURL, title: currentRecipe.name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 53) / 2
        return CGSize(width: width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let curr = viewModel.recipes[indexPath.row]
        let recipeDetailViewModel = RecipeDetailViewModel(recipe: curr)
        let detailVC = RecipeDetailViewController(viewModel: recipeDetailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

extension ProfileViewController: ProfileViewModelOutput {
    func reloadData() {
        DispatchQueue.main.async {
            self.collection.reloadData()
            self.updateView()
        }
    }
}

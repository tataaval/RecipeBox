//
//  RecipeDetailViewController.swift
//  RecipeBox
//
//  Created by Tatarella on 28.10.24.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    var viewModel: RecipeDetailViewModel
    
    private let recipeImageView = UIImageView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        let buttonImage = UIImage(systemName: "bookmark", withConfiguration: largeConfig)
        let selectedButtonImage = UIImage(systemName: "bookmark.fill", withConfiguration: largeConfig)
        button.setImage(buttonImage, for: .normal)
        button.setImage(selectedButtonImage, for: .selected)
        button.tintColor = .accent
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let segmentedControl: UISegmentedControl = {
        var segmentedControl = UISegmentedControl(items: ["Ingredient", "Procedure"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = UIColor.accent
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        return segmentedControl
    }()
    private let ingredientsStackView: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private let procedureStackView: UIStackView = {
        var stack = UIStackView()
        stack.isHidden = true
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarkButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.bookmarkButton.isSelected.toggle()
            viewModel.updateFavorites()
        }), for: .touchUpInside)
        setupUI()
        displayIngredients()
        if viewModel.isEditAvaliable {
            setupEditButton()
        }
    }
    
    init(viewModel: RecipeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        bookmarkButton.isSelected = FavouritesManager.shared.isFavorite(viewModel.recipe!.id)
        
        // Recipe Image
        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.layer.cornerRadius = 10
        recipeImageView.clipsToBounds = true
        recipeImageView.isUserInteractionEnabled = true
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let image = viewModel.recipe?.imageURL ?? ""
        
        if let imageURL = URL(string: image) {
            self.recipeImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder")) { [weak self] downloadedImage, error, _, _ in
                if let error = error {
                    print("Failed to load image: \(error.localizedDescription)")
                    self?.recipeImageView.image = UIImage(named: "NoImage")
                } else {
                    self?.recipeImageView.image = downloadedImage
                }
            }
        } else {
            self.recipeImageView.image = UIImage(named: "NoImage")
        }
        
        titleLabel.text = viewModel.recipe?.name
    
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.spacing = 20
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addArrangedSubview(recipeImageView)
        recipeImageView.addSubview(bookmarkButton)
        contentView.addArrangedSubview(titleLabel)
        contentView.addArrangedSubview(segmentedControl)
        contentView.addArrangedSubview(ingredientsStackView)
        contentView.addArrangedSubview(procedureStackView)
        
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView Constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View Constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            // Recipe Image Constraints
            recipeImageView.heightAnchor.constraint(equalToConstant: 200),
            
            bookmarkButton.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: -12),
            bookmarkButton.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: -10),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 44),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 44),
            
            
            segmentedControl.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupEditButton() {
        let button = UIBarButtonItem(title: "edit recipe", style: .plain, target: self, action: #selector(handleEdit))
        button.tintColor = .accent
        navigationItem.rightBarButtonItem = button
    }
    
    func editRecipe(_ recipe: RecipeModel) {
        guard let tabBarController = self.tabBarController,
              let viewControllers = tabBarController.viewControllers,
              viewControllers.indices.contains(2),
              let createRecipeNavController = viewControllers[2] as? UINavigationController,
              let createRecipeViewController = createRecipeNavController.viewControllers.first as? CreateRecipeViewController else {
            return
        }
        
        if createRecipeViewController.viewModel == nil {
            createRecipeViewController.viewModel = CreateRecipeViewModel(recipe: recipe)
        } else {
            createRecipeViewController.viewModel?.recipeToEdit = recipe
        }
        
        tabBarController.selectedIndex = 2
    }
    
    
    @objc private func handleEdit() {
        guard let recipe = viewModel.recipe else { return }
        editRecipe(recipe)
    }
    
    
    @objc private func segmentedControlChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            displayIngredients()
        } else {
            displayProcedure()
        }
    }
    
    private func displayIngredients() {
        ingredientsStackView.isHidden = false
        procedureStackView.isHidden = true
        let ingredients = viewModel.recipe?.ingredients ?? []
        ingredientsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for ingredient in ingredients {
            let ingredientCard = IngredientCardView(name: ingredient)
            ingredientsStackView.addArrangedSubview(ingredientCard)
        }
    }
    
    private func displayProcedure() {
        ingredientsStackView.isHidden = true
        procedureStackView.isHidden = false
        let steps = viewModel.recipe?.steps ?? []
        procedureStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for step in steps {
            let ingredientCard = StepsCardView(name: step)
            procedureStackView.addArrangedSubview(ingredientCard)
        }
    }
}

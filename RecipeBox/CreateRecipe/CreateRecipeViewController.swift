//
//  CreateRecipeViewController.swift
//  RecipeBox
//
//  Created by Tatarella on 23.10.24.
//

import UIKit

class CreateRecipeViewController: UIViewController {
    
    var viewModel: CreateRecipeViewModel!
    
    private let titleLabel = PageTitle(text: "Create your own Recipe")
    
    private let recipeFormView = RecipeForm()
    
    var recipeToEdit: RecipeModel? {
        didSet {
            guard isViewLoaded else { return }
            if let recipeToEdit = recipeToEdit {
                recipeFormView.configureWithRecipeData(recipeToEdit)
            } else {
                recipeFormView.resetFields()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel?.output = self
        recipeFormView.delegate = self
        enableKeyboardHandling()
        
        if let recipeToEdit = viewModel?.recipeToEdit {
            recipeFormView.configureWithRecipeData(recipeToEdit)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let recipeToEdit = viewModel?.recipeToEdit {
            recipeFormView.configureWithRecipeData(recipeToEdit)
        }
    }
    
    init(viewModel: CreateRecipeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        disableKeyboardHandling()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(recipeFormView)
        
        recipeFormView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            
            recipeFormView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            recipeFormView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipeFormView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recipeFormView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func showAlert(with message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alertController, animated: true)
    }}

extension CreateRecipeViewController: CreateRecipeViewModelOutput {
    func recipeDidSave() {
        recipeFormView.resetFields()
        recipeToEdit = nil
        showAlert(with: "Recipe saved successfully!") { [weak self] in
            guard let tabBarController = self?.tabBarController else { return }
            
            tabBarController.selectedIndex = 3
            
            if let navController = tabBarController.viewControllers?[3] as? UINavigationController {
                navController.popToRootViewController(animated: false)
            }
        }
    }
    
    func recipeSavingFailed() {
        showAlert(with: "Error saving recipe")
    }
    
}

extension CreateRecipeViewController: RecipeFormDelegate {
    func resetFieldsButtonCliked() {
        viewModel.recipeToEdit = nil
        recipeFormView.resetFields()
    }
    
    func didReciveError(_ message: String) {
        showAlert(with: message)
    }
    
    func didCreateRecipe(_ recipe: RecipeData) {
        viewModel?.saveRecipe(with: recipe)
    }
    
    func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
}

extension CreateRecipeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            recipeFormView.recipeImageView.isHidden = false
            recipeFormView.recipeImageView.image = selectedImage
            recipeFormView.selectedImage = selectedImage
        }
        picker.dismiss(animated: true)
    }
}

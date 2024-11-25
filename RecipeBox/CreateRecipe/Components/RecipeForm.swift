//
//  RecipeForm.swift
//  RecipeBox
//
//  Created by Tatarella on 23.10.24.
//

import UIKit

protocol RecipeFormDelegate: AnyObject {
    func didCreateRecipe(_ recipe: RecipeData)
    func didReciveError(_ message: String)
    func resetFieldsButtonCliked()
    func selectImage()
}

class RecipeForm: UIView, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    weak var delegate: RecipeFormDelegate?
    
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
    var selectedImage: UIImage?
    
    private let titleField = FormInput(placeholder: "Title")
    private let timeField = FormInput(placeholder: "Cooking Time")
    
    private let ingredientsStackView = DynamicInputStack(inputPlaceholder: "ingredient", buttonTitle: "add Ingredients")
    
    private let stepsStackView = DynamicInputStack(inputPlaceholder: "step", buttonTitle: "step")
    
    let recipeImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    private var addImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .accent
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitle("add image", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .accent
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitle("save receipe", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var resetButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitle("reset fields", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        saveButton.addAction(UIAction(handler: { [weak self] _ in
            self?.saveRecipeTapped()
        }), for: .touchUpInside)
        
        resetButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.resetFieldsButtonCliked()
        }), for: .touchUpInside)
        
        addImageButton.addAction(UIAction(handler: { [weak self] _ in
            self?.addImageTapped()
        }), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        contentView.axis = .vertical
        contentView.spacing = 20
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        contentView.addArrangedSubview(addImageButton)
        contentView.addArrangedSubview(recipeImageView)
        contentView.addArrangedSubview(titleField)
        contentView.addArrangedSubview(timeField)
        contentView.addArrangedSubview(ingredientsStackView)
        contentView.addArrangedSubview(stepsStackView)
        contentView.addArrangedSubview(saveButton)
        contentView.addArrangedSubview(resetButton)
        
        layoutUI()
    }
    
    private func layoutUI() {
        // Set up constraints for scrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Set up constraints for contentView (UIStackView inside the scrollView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            recipeImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func saveRecipeTapped() {
        let name = titleField.getText()
        let time = timeField.getText()
        
        guard !name.isEmpty, !time.isEmpty else {
            self.delegate?.didReciveError("Please fill in all fields")
            return
        }
        
        let ingredients = ingredientsStackView.getInputs()
        
        guard !ingredients.isEmpty else {
            self.delegate?.didReciveError("Please add at least one ingredient")
            return
        }
        
        let steps = stepsStackView.getInputs()
        
        guard !steps.isEmpty else {
            self.delegate?.didReciveError("Please add at least one step")
            return
        }
        
        let recipeData = RecipeData(
            title: name,
            cookingTime: time,
            ingredients: ingredients,
            steps: steps,
            selectedImage: selectedImage
        )
        
        self.delegate?.didCreateRecipe(recipeData)
        
    }
    
    private func addImageTapped() {
        self.delegate?.selectImage()
    }
    
    func resetFields() {
        titleField.clearText()
        timeField.clearText()
        ingredientsStackView.clearAllInputs()
        stepsStackView.clearAllInputs()
        selectedImage = nil
        recipeImageView.image = nil
        recipeImageView.isHidden = true
    }
    
    func configureWithRecipeData(_ recipeData: RecipeModel) {
        titleField.setText(recipeData.name)
        timeField.setText(recipeData.time)
        
        ingredientsStackView.configureWithInputs(recipeData.ingredients)
        stepsStackView.configureWithInputs(recipeData.steps)
        
        if let imageURL = URL(string: recipeData.imageURL) {
            recipeImageView.isHidden = false
            URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
                guard
                    let self = self,
                    let data = data,
                    error == nil,
                    let image = UIImage(data: data)
                else {
                    DispatchQueue.main.async {
                        self!.recipeImageView.isHidden = true
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.recipeImageView.image = image
                }
            }.resume()
        } else {
            recipeImageView.isHidden = true
        }
        
    }
}

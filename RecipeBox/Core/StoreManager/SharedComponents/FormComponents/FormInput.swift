//
//  FormInput.swift
//  RecipeBox
//
//  Created by Tatarella on 22.10.24.
//

import UIKit

class FormInput: UIView {
    
    var onRemove: (() -> Void)?
    
    private let textField: UITextField = {
        let textField = InputWithPaddings()
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 2.0
        textField.backgroundColor = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1.0)
        textField.textColor = UIColor(red: 160/255, green: 163/255, blue: 189/255, alpha: 1.0)
        
        textField.layer.borderColor = UIColor(red: 217/255, green: 219/255, blue: 233/255, alpha: 1.0).cgColor
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let trashImage = UIImage(systemName: "trash", withConfiguration: largeConfig)
        button.setImage(trashImage, for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(placeholder: String, isSecureTextEntry: Bool = false, removable: Bool = false) {
        super.init(frame: .zero)
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecureTextEntry
        if isSecureTextEntry {
            textField.textContentType = .oneTimeCode
        }
        removeButton.addAction(UIAction(handler: { [weak self] _ in
            self?.removeButtonTapped()
        }), for: .touchUpInside)
        setupView(removable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(_ isRemovable: Bool) {
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        if isRemovable {
            addSubview(removeButton)
            
            NSLayoutConstraint.activate([
                textField.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -8),
                removeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
                removeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                removeButton.heightAnchor.constraint(equalToConstant: (30)),
                removeButton.widthAnchor.constraint(equalToConstant: (30))
            ])
        } else {
            NSLayoutConstraint.activate([
                textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
        }
    }
    
    func getText() -> String {
        return textField.text ?? ""
    }
    
    func clearText() {
        textField.text = ""
    }
    
    private func removeButtonTapped() {
        onRemove?()
    }
}


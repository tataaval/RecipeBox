//
//  SearchBar.swift
//  RecipeBox
//
//  Created by Tatarella on 14.10.24.
//

import UIKit

class SearchBar: UIView {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray4.withAlphaComponent(0.4)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search recipes"
        textField.borderStyle = .none
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let searchIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .accent
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Filter"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = .accent
        button.layer.cornerRadius = 8
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        SetupInput()
        SetupFilterButton()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func SetupInput(){
        self.addSubview(containerView)
        
        containerView.addSubview(searchIconImageView)
        containerView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            searchIconImageView.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -20),
            searchIconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            searchIconImageView.widthAnchor.constraint(equalToConstant: 25),
            searchIconImageView.heightAnchor.constraint(equalToConstant: 25),
            
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            textField.topAnchor.constraint(equalTo: containerView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            
        ])
    }
    
    private func SetupFilterButton() {
        self.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            filterButton.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 10),
//            filterButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 40),
            filterButton.heightAnchor.constraint(equalToConstant: 40),
            filterButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

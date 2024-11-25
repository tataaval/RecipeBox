//
//  IngredientCardView.swift
//  RecipeBox
//
//  Created by Tatarella on 28.10.24.
//

import UIKit

class IngredientCardView: UIView {
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    
    init(name: String) {
        super.init(frame: .zero)
        setupUI()
        nameLabel.text = name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        // Icon Image View
        iconImageView.image = UIImage(systemName: "checkmark.circle") // Placeholder icon
        iconImageView.tintColor = .accent
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Name Label
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        
        
        let stackView = UIStackView(arrangedSubviews: [iconImageView, nameLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}

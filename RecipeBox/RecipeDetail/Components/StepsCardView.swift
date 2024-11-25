//
//  StepsCardView.swift
//  RecipeBox
//
//  Created by Tatarella on 23.11.24.
//

import UIKit

class StepsCardView: UIView {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}

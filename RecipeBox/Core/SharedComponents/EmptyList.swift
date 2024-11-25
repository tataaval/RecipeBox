//
//  EmptyList.swift
//  RecipeBox
//
//  Created by Tatarella on 16.11.24.
//

import UIKit

class EmptyList: UIView {
    
    private let messageTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let messageText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    init(title: String, text: String) {
        super.init(frame: .zero)
        setupView(title: title, text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(title: String, text: String) {
        
        self.messageTitle.text = title
        self.messageText.text = text
        
        addSubview(messageTitle)
        addSubview(messageText)
        
        NSLayoutConstraint.activate([
            
            messageTitle.topAnchor.constraint(equalTo: self.topAnchor),
            messageTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            messageTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            messageText.topAnchor.constraint(equalTo: messageTitle.bottomAnchor, constant: 10),
            messageText.leadingAnchor.constraint(equalTo: messageTitle.leadingAnchor),
            messageText.trailingAnchor.constraint(equalTo: messageTitle.trailingAnchor),
        ])
    }
}

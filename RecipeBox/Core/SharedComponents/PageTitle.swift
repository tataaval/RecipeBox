//
//  PageTitle.swift
//  RecipeBox
//
//  Created by Tatarella on 12.10.24.
//

import UIKit

class PageTitle: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = .black
        self.font = .preferredFont(forTextStyle: .headline)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

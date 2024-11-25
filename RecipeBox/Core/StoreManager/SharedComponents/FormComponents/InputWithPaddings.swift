//
//  InputWithPaddings.swift
//  RecipeBox
//
//  Created by Tatarella on 14.10.24.
//

import UIKit

class InputWithPaddings: UITextField {
    var textPaddings = UIEdgeInsets(
        top: 10,
        left: 24,
        bottom: 10,
        right: 24)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPaddings)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPaddings)
    }
}

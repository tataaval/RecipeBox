//
//  CustomTabBar.swift
//  RecipeBox
//
//  Created by Tatarella on 17.11.24.
//

import UIKit

class CustomTabBar: UITabBar {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let tabBarHeight = self.bounds.height
        let centerOffset: CGFloat = 5
        
        for tabBarButton in subviews where tabBarButton is UIControl {
            tabBarButton.frame.origin.y = (tabBarHeight - tabBarButton.frame.height) / 2 - centerOffset
        }
    }
}

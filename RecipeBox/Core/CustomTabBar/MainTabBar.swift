//
//  MainTabBar.swift
//  RecipeBox
//
//  Created by Tatarella on 17.11.24.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private lazy var homeVC: UINavigationController = {
        let home = UINavigationController(rootViewController: HomeViewController())
        home.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house.fill"), tag: 0)
        home.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        return home
    }()
    
    private lazy var bookmarkVC: UIViewController = {
        let bookmark = FavouritesViewController()
        bookmark.view.backgroundColor = .white
        bookmark.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bookmark"), tag: 1)
        bookmark.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        return bookmark
    }()
    
    private lazy var createVC: UIViewController = {
        let vm = CreateRecipeViewModel()
        let central = CreateRecipeViewController(viewModel: vm)
        let createRecipeNav = UINavigationController(rootViewController: central)
        central.view.backgroundColor = .white
        central.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus.circle.fill"), tag: 2)
        central.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        return createRecipeNav
    }()
    
    private lazy var profileVC: UINavigationController = {
        let profile = UINavigationController(rootViewController: ProfileViewController())
        profile.view.backgroundColor = .white
        profile.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), tag: 3)
        return profile
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
        
        let layer = CALayer()
        let tabBarBounds = self.tabBar.bounds
        let inset: CGFloat = 30
        let rect = CGRect(x: inset, y: tabBarBounds.minY + 5, width: tabBarBounds.width - 2 * inset, height: tabBarBounds.height + 5)
        
        layer.frame = rect
        layer.cornerRadius = rect.height / 3
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowRadius = 25.0
        layer.shadowOpacity = 0.4
        layer.borderWidth = 0.0
        layer.masksToBounds = false
        layer.backgroundColor = UIColor.white.cgColor
        
        self.tabBar.layer.insertSublayer(layer, at: 0)
        
        tabBar.tintColor = .accent
        tabBar.isTranslucent = true
        tabBar.unselectedItemTintColor = .gray
        tabBar.itemWidth = 40.0
        tabBar.itemPositioning = .centered
        
        viewControllers = [homeVC, bookmarkVC, createVC, profileVC]
        
        selectedIndex = 0
        
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == homeVC {
            homeVC.popToRootViewController(animated: true)
        } else if viewController == profileVC {
            profileVC.popToRootViewController(animated: true)
        }
    }
    
}

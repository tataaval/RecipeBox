//
//  AuthorizationViewController.swift
//  RecipeBox
//
//  Created by Tatarella on 14.10.24.
//

import UIKit

class AuthorizationViewController: UIViewController {
    
    private var viewModel = AuthorizationViewModel()
    
    private let authorizationForm = AuthorizationForm()
    
    private var logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        setupAuthorizationView()
        
        viewModel.output = self
        authorizationForm.delegate = self
        
    }
    
    private func setupAuthorizationView() {
        view.addSubview(logo)
        view.addSubview(authorizationForm)
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        authorizationForm.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            authorizationForm.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 40),
            authorizationForm.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authorizationForm.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            authorizationForm.heightAnchor.constraint(equalToConstant: 240),
            
        ])
    }
    
    private func showAlert(with message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

extension AuthorizationViewController: AuthorizationViewModelOutput {
    func didLoginUserSuccessfully() {
        authorizationForm.stopLoading()
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let mainTabBarController = MainTabBarController()
            sceneDelegate.window?.rootViewController = mainTabBarController
        }
    }
    
    func didReceiveError(_ message: String) {
        authorizationForm.stopLoading()
        showAlert(with: message)
    }
}

extension AuthorizationViewController: AuthorizationFormDelegate {
    
    func authorizationFormDidFinish(with email: String, password: String) {
        viewModel.input.loginUser(with: email, password: password)
    }
    
    func goToRegistration() {
        let registrationViewController = RegistrationViewController()
        navigationController?.pushViewController(registrationViewController, animated: true)
    }
}

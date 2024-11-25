//
//  RegistrationViewController.swift
//  RecipeBox
//
//  Created by Tatarella on 15.10.24.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    private let viewModel = RegistrationViewModel()
    
    private let registrationForm = RegistrationForm()
    
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
        setupRegistrationView()
        
        
        viewModel.output = self
        registrationForm.delegate = self
        
    }
    
    private func setupRegistrationView() {
        view.addSubview(logo)
        view.addSubview(registrationForm)
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        registrationForm.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            registrationForm.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 40),
            registrationForm.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            registrationForm.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            registrationForm.heightAnchor.constraint(equalToConstant: 240),
            
        ])
    }
    
    private func showAlert(with message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
}


extension RegistrationViewController: RegistrationViewModelOutput {
    
    func didRegisterUserSuccessfully() {
        registrationForm.stopLoading()
        let authorizationController = AuthorizationViewController()
        navigationController?.pushViewController(authorizationController, animated: true)
        
    }
    
    func didReceiveError(_ message: String) {
        registrationForm.stopLoading()
        showAlert(with: message)
    }
    
    
}

extension RegistrationViewController: RegistrationFormDelegate {
    
    func registrationFormDidFinish(with email: String, password: String) {
        viewModel.registerUser(with: email, password: password)
    }
    
    func goToAuthorizationController() {
        let authorizationController = AuthorizationViewController()
        navigationController?.pushViewController(authorizationController, animated: true)
    }
}

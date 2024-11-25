//
//  RegistrationForm.swift
//  RecipeBox
//
//  Created by Tatarella on 15.10.24.
//

import UIKit

protocol RegistrationFormDelegate: AnyObject {
    func registrationFormDidFinish(with email: String, password: String)
    func goToAuthorizationController()
}

class RegistrationForm: UIView {
    
    weak var delegate: RegistrationFormDelegate?
    
    private let emailField = FormInput(placeholder: "Email")
    private let passwordField = FormInput(placeholder: "Password", isSecureTextEntry: true)
    
    private var isLoading = false {
        didSet {
            updateSubmitButtonState()
        }
    }
    
    private var submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .accent
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = "Do you alredy have an account?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var auhtorizeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitle("Sign In!", for: .normal)
        button.setTitleColor(.accent, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var alternateTextWrapper: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupRegisterView()
        setupFormView()
        submitButton.addAction(UIAction(handler: { [weak self] _ in
            self?.submitForm()
        }), for: .touchUpInside)
        
        auhtorizeButton.addAction(UIAction(handler: { [weak self] _ in
            self?.authorize()
        }), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupRegisterView() {
        let stack = UIStackView(arrangedSubviews: [label, auhtorizeButton])
        
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 20
        
        alternateTextWrapper.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            stack.topAnchor.constraint(equalTo: alternateTextWrapper.topAnchor),
            stack.leadingAnchor.constraint(equalTo: alternateTextWrapper.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: alternateTextWrapper.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: alternateTextWrapper.bottomAnchor)
            
        ])
        
    }
    
    private func setupFormView() {
        
        let formStack = UIStackView(arrangedSubviews: [emailField, passwordField, alternateTextWrapper, submitButton])
        
        formStack.axis = .vertical
        formStack.distribution = .fillProportionally
        formStack.spacing = 20
        
        
        self.addSubview(formStack)
        formStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            formStack.topAnchor.constraint(equalTo: self.topAnchor),
            formStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            formStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            formStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
        ])
    }
    
    private func updateSubmitButtonState() {
        submitButton.isEnabled = !isLoading
        submitButton.setTitle(isLoading ? "Loading..." : "Log In", for: .normal)
    }
    
    func stopLoading() {
        isLoading = false
    }
    
    private func submitForm() {
        guard !isLoading else { return }
        isLoading = true
        self.delegate?.registrationFormDidFinish(with: emailField.getText(), password: passwordField.getText())
    }
    
    private func authorize() {
        self.delegate?.goToAuthorizationController()
    }
}

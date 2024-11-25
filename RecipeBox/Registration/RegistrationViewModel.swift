//
//  RegistrationViewModel.swift
//  RecipeBox
//
//  Created by Tatarella on 18.10.24.
//

import Foundation
import FirebaseAuth

protocol RegistrationViewModelType {
    var input : RegistrationViewModelInput { get }
    var output : RegistrationViewModelOutput? { get set}
}

protocol RegistrationViewModelInput {
    func registerUser(with email: String?, password: String?)
}

protocol RegistrationViewModelOutput: AnyObject {
    func didRegisterUserSuccessfully()
    func didReceiveError(_ message: String)
}

class RegistrationViewModel: NSObject, RegistrationViewModelType {
    
    var input: RegistrationViewModelInput { self }
    
    weak var output: RegistrationViewModelOutput?
    
}

extension RegistrationViewModel: RegistrationViewModelInput {
    
    func registerUser(with email: String?, password: String?) {
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            output?.didReceiveError("Please fill out all fields.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.output?.didReceiveError(error.localizedDescription)
                
            } else {
                self.output?.didRegisterUserSuccessfully()
            }
        }
    }
}

//
//  AuthorizationViewModel.swift
//  RecipeBox
//
//  Created by Tatarella on 19.10.24.
//

import Foundation
import FirebaseAuth

protocol AuthorizationViewModelType {
    var input: AuthorizationViewModelInput { get }
    var output: AuthorizationViewModelOutput? { get set }
}

protocol AuthorizationViewModelInput {
    func loginUser(with email: String?, password: String?)
}

protocol AuthorizationViewModelOutput: AnyObject {
    func didLoginUserSuccessfully()
    func didReceiveError(_ message: String)
}


class AuthorizationViewModel : NSObject, AuthorizationViewModelType {
    
    var input: AuthorizationViewModelInput { self }
    
    weak var output: AuthorizationViewModelOutput?
    
}

extension AuthorizationViewModel: AuthorizationViewModelInput {
    
    func loginUser(with email: String?, password: String?) {
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            output?.didReceiveError("Please fill out all fields.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.output?.didReceiveError(error.localizedDescription)
            } else {
                self.output?.didLoginUserSuccessfully()
            }
        }
    }
}


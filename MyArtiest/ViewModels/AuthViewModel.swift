//
//  AuthViewModel.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import Foundation

class AuthViewModel {
    
    // MARK: - Properties
    
    private let authManager = AuthManager.shared
    
    // MARK: - Methods
    
    func signInUrl() -> URL? {
        return authManager.signInUrl
    }
    
    func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
        authManager.exchangeCodeForToken(code: code, completion: completion)
    }
}

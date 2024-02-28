//
//  SettingsViewModel.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/27/24.
//

import Foundation

class SettingsViewModel {
    
    // MARK: - Methods
    
    func fetchProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        APICaller.shared.getProfile() { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

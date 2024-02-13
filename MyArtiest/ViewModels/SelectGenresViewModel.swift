//
//  SelectGenresViewModel.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import Foundation

class SelectGenresViewModel {
    
    // MARK: - Properties
    
    var allGenres: [String]!
    
    // MARK: - Methods
    
    func fetchData(completion: @escaping (Result<GenreResponse, Error>) -> Void) {
        APICaller.shared.getGenres { result in
            switch result {
            case .success(let response):
                self.allGenres = response.genres
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveSelectedGenres(_ selectedGenres: Set<String>) {
        UserDefaults.standard.set(Array(selectedGenres), forKey: "selectedGenres")
        UserDefaults.standard.setValue(true, forKey: "first_login")
//        UserDefaults.standard.removeObject(forKey: "first_login")
    }
}

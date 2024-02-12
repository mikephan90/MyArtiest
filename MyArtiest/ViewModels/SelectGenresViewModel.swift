//
//  SelectGenresViewModel.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import Foundation

class SelectGenresViewModel {
    
    // MARK: - Methods
    
    func fetchData(completion: @escaping (Result<GenreResponse, Error>) -> Void) {
        APICaller.shared.getGenres { result in
            switch result {
            case .success(let genres):
                completion(.success(genres))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

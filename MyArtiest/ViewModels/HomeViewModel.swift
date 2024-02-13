//
//  HomeViewModel.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import Foundation

class HomeViewModel {
    
    func fetchSongs(genres: Set<String>, completion: @escaping (Result<[AudioTrack], Error>) -> Void) {
        APICaller.shared.getRecommendedTracks(genres: genres) { result in
            switch result {
            case .success(let recommended):
                completion(.success(recommended.tracks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
}

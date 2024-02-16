//
//  PlayerViewModel.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/15/24.
//

import Foundation

class PlayerViewModel {
    
    // MARK: - Methods
    
    func fetchTrack(track: AudioTrack, completion: @escaping (Result<AudioTrack, Error>) -> Void) {
        APICaller.shared.getRecommendedTrack(track: track) { result in
            
                switch result {
                case .success(let track):
                    completion(.success(track))
                case .failure(let error):
                    completion(.failure(error))
                }
        
        }
    }
    
}

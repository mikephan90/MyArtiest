//
//  AlbumViewModel.swift.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/17/24.
//

import Foundation

class AlbumViewModel {
    
    // MARK: - Properties
    
    // MARK: - Methods
    
    func fetchAlbumTracks(completion: @escaping (Result<[AudioTrack], Error>) -> Void) {
        APICaller.shared.getAlbumTracks(albumId: "") { result in
            switch result {
            case .success(let audioTracks):
                completion(.success(audioTracks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

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
    
    func fetchAlbumTracks(albumId: String, completion: @escaping (Result<AlbumTracksResponse, Error>) -> Void) {
        APICaller.shared.getAlbumTracks(albumId: albumId) { result in
            switch result {
            case .success(let audioTracks):
                completion(.success(audioTracks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

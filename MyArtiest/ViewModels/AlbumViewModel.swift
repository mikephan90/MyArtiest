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
    
    func fetchData(albumId: String, artistId: String, completion: @escaping (Result<([AudioTrack], [Album]), Error>) -> Void) {
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        
        var tracks: [AudioTrack] = []
        var albums: [Album] = []
        
        APICaller.shared.getAlbumTracks(albumId: albumId) { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let audioTracks):
                tracks = audioTracks.items
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        APICaller.shared.getArtistAlbums(artistId: artistId) { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let artistAlbums):
                albums = artistAlbums
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        group.notify(queue: .main) {
            completion(.success((tracks, albums)))
        }
    }
}

//
//  ArtistViewModel.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/22/24.
//

import Foundation

final class ArtistViewModel {
    
    // MARK: - Properties
    
    // MARK: - Methods
    
    func fetchArtistData(artistId: String, completion: @escaping (Result<(Artist, [AudioTrack], [Album]), Error>) -> Void) {
        let group = DispatchGroup()
        
        var artist: Artist?
        var tracks: [AudioTrack] = []
        var albums: [Album] = []
        
        group.enter()
        group.enter()
        group.enter()
        
        APICaller.shared.getArtistInfo(artistId: artistId) { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let artistInfo):
                artist = artistInfo
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        APICaller.shared.getArtistTracks(artistId: artistId) { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let audioTracks):
                tracks = audioTracks
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
            guard let artist else { return }
            completion(.success((artist, tracks, albums)))
        }
    }
}

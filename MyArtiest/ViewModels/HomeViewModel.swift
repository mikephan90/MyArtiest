//
//  HomeViewModel.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import Foundation

class HomeViewModel {
    
    var genres: Set<String> = []
    var recommendedTracks: [AudioTrack] = []
    
    func search(query: String, completion: @escaping (Result<SearchResultResponse, Error>) -> Void) {
        APICaller.shared.search(with: query) { result in
            completion(result)
        }
    }
    
    func fetchData(completion: @escaping (Result<([AudioTrack], [Album]), Error>) -> Void) {
        
        let group = DispatchGroup()
        var newAlbums: [Album] = []
        var recommendedSongs: [AudioTrack] = []
        
        group.enter()
        group.enter()
        
        APICaller.shared.getRecommendedTracks(genres: genres) { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let response):
                self.recommendedTracks = response.tracks
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        APICaller.shared.getNewAlbumReleases { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let response):
                newAlbums = response.albums.items
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        group.notify(queue: .main) {
            completion(.success((recommendedSongs, newAlbums)))
        }
    }
}

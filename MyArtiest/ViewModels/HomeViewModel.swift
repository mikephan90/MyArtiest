//
//  HomeViewModel.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import Foundation
import CoreData
import UIKit

class HomeViewModel: SearchResultViewControllerDelegate {
    // MARK: - Properties
    
    var genres: Set<String> = []
    var recommendedTracks: [AudioTrack] = []
    var favoriteArtists: Set<FavoriteArtist> = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    weak var searchResultDelegate: SearchResultViewControllerDelegate?
    
    // MARK: - Methods
    
    func search(query: String, completion: @escaping (Result<SearchResultResponse, Error>) -> Void) {
        APICaller.shared.search(with: query) { result in
            completion(result)
        }
    }
    
    func fetchData(completion: @escaping (Result<([AudioTrack], [Album]), Error>) -> Void) {
        getGenresFromCoreData()
        
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
    
    func getFavoriteArtistsFromCoreData() {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteArtist> = FavoriteArtist.fetchRequest()
        self.favoriteArtists.removeAll()
        do {
            let favoriteArtists = try context.fetch(fetchRequest)
            for favoriteArtist in favoriteArtists {
                self.favoriteArtists.insert(favoriteArtist)
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func getGenresFromCoreData() {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Genre> = Genre.fetchRequest()
        self.genres.removeAll()
        do {
            let genres = try context.fetch(fetchRequest)
            for genre in genres {
                if let name = genre.value(forKey: "name") as? String {
                    self.genres.insert(name)
                } else {
                    print("Value for key 'name' is not a string or is nil")
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func showResult(_ controller: UIViewController) {
        //
    }
    
    func didTapArtistResult(_ resultId: String) {
        searchResultDelegate?.didTapArtistResult(resultId)
    }
    
    func didTapAlbumResult(_ album: Album) {
        searchResultDelegate?.didTapAlbumResult(album)
    }
}

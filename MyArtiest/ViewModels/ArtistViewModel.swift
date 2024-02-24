//
//  ArtistViewModel.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/22/24.
//

import Foundation
import CoreData
import UIKit

protocol ArtistViewModelDelegate: AnyObject {
    func didRemoveArtistFromFavorites(artistId: String)
    func didAddArtistToFavorites(artistId: String)
}

final class ArtistViewModel {
    
    // MARK: - Properties
    
    var isAlreadyFavorite: Bool = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let fetchRequest: NSFetchRequest<FavoriteArtist> = FavoriteArtist.fetchRequest()
    weak var delegate: ArtistViewModelDelegate?
    
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
    
    func saveToFavoriteArtist(artist: Artist) {
        let artistId = String(artist.id)
        let context = appDelegate.persistentContainer.viewContext
        
        fetchRequest.predicate = NSPredicate(format: "spotifyId == %@", artistId)
        
        guard let entity = NSEntityDescription.entity(forEntityName: "FavoriteArtist", in: context) else {
            fatalError("Unable to find entity description in model")
        }
        
        do {
            let existingObjects = try context.fetch(fetchRequest)
            if existingObjects.first != nil {
                print("An object with the same attribute value already exists")
            } else {
                let managedObject = FavoriteArtist(entity: entity, insertInto: context)
                
                managedObject.spotifyId = artistId
                managedObject.name = artist.name
                
                try context.save()
                print("Successfully saved artist to favorites!")
            }
        } catch {
            print("Error saving artist to favorites: \(error)")
        }
        
        delegate?.didAddArtistToFavorites(artistId: artistId)
    }
    
    func removeArtistFromFavorites(artistId: String) {
        let context = appDelegate.persistentContainer.viewContext
        fetchRequest.predicate = NSPredicate(format: "spotifyId == %@", artistId)
        
        do {
            let existingObjects = try context.fetch(fetchRequest)
            if let favoriteArtist = existingObjects.first {
                context.delete(favoriteArtist)
                try context.save()
                print("Successfully removed artist from favorites!")
            } else {
                print("Artist not found in favorites.")
            }
        } catch {
            print("Error removing artist from favorites: \(error)")
        }
        
        delegate?.didRemoveArtistFromFavorites(artistId: artistId)
    }
    
    func checkIfAlreadyFavorite(artist: Artist, completion: (Bool) -> Void) {
        let artistId = String(artist.id)
        let context = appDelegate.persistentContainer.viewContext
        do {
            let existingObjects = try context.fetch(fetchRequest)
            if existingObjects.first != nil {
                self.isAlreadyFavorite = true
                completion(true)
            } else {
                completion(false)
            }
        } catch {
            print("Error saving artist to favorites: \(error)")
            completion(false)
        }
    }
}

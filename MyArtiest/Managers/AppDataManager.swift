//
//  AppDataManager.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/24/24.
//

import Foundation
import UIKit
import CoreData

class AppDataManager {
    
    // MARK: - Properties
    
    static let shared = AppDataManager()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let fetchRequest: NSFetchRequest<FavoriteArtist> = FavoriteArtist.fetchRequest()
    
    // MARK: - Methods
    
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
    }
    
    func addArtistToFavorites(artist: Artist) {
        let artistId = String(artist.id)
        let context = appDelegate.persistentContainer.viewContext
        
        fetchRequest.predicate = NSPredicate(format: "spotifyId == %@", artistId)
        
        guard let entity = NSEntityDescription.entity(forEntityName: "FavoriteArtist", in: context) else {
            fatalError("Unable to find entity description in model")
        }
        
        let user = User(context: context)
        
        
        do {
            let existingObjects = try context.fetch(fetchRequest)
            if existingObjects.first != nil {
                print("An object with the same attribute value already exists")
            } else {
                let newArtist = FavoriteArtist(context: context)
                newArtist.name = artist.name
                newArtist.spotifyId = artistId
                user.addToFavoriteArtists(newArtist)
                
                try context.save()
                print("Successfully saved artist to favorites!")
            }
        } catch {
            print("Error saving artist to favorites: \(error)")
        }
    }
    
    func checkIfFavoriteExist(artist: Artist, completion: @escaping (Bool) -> Void) {
        let artistId = String(artist.id)
        let context = appDelegate.persistentContainer.viewContext
        do {
            let existingObjects = try context.fetch(fetchRequest)
            
            let isAlreadyFavorite = existingObjects.contains { favoriteArtist in
                return favoriteArtist.spotifyId == artistId
            }
            
            completion(isAlreadyFavorite)
        } catch {
            print("Error saving artist to favorites: \(error)")
            completion(false)
        }
    }
}

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
    
    func clearCoreDataOnSignout() {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Genre")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Error deleting data: \(error)")
        }
    }
    
    func removeArtistFromFavorites(artist: Artist) {
        let context = appDelegate.persistentContainer.viewContext
        let artistId = String(artist.id)
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
        let user = User(context: context)
        
        fetchRequest.predicate = NSPredicate(format: "spotifyId == %@", artistId)
        
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
    
    func addGenresToCoreData(genres: Set<String>) {
        let context = appDelegate.persistentContainer.viewContext
        let user = User(context: context)
        
        for genre in genres {
            fetchRequest.predicate = NSPredicate(format: "name == %@", genre)
            
            do {
                let newGenre = Genre(context: context)
                newGenre.name = genre
                user.addToGenres(newGenre)
                
                try context.save()
                print("Successfully saved genre to core data")
            } catch {
                print("Error saving artist to favorites: \(error)")
            }
        }
    }
    
    func getGenresCountFromCoreData() -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Genre> = Genre.fetchRequest()
        do {
            let genres = try context.fetch(fetchRequest)
            return genres.count > 0
        } catch {
            print("Error fetching data: \(error)")
        }
        return false
    }
    
    func checkIfFavoriteExist(artist: Artist, completion: @escaping (Bool) -> Void) {
        let context = appDelegate.persistentContainer.viewContext
        let artistId = String(artist.id)
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

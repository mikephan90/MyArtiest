//
//  OnboardingViewModel.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import Foundation
import UIKit
import CoreData

class OnboardingViewModel {
    
    // MARK: - Properties
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let fetchRequest: NSFetchRequest<Genre> = Genre.fetchRequest()
    
    var signInCompletion: ((Bool) -> Void)?
    
    // MARK: - Methods
    
    func checkForGenres() -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        do {
            let genres = try context.fetch(fetchRequest)
            return genres.count > 0
        } catch {
            print("Error fetching data: \(error)")
        }
        return false
    }
    
    // SAVE GENRES TO CORE DATA. MOVE TO SELECT GENRE SECTION
//    func saveGenresToCore() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        
//        // Need to create user after login/onbaording screen
//        let newUser = User(context: context)
//        
//        for genreName in genres {
//            let newGenre = Genre(context: context)
//            newGenre.name = genreName
//            newUser.addToGenres(newGenre)
//        }
//        
//        do {
//            try context.save()
//            print("genres saved")
//        } catch {
//            print("error saving genres")
//        }
//    }

    
    func signIn(navigationController: UINavigationController?) {
        let authViewController = AuthViewController()
        
        authViewController.completionHandler = { [weak self] success in
            self?.signInCompletion?(success)
            navigationController?.popToRootViewController(animated: true)
        }
        navigationController?.pushViewController(authViewController, animated: true)
        
        func exchangeCodeForToken(code: String) {
            AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
                self?.signInCompletion?(success)
            }
        }
    }
}


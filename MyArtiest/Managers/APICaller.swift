//
//  APICaller.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import Foundation

enum APIError: Error {
    case failedToGetData
}

enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case PUT
}

struct APIConstants {
    static let baseApiUrl = "https://api.spotify.com/v1"
}

final class APICaller {
    
    // MARK: -  Properties
    
    static let shared = APICaller()
    
    private init() {}
    
    // MARK: - Genres
    
    public func getGenres(completion: @escaping (Result<GenreResponse, Error>) -> Void) {
//        createRequest
    }
    
    // MARK: - API Helpers
    
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
//        AuthManager.shared
    }
}

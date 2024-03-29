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
    
    // MARK: - Profile
    
    public func getProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: APIConstants.baseApiUrl + "/me"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    // MARK: - Genres
    
    public func getGenres(completion: @escaping (Result<GenreResponse, Error>) -> Void) {
        createRequest(with: URL(string: APIConstants.baseApiUrl + "/recommendations/available-genre-seeds"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(GenreResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    // MARK: - Artists
    
    public func getArtistInfo(artistId: String, completion: @escaping (Result<Artist, Error>) -> Void) {
        createRequest(with: URL(string: APIConstants.baseApiUrl + "/artists/\(artistId)"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(Artist.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    public func getArtistTracks(artistId: String, completion: @escaping (Result<[AudioTrack], Error>) -> Void) {
        createRequest(with: URL(string: APIConstants.baseApiUrl + "/artists/\(artistId)/top-tracks?market=US"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(ArtistTracksResponse.self, from: data)
                    completion(.success(result.tracks))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    // MARK: - Albums
    
    public func getNewAlbumReleases(completion: @escaping (Result<NewAlbumReleasesResponse, Error>) -> Void) {
        createRequest(with: URL(string: APIConstants.baseApiUrl + "/browse/new-releases?limit=50"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewAlbumReleasesResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    public func getAlbumTracks(albumId: String, completion: @escaping (Result<AlbumTracksResponse, Error>) -> Void) {
        createRequest(with: URL(string: APIConstants.baseApiUrl + "/albums/\(albumId)/tracks"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AlbumTracksResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    public func getArtistAlbums(artistId: String, completion: @escaping (Result<[Album], Error>) -> Void) {
        createRequest(with: URL(string: APIConstants.baseApiUrl + "/artists/\(artistId)/albums"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(ArtistAlbumResponse.self, from: data)
                    completion(.success(result.items))
                } catch {
                    completion(.failure(error))
                }
                
            }.resume()
        }
    }
    
    // MARK: - Tracks
    
    public func getRecommendedTrack(track: AudioTrack, completion: @escaping (Result<AudioTrack, Error>) -> Void) {
        createRequest(with: URL(string: APIConstants.baseApiUrl + "/tracks/\(track.id)"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(AudioTrack.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    public func getRecommendedTracks(genres: Set<String>, completion: @escaping (Result<RecommendedTrackResponse, Error>) -> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: APIConstants.baseApiUrl + "/recommendations?limit=10&seed_genres=\(seeds)"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendedTrackResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    // MARK: - Search
    
    public func search(with query: String, completion: @escaping (Result<SearchResultResponse, Error>) -> Void) {
        let limit = 20
        let url = URL(string: APIConstants.baseApiUrl + "/search?limit=\(limit)&type=album,artist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
        
        createRequest(with: url, type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    
                    let albums = result.albums.items
                    let artists = result.artists.items
                    let tracks = result.tracks.items
                    
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    // MARK: - API Helpers
    
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            guard let apiUrl = url else { return }
            
            var request = URLRequest(url: apiUrl)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}

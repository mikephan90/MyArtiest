//
//  SearchResultResponse.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/21/24.
//

import Foundation

struct SearchResultResponse: Codable {
    let albums: SearchAlbumResponse
    let artists: SearchArtistsResponse
    let tracks: SearchTracksResponse
}

struct SearchAlbumResponse: Codable {
    let items: [Album]
}

struct SearchArtistsResponse: Codable {
    let items: [Artist]
}

struct SearchTracksResponse: Codable {
    let items: [AudioTrack]
}

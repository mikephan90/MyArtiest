//
//  NewReleaseResponse.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/13/24.
//

import Foundation

struct NewAlbumReleasesResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}

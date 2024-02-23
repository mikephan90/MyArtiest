//
//  Album.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/13/24.
//

import Foundation

struct Album: Codable {
    let album_type: String
    let total_tracks: Int
    let external_urls: [String:String]
    let id: String
    var images: [APIImage]
    let name: String
    let release_date: String
    let artists: [Artist]
}

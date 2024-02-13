//
//  Artist.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/13/24.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String:String]
    let images: [APIImage]?
}
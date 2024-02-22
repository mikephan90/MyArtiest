//
//  SearchResult.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/21/24.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
}

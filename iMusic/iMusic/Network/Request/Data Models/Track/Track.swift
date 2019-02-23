//
//  Track.swift
//  iMusic
//
//  Created by Ricardo Casanova on 23/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import Foundation

public struct TracksResponse: Decodable {
    
    let resultCount: UInt
    let results: [TrackResponse]
    
}

public struct TrackResponse: Decodable {
    
    let artistName: String
    let trackName: String
    let trackViewUrl: String
    let previewUrl: String?
    let artworkUrl100: String
    let releaseDate: String
    let primaryGenreName: String
    let trackPrice: Float?
    let trackTimeMillis: Int
    
}

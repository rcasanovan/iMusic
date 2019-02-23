//
//  TrackViewModel.swift
//  iMusic
//
//  Created by Ricardo Casanova on 23/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import Foundation

struct TrackViewModel {
    
    let artistName: String
    let trackName: String
    let artworkUrl: URL?
    let releaseDate: String
    let releaseYear: String
    let previewUrl: URL?
    let primaryGenreName: String
    let trackViewUrl: URL?
    let trackDuration: String
    let trackPrice: String?
    let collectionName: String
    
    init(artistName: String, trackName: String, artworkUrl: URL?, releaseDate: String, releaseYear: String, previewUrl: URL?, primaryGenreName: String, trackViewUrl: URL?, trackDuration: String, trackPrice: String?, collectionName: String) {
        self.artistName = artistName
        self.trackName = trackName
        self.artworkUrl = artworkUrl
        self.releaseDate = releaseDate
        self.releaseYear = releaseYear
        self.previewUrl = previewUrl
        self.primaryGenreName = primaryGenreName
        self.trackViewUrl = trackViewUrl
        self.trackDuration = trackDuration
        self.trackPrice = trackPrice
        self.collectionName = collectionName
    }
    
}

extension TrackViewModel {
    
    /**
     * Get the view models (array) from the tracks response array
     *
     * - parameters:
     *      -artistResponse: the tracks response array
     */
    public static func getViewModelsWith(_ artistResponse: [TrackResponse]) -> [TrackViewModel] {
        return artistResponse.map { getViewModelWith($0) }
    }
    
    /**
     * Get the view model (single view model) from the track response
     *
     * - parameters:
     *      -artistResponse: the track response
     */
    private static func getViewModelWith(_ artistResponse: TrackResponse) -> TrackViewModel {
        let artworkUrl = TrackManager.shared.getExtraLargeUrlWith(URL(string: artistResponse.artworkUrl100), type: .large)
        var releaseYear = ""
        var date = ""
        if let releaseDate = Date.getISODateWithString(artistResponse.releaseDate) {
            releaseYear = releaseDate.getStringyyyyFormat()
            date = releaseDate.getStringMMMddyyyyFormat()
        }
        
        var previewUrl: URL?
        if let url = artistResponse.previewUrl {
            previewUrl = URL(string: url)
        }
        
        let trackViewUrl = URL(string: artistResponse.trackViewUrl)
        
        let trackDuration = TrackManager.shared.getTrackTimemmssFormatWith(trackTimeMillis: artistResponse.trackTimeMillis)
        
        var trackPrice: String?
        if let price = artistResponse.trackPrice {
            trackPrice = "\(price) \(artistResponse.currency)"
        }
        
        return TrackViewModel(artistName: artistResponse.artistName, trackName: artistResponse.trackName, artworkUrl: artworkUrl, releaseDate: date, releaseYear: releaseYear, previewUrl: previewUrl, primaryGenreName: artistResponse.primaryGenreName, trackViewUrl: trackViewUrl, trackDuration: trackDuration, trackPrice: trackPrice, collectionName: artistResponse.collectionName)
    }
    
}


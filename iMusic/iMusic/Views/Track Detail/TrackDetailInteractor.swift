//
//  TrackDetailInteractor.swift
//  iMusic
//
//  Created by Ricardo Casanova on 24/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import Foundation

class TrackDetailInteractor {
    
    private var track: TrackViewModel?
    private var allTracks: [TrackViewModel]?
    
    init(track: TrackViewModel, allTracks: [TrackViewModel]) {
        self.track = track
        self.allTracks = allTracks
        PlayerManager.shared.prepare(with: track.previewUrl)
    }
    
}

// MARK: - TrackDetailInteractorDelegate
extension TrackDetailInteractor: TrackDetailInteractorDelegate {
    
    func playTrack() {
        PlayerManager.shared.play()
    }
    
    func pauseTrack() {
        PlayerManager.shared.pause()
    }
    
    func nextTrack() {
        PlayerManager.shared.pause()
    }
    
    func prevTrack() {
        PlayerManager.shared.pause()
    }
    
    func getCurrentTrack() -> TrackViewModel? {
        return track
    }
    
}

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
    private var allTracks: [TrackViewModel]
    
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
        guard let track = track else { return }
        
        let currentTrackIndex = allTracks.index{ $0.trackId == track.trackId }
        guard let index = currentTrackIndex else { return }
        
        let nextTrackIndex = index + 1
        if !allTracks.indices.contains(nextTrackIndex) { return }
        
        self.track = allTracks[nextTrackIndex]
        PlayerManager.shared.prepare(with: self.track?.previewUrl)
        PlayerManager.shared.play()
    }
    
    func prevTrack() {
        guard let track = track else { return }
        
        let currentTrackIndex = allTracks.index{ $0.trackId == track.trackId }
        guard let index = currentTrackIndex else { return }
        
        let prevTrackIndex = index - 1
        if !allTracks.indices.contains(prevTrackIndex) { return }
        
        self.track = allTracks[prevTrackIndex]
        PlayerManager.shared.prepare(with: self.track?.previewUrl)
        PlayerManager.shared.play()
    }
    
    func getCurrentTrack() -> TrackViewModel? {
        return track
    }
    
}

//
//  TrackDetailPresenter.swift
//  iMusic
//
//  Created by Ricardo Casanova on 24/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import Foundation

class TrackDetailPresenter {
    
    private weak var view: TrackDetailViewInjection?
    private let track: TrackViewModel
    private let interactor: TrackDetailInteractorDelegate
    private let router: TrackDetailRouterDelegate
   
    // MARK - Lifecycle
    init(view: TrackDetailViewInjection, track: TrackViewModel, navigationController: UINavigationController? = nil) {
        self.view = view
        self.track = track
        self.interactor = TrackDetailInteractor(track: track)
        self.router = TrackDetailRouter(navigationController: navigationController)
    }
    
}

// MARK: - PlayerManagerDelegate
extension TrackDetailPresenter: PlayerManagerDelegate {
    
    func didFinishPlaying() {
        print("didFinishPlaying")
    }
    
    func currentTime(_ seconds: Int) {
        view?.loadCurrentTime(seconds)
    }
    
    func totalSecondsDuration(_ seconds: Double) {
        view?.loadTotalDuration(seconds)
    }
    
}

// MARK: - TrackDetailPresenterDelegate
extension TrackDetailPresenter: TrackDetailPresenterDelegate {
    
    func viewDidLoad() {
        PlayerManager.shared.delegate = self
        view?.loadTrack(track)
    }
    
    func playPressed() {
        interactor.playTrack()
    }
    
    func pausePressed() {
        interactor.pauseTrack()
    }
    
    func nextPressed() {
        interactor.nextTrack()
    }
    
    func prevPressed() {
        interactor.prevTrack()
    }
    
    func sharePressed() {
        guard let view = view as? UIViewController, let currentTrack = interactor.getCurrentTrack() else {
            return
        }
        var items: [Any] = ["Hey! I'm listening \(currentTrack.trackName) by \(currentTrack.artistName) using the iTunes API"]
        
        if let previewUrl = currentTrack.previewUrl {
            items.append("\(previewUrl.absoluteString)")
        }
        
        ShareManager.shared.share(items, from: view)
    }
    
}

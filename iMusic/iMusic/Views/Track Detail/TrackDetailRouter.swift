//
//  TrackDetailRouter.swift
//  iMusic
//
//  Created by Ricardo Casanova on 24/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import Foundation
import SafariServices

class TrackDetailRouter {
    
    private weak var navigationController: UINavigationController?
    
    // MARK - Lifecycle
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    /**
     * Setup the initial module
     */
    public static func setupModuleWithCurrentTrack(_ track: TrackViewModel, allTracks: [TrackViewModel], navigationController: UINavigationController?) -> TrackDetailViewController {
        let trackDetailVC = TrackDetailViewController()
        trackDetailVC.presenter = TrackDetailPresenter(view: trackDetailVC, track: track, allTracks: allTracks, navigationController: navigationController)
        return trackDetailVC
    }
    
}

// MARK: - TrackDetailRouterDelegate
extension TrackDetailRouter: TrackDetailRouterDelegate {
    
    /**
     * Show track in Music
     * NOTE: this feature is working ONLY in a real device
     *
     * - parameters:
     *      -url: url to open the track in Music app
     */
    func showTrackInMusicWithUrl(_ url: URL) {
        let safariVC = SFSafariViewController(url: url)
        navigationController?.present(safariVC, animated: true, completion: nil)
    }
    
}

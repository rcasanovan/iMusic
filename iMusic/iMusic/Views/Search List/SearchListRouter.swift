//
//  SearchListRouter.swift
//  iMusic
//
//  Created by Ricardo Casanova on 23/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import Foundation

class SearchListRouter {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    /**
     * Setup the initial module
     */
    public static func setupModule() -> UINavigationController {
        let searchListVC = SearchListViewController()
        let searchListNVC = UINavigationController(rootViewController: searchListVC)
        searchListVC.presenter = SearchListPresenter(view: searchListVC, navigationController: searchListNVC)
        return searchListNVC
    }
    
}

// MARK: - SearchListRouterDelegate
extension SearchListRouter: SearchListRouterDelegate {
    
    func showTrackDetail(_ track: TrackViewModel, allTracks: [TrackViewModel]) {
        let trackDetailVC = TrackDetailRouter.setupModuleWithCurrentTrack(track, allTracks: allTracks, navigationController:  navigationController)
        navigationController?.pushViewController(trackDetailVC, animated: true)
    }
    
}

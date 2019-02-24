//
//  SearchListPresenter.swift
//  iMusic
//
//  Created by Ricardo Casanova on 23/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import Foundation

class SearchListPresenter {
    
    private weak var view: SearchListViewInjection?
    private let interactor: SearchListInteractorDelegate
    private let router: SearchListRouterDelegate
    private var sortType: SortType
    
    // MARK - Lifecycle
    init(view: SearchListViewInjection, navigationController: UINavigationController? = nil) {
        self.sortType = .artistName
        self.view = view
        self.interactor = SearchListInteractor()
        self.router = SearchListRouter(navigationController: navigationController)
    }
    
}

// MARK: - Private section
extension SearchListPresenter {
    
    /**
     * Get tracks
     *
     * - parameters:
     *      -search: the search term
     *      -showProgress: a boolean to show / hide the progress
     */
    private func getTracks(_ search: String? = nil, showProgress: Bool) {
        view?.showProgress(showProgress, status: "Loading artists")
        
        interactor.getTracksList(search: search) { [weak self] (artists, success, error) in
            guard let `self` = self else { return }
            
            self.view?.showProgress(false)
            
            if let artists = artists {
                self.view?.loadTracks(artists, fromBeginning: showProgress, sortType: self.sortType)
                return
            }
            
            if let error = error {
                self.view?.showMessageWith(title: "Oops... 🧐", message: error.localizedDescription, actionTitle: "Accept")
                return
            }
            
            if !success {
                self.view?.showMessageWith(title: "Oops... 🧐", message: "Something wrong happened. Please try again", actionTitle: "Accept")
                return
            }
        }
    }
    
}

// MARK: - SearchListPresenterDelegate
extension SearchListPresenter: SearchListPresenterDelegate {
    
    /**
     * View did load
     */
    func viewDidLoad() {
        interactor.clear()
        let initialSearch = interactor.getInitialSearch()
        getTracks(initialSearch, showProgress: true)
    }
    
    /**
     * Search track
     *
     * - parameters:
     *      -search: the search term
     */
    func searchTrack(_ search: String?) {
        interactor.clear()
        sortType = .artistName
        getTracks(search, showProgress: true)
    }
    
    /**
     * Track selected at section / index
     */
    func trackSelectedAt(section: Int, index: Int) {
        guard let trackSelected = interactor.getTrackSelectedAt(section: section, index: index) else {
            return
        }
        
        router.showTrackDetail(trackSelected, allTracks: [TrackViewModel]())
    }
    
    /**
     * Get all suggestions
     */
    func getSuggestions() {
        interactor.getAllSuggestions { [weak self] (suggestions) in
            guard let `self` = self else { return }
            self.view?.loadSuggestions(suggestions)
        }
    }
    
    /**
     * Suggestion selected at index
     *
     * - parameters:
     *      -index: selected index
     */
    func suggestionSelectedAt(_ index: Int) {
        guard let suggestion = interactor.getSuggestionAt(index: index) else {
            return
        }
        searchTrack(suggestion.suggestion)
    }
    
    func sortTracksBy(_ type: SortType) {
        sortType = type
        let localTracks = interactor.getLocalTracks()
        view?.loadTracks(localTracks, fromBeginning: true, sortType: type)
    }
    
}

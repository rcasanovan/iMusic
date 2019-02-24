//
//  SearchListProtocols.swift
//  iMusic
//
//  Created by Ricardo Casanova on 23/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import Foundation

// View / Presenter
protocol SearchListViewInjection : class {
    func showProgress(_ show: Bool, status: String)
    func showProgress(_ show: Bool)
    func showMessageWith(title: String, message: String, actionTitle: String)
    func loadTracks(_ viewModels: [TrackViewModel], fromBeginning: Bool, sortType: SortType)
    func loadSuggestions(_ suggestions: [SuggestionViewModel])
}

protocol SearchListPresenterDelegate : class {
    func viewDidLoad()
    func searchTrack(_ search: String?)
    func trackSelectedAt(section: Int, index: Int)
    func getSuggestions()
    func suggestionSelectedAt(_ index: Int)
    func sortTracksBy(_ type: SortType)
}

// Presenter / Interactor

typealias TracksGetTracksCompletionBlock = (_ viewModel: [TrackViewModel]?, _ success: Bool, _ error: ResultError?) -> Void
typealias TrackListGetSuggestionsCompletionBlock = ([SuggestionViewModel]) -> Void

protocol SearchListInteractorDelegate : class {
    func getTracksList(search: String?, completion: @escaping TracksGetTracksCompletionBlock)
    func clear()
    func getTrackSelectedAt(section: Int, index: Int) -> TrackViewModel?
    func getAllSuggestions(completion: @escaping TrackListGetSuggestionsCompletionBlock)
    func getSuggestionAt(index: Int) -> SuggestionViewModel?
    func getInitialSearch() -> String
    func getLocalTracks() -> [TrackViewModel]
}

// Presenter / Router
protocol SearchListRouterDelegate : class {
}

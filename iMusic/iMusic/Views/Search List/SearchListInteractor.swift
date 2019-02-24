//
//  SearchListInteractor.swift
//  iMusic
//
//  Created by Ricardo Casanova on 23/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import Foundation

typealias getArtistsCompletionBlock = (Result<TracksResponse?>) -> Void

class SearchListInteractor {
    
    private let requestManager: RequestManager
    private var tracksViewModel: [TrackViewModel]
    private var suggestions: [SuggestionViewModel]
    
    // MARK - Lifecycle
    convenience init() {
        self.init(requestManager: RequestManager(), tracksViewModel: [TrackViewModel](), suggestions: [SuggestionViewModel]())
    }
    
    init(requestManager: RequestManager, tracksViewModel: [TrackViewModel], suggestions: [SuggestionViewModel]) {
        self.requestManager = requestManager
        self.tracksViewModel = tracksViewModel
        self.suggestions = suggestions
    }
    
}

// MARK: - Private section
extension SearchListInteractor {
    
    /**
     * Get tracks
     *
     * - parameters:
     *      -search: the search term for tracks
     *      -simulatedJSONFile: boolean to determinate if we need to load the info using a local json file
     *      -completion: completion block
     */
    private func getTracks(search: String? = nil, simulatedJSONFile: String? = nil, completion: @escaping getArtistsCompletionBlock) {
        var tracksRequest = TracksRequest(search: search)
        
        tracksRequest.completion = completion
        tracksRequest.simulatedResponseJSONFile = simulatedJSONFile
        requestManager.send(request: tracksRequest)
    }
    
    /**
     * Update tracks results
     *
     * - parameters:
     *      -tracks: tracks array with the response
     */
    private func updateTracksWith(_ tracks: [TrackResponse]) {
        let tracksViewModel = TrackViewModel.getViewModelsWith(tracks)
        self.tracksViewModel.append(contentsOf: tracksViewModel)
    }
    
    /**
     * Save search (in order to add a new suggestion)
     *
     * - parameters:
     *      -search: the search term
     */
    private func saveSearch(_ search: String?) {
        guard let search = search else { return }
        SearchSuggestionsManager.shared.saveSuggestion(search)
    }
    
    /**
     * Get random search (for the first app running)
     */
    private func getRandomSearch() -> String {
        let searchArray = ["The Beatles", "Oasis", "Blur", "The Verve"]
        guard let randomSearch = searchArray.randomElement() else {
            return "The Beatles"
        }
        
        return randomSearch
    }
    
}

// MARK: - SearchListInteractorDelegate
extension SearchListInteractor: SearchListInteractorDelegate {
    
    /**
     * Get tracks list
     *
     * - parameters:
     *      -search: the search term for tracks
     *      -completion: completion block
     */
    func getTracksList(search: String?, completion: @escaping TracksGetTracksCompletionBlock) {
        getTracks(search: search) { [weak self] (response) in
            guard let `self` = self else { return }
            
            switch response {
            case .success(let response):
                guard let response = response else {
                    completion(nil, false, nil)
                    return
                }
                
                self.updateTracksWith(response.results)
                if !response.results.isEmpty {
                    self.saveSearch(search)
                }
                completion(self.tracksViewModel, true, nil)
            case .failure(let error):
                completion(nil, false, error)
            }
        }
    }
    
    /**
     * Clear current tracks information (reset)
     */
    func clear() {
        tracksViewModel = []
    }
    
    /**
     * Get track view model selected at section / index
     *
     * - parameters:
     *      -section: the selected section
     *      -index: the selected index
     */
    func getTrackSelectedAt(section: Int, index: Int) -> TrackViewModel? {
        let dictionary = Dictionary(grouping: tracksViewModel, by: { $0.artistName })
        let keysArray = Array(dictionary.keys).sorted(by: { $0 < $1 })
        
        guard let tracks = dictionary[keysArray[section]] else {
            return nil
        }
        
        if !tracks.indices.contains(index) { return nil }
        
        return tracks[index]
    }
    
    /**
     * Get all suggestions
     *
     * - parameters:
     *      -completion: the completion block
     */
    func getAllSuggestions(completion: @escaping TrackListGetSuggestionsCompletionBlock) {
        let allSuggestions = SearchSuggestionsManager.shared.getSuggestions()
        suggestions = SuggestionViewModel.getViewModelsWith(suggestions: allSuggestions)
        completion(suggestions)
    }
    
    /**
     * Get suggestion view model at index
     *
     * - parameters:
     *      -index: the selected index
     */
    func getSuggestionAt(index: Int) -> SuggestionViewModel? {
        if !suggestions.indices.contains(index) { return nil }
        
        return suggestions[index]
    }
    
    /**
     * Get the initial search term (for the initial app running)
     */
    func getInitialSearch() -> String {
        //__ if we don't have suggestions -> get a random search term
        guard let lastSuggestion = SearchSuggestionsManager.shared.getLastSuggestion() else {
            return getRandomSearch()
        }
        
        //__ otherwise -> get the mos recent search term
        return lastSuggestion.suggestion
    }
    
    func getLocalTracks() -> [TrackViewModel] {
        return tracksViewModel
    }
    
    func getPlayListSortedBy(_ sortType: SortType) -> [TrackViewModel]? {
        
        var dictionary: Dictionary<String, [TrackViewModel]>
        var tracks: [TrackViewModel]
        
        switch sortType {
        case .artistName:
            dictionary = Dictionary(grouping: tracksViewModel, by: { $0.artistName })
            tracks = dictionary.map{ $0.value }.flatMap{ $0 }.sorted(by: { $0.artistName < $1.artistName })
        case .genre:
            dictionary = Dictionary(grouping: tracksViewModel, by: { $0.primaryGenreName })
            tracks = dictionary.map{ $0.value }.flatMap{ $0 }.sorted(by: { $0.primaryGenreName < $1.primaryGenreName })
        case .length:
            dictionary = Dictionary(grouping: tracksViewModel, by: { $0.trackDuration })
            tracks = dictionary.map{ $0.value }.flatMap{ $0 }.sorted(by: { $0.trackDuration < $1.trackDuration })
        case .price:
            dictionary = Dictionary(grouping: tracksViewModel, by: { $0.trackPrice ?? "" })
            tracks = dictionary.map{ $0.value }.flatMap{ $0 }.sorted(by: { $0.trackPrice ?? "" < $1.trackPrice ?? "" })
        }
        
        return tracks
    }
    
}

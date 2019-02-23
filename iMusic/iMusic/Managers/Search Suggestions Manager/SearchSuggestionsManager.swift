//
//  SearchSuggestionsManager.swift
//  iMusic
//
//  Created by Ricardo Casanova on 23/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import Foundation
import RealmSwift

class SearchSuggestionsManager {
    
    static let shared: SearchSuggestionsManager = { return SearchSuggestionsManager() }()
    
    /**
     * Save suggestion
     *
     * - parameters:
     *      -suggestion: suggestion to save
     */
    public func saveSuggestion(_ suggestion: String) {
        if suggestionExists(suggestion) { return }
        
        // Create a suggestion object
        let suggestionModel = SearchSuggestion()
        suggestionModel.suggestionId = UUID().uuidString
        suggestionModel.suggestion = suggestion.lowercased()
        suggestionModel.timestamp = NSDate().timeIntervalSince1970
        
        // Get the default Realm
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(suggestionModel)
        }
        
        //Remove older suggestions
        removeOlderSuggestions()
    }
    
    /**
     * Get all suggestions
     */
    public func getSuggestions() -> [SearchSuggestion] {
        // Get the default Realm
        let realm = try! Realm()
        
        // Query Realm for all suggestions
        // Order criteria -> timestamp
        // Order -> descending
        let suggestions = realm.objects(SearchSuggestion.self).sorted(byKeyPath: "timestamp", ascending: false)
        return Array(suggestions)//suggestions.toArray(ofType: SearchSuggestion.self)
    }
    
    /**
     * Get last suggestion
     */
    public func getLastSuggestion() -> SearchSuggestion? {
        let suggestions = getSuggestions()
        
        if suggestions.isEmpty { return nil }
        
        return suggestions.first
    }
    
    /**
     * Delete all suggestions
     */
    public func deleteAllSuggestions() {
        let realm = try! Realm()
        let suggestions = realm.objects(SearchSuggestion.self)
        
        try! realm.write {
            realm.delete(suggestions)
        }
    }
    
    /**
     * Validate if suggestion exists in the database
     *
     * - parameters:
     *      -suggestion: suggestion to check
     */
    public func suggestionExists(_ suggestion: String) -> Bool {
        let realm = try! Realm()
        let suggestions = realm.objects(SearchSuggestion.self).filter("suggestion == %@", suggestion.lowercased())
        return suggestions.count == 1
    }
    
}

// MARK: - Private section
extension SearchSuggestionsManager {
    
    /**
     * Remove older suggestions
     */
    private func removeOlderSuggestions() {
        let realm = try! Realm()
        // Get all suggestions
        let allSuggestions = getSuggestions()
        // Get the firt 10 suggestions
        let firstSuggestions = Array(allSuggestions.prefix(10))
        // Get the suggestions ids
        let suggestionIds = firstSuggestions.map { $0.suggestionId }
        
        // Query all objects where the id in not included
        let objectsToDelete = realm.objects(SearchSuggestion.self).filter("NOT suggestionId IN %@", suggestionIds)
        
        try! realm.write {
            // And then just remove the set with
            realm.delete(objectsToDelete)
        }
    }
    
}

//
//  SuggestionViewModel.swift
//  iMusic
//
//  Created by Ricardo Casanova on 23/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import Foundation

struct SuggestionViewModel {
    
    let suggestion: String
    
    init(suggestion: String) {
        self.suggestion = suggestion
    }
    
    /**
     * Get the view models with a SearchSuggestion array
     */
    public static func getViewModelsWith(suggestions: [SearchSuggestion]) -> [SuggestionViewModel] {
        return suggestions.map { getViewModelWith(suggestion: $0) }
    }
    
    /**
     * Get a single view model with a SearchSuggestion
     */
    public static func getViewModelWith(suggestion: SearchSuggestion) -> SuggestionViewModel {
        return SuggestionViewModel.init(suggestion: suggestion.suggestion)
    }
    
}


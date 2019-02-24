//
//  TrackDetailProtocols.swift
//  iMusic
//
//  Created by Ricardo Casanova on 24/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import Foundation

// View / Presenter
protocol TrackDetailViewInjection : class {
    func loadTrack(_ track: TrackViewModel)
}

protocol TrackDetailPresenterDelegate : class {
}

// Presenter / Interactor
protocol TrackDetailInteractorDelegate : class {
}

// Presenter / Router
protocol TrackDetailRouterDelegate : class {
}

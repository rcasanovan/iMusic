//
//  TrackDetailViewController.swift
//  iMusic
//
//  Created by Ricardo Casanova on 24/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import Foundation

class TrackDetailViewController: BaseViewController {
    
    public var presenter: TrackDetailPresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

// MARK: - Setup views
extension TrackDetailViewController {
    
    /**
     * Setup views
     */
    private func setupViews() {
        view.backgroundColor = .black()
        edgesForExtendedLayout = []
        
        configureSubviews()
        addSubviews()
    }
    
    /**
     * Configure subviews
     */
    private func configureSubviews() {
    }
    
}

// MARK: - Layout & constraints
extension TrackDetailViewController {
    
    /**
     * Add subviews
     */
    private func addSubviews() {
    }
    
}

// MARK: - TrackDetailViewInjection
extension TrackDetailViewController: TrackDetailViewInjection {
    
    func loadTrack(_ track: TrackViewModel) {
    }
    
}

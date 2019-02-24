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
    
    private let artworkImageView: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter?.viewDidLoad()
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
        artworkImageView.frame = CGRect(x: 0.0, y: 0.0, width: 250.0, height: 250.0)
    }
    
}

// MARK: - Layout & constraints
extension TrackDetailViewController {
    
    /**
     * Add subviews
     */
    private func addSubviews() {
        view.addSubview(artworkImageView)
        
        view.addConstraintsWithFormat("H:[v0(250.0)]", views: artworkImageView)
        view.addConstraintsWithFormat("V:|-10.0-[v0(250.0)]", views: artworkImageView)
        let artworkImageViewCenterY = NSLayoutConstraint(item: artworkImageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        view.addConstraint(artworkImageViewCenterY)
    }
    
}

// MARK: - Private section
extension TrackDetailViewController {
    
    private func configureArtWorkWithUrl(_ url: URL?) {
        guard let url = url else {
            return
        }
        artworkImageView.hnk_setImage(from: url, placeholder: nil)
    }
    
}

// MARK: - TrackDetailViewInjection
extension TrackDetailViewController: TrackDetailViewInjection {
    
    func loadTrack(_ track: TrackViewModel) {
        configureArtWorkWithUrl(track.artworkUrl)
    }
    
}

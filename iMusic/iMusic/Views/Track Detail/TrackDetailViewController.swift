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
    private let trackNameLabel: UILabel = UILabel()
    private let artistNameLabel: UILabel = UILabel()
    private let trackDuration: PlayerTrackDuration = PlayerTrackDuration()
    private let playerControls: PlayerControls = PlayerControls()
    
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
        
        trackNameLabel.font = UIFont.mediumWithSize(size: 18.0)
        trackNameLabel.textColor = .white()
        trackNameLabel.textAlignment = .center
        
        artistNameLabel.font = UIFont.mediumWithSize(size: 16.0)
        artistNameLabel.textColor = .lightGray
        artistNameLabel.textAlignment = .center
        
        playerControls.delegate = self
    }
    
}

// MARK: - Layout & constraints
extension TrackDetailViewController {
    
    /**
     * Add subviews
     */
    private func addSubviews() {
        view.addSubview(artworkImageView)
        view.addSubview(trackNameLabel)
        view.addSubview(artistNameLabel)
        view.addSubview(trackDuration)
        view.addSubview(playerControls)
        
        view.addConstraintsWithFormat("H:[v0(250.0)]", views: artworkImageView)
        view.addConstraintsWithFormat("V:|-10.0-[v0(250.0)]", views: artworkImageView)
        let artworkImageViewCenterX = NSLayoutConstraint(item: artworkImageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        view.addConstraint(artworkImageViewCenterX)
        
        view.addConstraintsWithFormat("H:|-16.0-[v0]-16.0-|", views: trackNameLabel)
        view.addConstraintsWithFormat("V:[v0]-10.0-[v1(21.0)]", views: artworkImageView, trackNameLabel)
        
        view.addConstraintsWithFormat("H:|-16.0-[v0]-16.0-|", views: artistNameLabel)
        view.addConstraintsWithFormat("V:[v0]-10.0-[v1(21.0)]", views: trackNameLabel, artistNameLabel)
        
        view.addConstraintsWithFormat("H:[v0(\(trackDuration.width))]", views: trackDuration)
        view.addConstraintsWithFormat("V:[v0]-10.0-[v1(\(trackDuration.height))]", views: artistNameLabel, trackDuration)
        let trackDurationCenterX = NSLayoutConstraint(item: trackDuration, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        view.addConstraint(trackDurationCenterX)
        
        view.addConstraintsWithFormat("H:[v0(\(playerControls.width))]", views: playerControls)
        view.addConstraintsWithFormat("V:[v0]-10.0-[v1(\(playerControls.height))]", views: trackDuration, playerControls)
        let playerControlsCenterX = NSLayoutConstraint(item: playerControls, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        view.addConstraint(playerControlsCenterX)
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

// MARK: - PlayerControlsDelegate
extension TrackDetailViewController: PlayerControlsDelegate {
    
    func playPressed() {
        presenter?.playPressed()
    }
    
    func pausePressed() {
        presenter?.pausePressed()
    }
    
    func nextPressed() {
        presenter?.nextPressed()
    }
    
    func prevPressed() {
        presenter?.prevPressed()
    }
    
}

// MARK: - TrackDetailViewInjection
extension TrackDetailViewController: TrackDetailViewInjection {
    
    func loadTrack(_ track: TrackViewModel) {
        configureArtWorkWithUrl(track.artworkUrl)
        trackNameLabel.text = track.trackName
        artistNameLabel.text = track.artistName
    }
    
}

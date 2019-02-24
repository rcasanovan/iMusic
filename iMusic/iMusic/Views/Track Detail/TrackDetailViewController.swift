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
    
    private let shareView: ShareView = ShareView()
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.viewDidDisappear()
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
        shareView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareView)
        
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
     * Internal struct for layout
     */
    private struct Layout {
        
        struct ArtworkImageView {
            static let height: CGFloat = 250.0
            static let width: CGFloat = 250.0
            static let top: CGFloat = 10.0
        }
        
        struct TrackNameLabel {
            static let leading: CGFloat = 16.0
            static let trailing: CGFloat = 16.0
            static let top: CGFloat = 10.0
            static let height: CGFloat = 21.0
        }
        
        struct ArtistNameLabel {
            static let leading: CGFloat = 16.0
            static let trailing: CGFloat = 16.0
            static let top: CGFloat = 10.0
            static let height: CGFloat = 21.0
        }
        
        struct TrackDuration {
            static let top: CGFloat = 10.0
        }
        
        struct PlayerControls {
            static let top: CGFloat = 10.0
        }
        
    }
    
    /**
     * Add subviews
     */
    private func addSubviews() {
        view.addSubview(artworkImageView)
        view.addSubview(trackNameLabel)
        view.addSubview(artistNameLabel)
        view.addSubview(trackDuration)
        view.addSubview(playerControls)
        
        view.addConstraintsWithFormat("H:[v0(\(Layout.ArtworkImageView.width))]", views: artworkImageView)
        view.addConstraintsWithFormat("V:|-\(Layout.ArtworkImageView.top)-[v0(\(Layout.ArtworkImageView.height))]", views: artworkImageView)
        let artworkImageViewCenterX = NSLayoutConstraint(item: artworkImageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        view.addConstraint(artworkImageViewCenterX)
        
        view.addConstraintsWithFormat("H:|-\(Layout.TrackNameLabel.leading)-[v0]-\(Layout.TrackNameLabel.trailing)-|", views: trackNameLabel)
        view.addConstraintsWithFormat("V:[v0]-\(Layout.TrackNameLabel.top)-[v1(\(Layout.TrackNameLabel.height))]", views: artworkImageView, trackNameLabel)
        
        view.addConstraintsWithFormat("H:|-\(Layout.ArtistNameLabel.leading)-[v0]-\(Layout.ArtistNameLabel.trailing)-|", views: artistNameLabel)
        view.addConstraintsWithFormat("V:[v0]-\(Layout.ArtistNameLabel.top)-[v1(\(Layout.ArtistNameLabel.height))]", views: trackNameLabel, artistNameLabel)
        
        view.addConstraintsWithFormat("H:[v0(\(trackDuration.width))]", views: trackDuration)
        view.addConstraintsWithFormat("V:[v0]-\(Layout.TrackDuration.top)-[v1(\(trackDuration.height))]", views: artistNameLabel, trackDuration)
        let trackDurationCenterX = NSLayoutConstraint(item: trackDuration, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        view.addConstraint(trackDurationCenterX)
        
        view.addConstraintsWithFormat("H:[v0(\(playerControls.width))]", views: playerControls)
        view.addConstraintsWithFormat("V:[v0]-\(Layout.PlayerControls.top)-[v1(\(playerControls.height))]", views: trackDuration, playerControls)
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

// MARK: - ShareViewDelegate
extension TrackDetailViewController: ShareViewDelegate {
    
    func shareViewPressed() {
        presenter?.sharePressed()
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
    
    /**
     * Load track
     *
     * - parameters:
     *      -track: track view model to load
     */
    func loadTrack(_ track: TrackViewModel) {
        configureArtWorkWithUrl(track.artworkUrl)
        trackNameLabel.text = track.trackName
        artistNameLabel.text = track.artistName
    }
    
    /**
     * Load total duration track
     *
     * - parameters:
     *      -totalDuration: the total duration track
     */
    func loadTotalDuration(_ totalDuration: Double) {
        trackDuration.total = totalDuration
    }
    
    /**
     * Load current time track
     *
     * - parameters:
     *      -currentTime: the current time track
     */
    func loadCurrentTime(_ currentTime: Int) {
        trackDuration.current = currentTime
    }
    
}

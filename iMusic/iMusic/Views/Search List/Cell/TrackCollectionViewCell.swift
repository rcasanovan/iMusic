//
//  TrackCollectionViewCell.swift
//  iMusic
//
//  Created by Ricardo Casanova on 23/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import UIKit

class TrackCollectionViewCell: UICollectionViewCell {
    
    private let trackImageView: UIImageView = UIImageView()
    private let trackNameLabel: UILabel = UILabel()
    private let releaseDateLabel: UILabel = UILabel()
    private let trackInformationLabel: UILabel = UILabel()
    
    /**
     * Identifier for reusable cells
     */
    static public var identifier : String {
        return String(describing: self)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImageView.image = nil
        trackNameLabel.text = ""
        releaseDateLabel.text = ""
    }
    
    static func getHeight(for width: CGFloat) -> CGFloat {
        return (width * Layout.ratio.height) / Layout.ratio.width
    }
    
    /**
     * Bind component
     *
     * - parameters:
     *      -viewModel: TrackViewModel
     */
    public func bindWithViewModel(_ viewModel: TrackViewModel) {
        configureArtWorkWithUrl(viewModel.artworkUrl)
        trackNameLabel.text = viewModel.trackName
        releaseDateLabel.text = viewModel.releaseYear
        trackInformationLabel.text = "\(viewModel.trackDuration) - 1.99 €"
    }
    
}

extension TrackCollectionViewCell {
    
    private func configureArtWorkWithUrl(_ url: URL?) {
        guard let url = url else {
            return
        }
        trackImageView.hnk_setImage(from: url, placeholder: nil)
    }
    
}

// MARK:- Layout & Constraints
extension TrackCollectionViewCell {
    
    /**
     * Private struct for internal layout
     */
    private struct Layout {
        
        struct ratio {
            static let width: CGFloat = 100.0
            static let height: CGFloat = 140.0
        }
        
    }
    
    /**
     * Common init method to setup all the components
     */
    private func setupViews() {
        configureSubviews()
        addSubviews()
    }
    
    /**
     * Configure the elements inside the component
     */
    private func configureSubviews() {
        backgroundColor = .clear
        
        trackImageView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        trackImageView.backgroundColor = .clear
        trackImageView.contentMode = .scaleAspectFill
        trackImageView.layer.cornerRadius = 8.0
        trackImageView.clipsToBounds = true
        
        trackNameLabel.font = UIFont.mediumWithSize(size: 14.0)
        trackNameLabel.textColor = .white()
        
        releaseDateLabel.font = UIFont.mediumWithSize(size: 14.0)
        releaseDateLabel.textColor = .white()
        
        trackInformationLabel.font = UIFont.mediumWithSize(size: 14.0)
        trackInformationLabel.textColor = .white()
    }
    
    /**
     * Add subviews
     */
    private func addSubviews() {
        addSubview(trackImageView)
        addSubview(trackNameLabel)
        addSubview(releaseDateLabel)
        addSubview(trackInformationLabel)
        
        addConstraintsWithFormat("H:|[v0]|", views: trackImageView)
        addConstraintsWithFormat("V:|[v0]-10.0-[v1]", views: trackImageView, trackNameLabel)
        
        addConstraintsWithFormat("H:|[v0]|", views: trackNameLabel)
        addConstraintsWithFormat("V:[v0(16.0)]-5.0-[v1]", views: trackNameLabel, releaseDateLabel)
        
        addConstraintsWithFormat("H:|[v0]|", views: releaseDateLabel)
        addConstraintsWithFormat("V:[v0(16.0)]-5.0-[v1]", views: releaseDateLabel, trackInformationLabel)
        
        addConstraintsWithFormat("H:|[v0]|", views: trackInformationLabel)
        addConstraintsWithFormat("V:[v0(16.0)]|", views: trackInformationLabel)
    }
    
}



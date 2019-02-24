//
//  PlayerControls.swift
//  iMusic
//
//  Created by Ricardo Casanova on 24/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import UIKit

class PlayerControls: UIView {
    
    private let playButton: UIButton = UIButton(type: .custom)
    private let prevButton: UIButton = UIButton(type: .custom)
    private let nextButton: UIButton = UIButton(type: .custom)
    
    /**
     * Get component's height
     */
    public var height: CGFloat {
        return Layout.height
    }
    
    /**
     * Get component's width
     */
    public var width: CGFloat {
        return Layout.width
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
}

// MARK: - Setup views
extension PlayerControls {
    
    private func setupViews() {
        backgroundColor = .clear
        
        configureSubviews()
        addSubviews()
    }
    
    private func configureSubviews() {
        let playImage = UIImage(named: "Play")?.imageWithColor(.white())
        playButton.setBackgroundImage(playImage, for: .normal)
        
        let prevImage = UIImage(named: "Prev")?.imageWithColor(.white())
        prevButton.setBackgroundImage(prevImage, for: .normal)
        
        let nextImage = UIImage(named: "Next")?.imageWithColor(.white())
        nextButton.setBackgroundImage(nextImage, for: .normal)
    }
    
}

// MARK: - Layout & constraints
extension PlayerControls {
    
    /**
     * Internal struct for layout
     */
    private struct Layout {
        
        static let height: CGFloat = 48.0
        static let width: CGFloat = 250.0
        
    }
    
    /**
     * Add subviews
     */
    private func addSubviews() {
        addSubview(playButton)
        addSubview(prevButton)
        addSubview(nextButton)
        
        addConstraintsWithFormat("H:[v0(48.0)]", views: playButton)
        addConstraintsWithFormat("V:|[v0(48.0)]", views: playButton)
        let playButtonCenterX = NSLayoutConstraint(item: playButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        addConstraint(playButtonCenterX)
        
        addConstraintsWithFormat("H:|[v0(48.0)]", views: prevButton)
        addConstraintsWithFormat("V:|[v0(48.0)]", views: prevButton)
        
        addConstraintsWithFormat("H:[v0(48.0)]|", views: nextButton)
        addConstraintsWithFormat("V:|[v0(48.0)]", views: nextButton)
    }
    
}


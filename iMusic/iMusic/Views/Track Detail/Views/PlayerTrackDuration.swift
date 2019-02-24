//
//  PlayerTrackDuration.swift
//  iMusic
//
//  Created by Ricardo Casanova on 24/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import UIKit

class PlayerTrackDuration: UIView {
    
    private let slider: UISlider = UISlider()
    private let currentDuration: UILabel = UILabel()
    private let totalDuration: UILabel = UILabel()
    
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
    
    public var current: Int? {
        didSet {
            guard let current = current else { return }
            currentDuration.text = TrackManager.shared.getTrackTimemmssFormatWith(trackTimeMillis: current * 1000)
            slider.value = Float(current * 1000)
        }
    }
    
    public var total: Double? {
        didSet {
            guard let total = total, !(total.isNaN || total.isInfinite) else { return }
            totalDuration.text = TrackManager.shared.getTrackTimemmssFormatWith(trackTimeMillis: Int(total * 1000.0))
            slider.maximumValue = Float(total * 1000.0)
        }
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
extension PlayerTrackDuration {
    
    private func setupViews() {
        backgroundColor = .clear
        
        configureSubviews()
        addSubviews()
    }
    
    private func configureSubviews() {
        slider.tintColor = .white()
        slider.thumbTintColor = .white()
        
        currentDuration.font = UIFont.mediumWithSize(size: 12.0)
        currentDuration.textColor = .white()
        totalDuration.textAlignment = .left
        currentDuration.text = "1:21"
        
        totalDuration.font = UIFont.mediumWithSize(size: 12.0)
        totalDuration.textColor = .white()
        totalDuration.textAlignment = .right
        totalDuration.text = "-4:53"
    }
    
}

// MARK: - Layout & constraints
extension PlayerTrackDuration {
    
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
        addSubview(slider)
        addSubview(currentDuration)
        addSubview(totalDuration)
        
        addConstraintsWithFormat("H:|[v0]|", views: slider)
        addConstraintsWithFormat("V:|-10.0-[v0(10.0)]", views: slider)
        
        addConstraintsWithFormat("H:|[v0(40.0)]", views: currentDuration)
        addConstraintsWithFormat("V:[v0(15.0)]|", views: currentDuration)
        
        addConstraintsWithFormat("H:[v0(40.0)]|", views: totalDuration)
        addConstraintsWithFormat("V:[v0(15.0)]|", views: totalDuration)
    }
    
}



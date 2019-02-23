//
//  TrackHeaderView.swift
//  iMusic
//
//  Created by Ricardo Casanova on 23/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import UIKit

class TrackHeaderView: UICollectionReusableView {
    
    private let topSeparatorImageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    private let bottomSeparatorImageView: UIImageView = UIImageView()
    
    /**
     * Identifier for reusable cells
     */
    static public var identifier : String {
        return String(describing: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    public static var height: CGFloat {
        return Layout.height
    }
    
}

// MARK: - Setup views
extension TrackHeaderView {
    
    /**
     * Setup views
     */
    private func setupViews() {
        backgroundColor = .black()
        
        configureSubviews()
        addSubviews()
    }
    
    /**
     * Configure subviews
     */
    private func configureSubviews() {
        topSeparatorImageView.image = UIImage(named: "SeparatorLine")
        titleLabel.font = UIFont.mediumWithSize(size: 16.0)
        titleLabel.textColor = .white()
        bottomSeparatorImageView.image = UIImage(named: "SeparatorLine")
    }
    
}

// MARK: - Layout & constraints
extension TrackHeaderView {
    
    /**
     * Private struct for internal layout
     */
    private struct Layout {
        
        static let height: CGFloat = 40.0
        
        struct SeparatorImageView {
            static let height: CGFloat = 1.0
        }
        
        struct TitleLabel {
            static let leading: CGFloat = 14.0
            static let trailing: CGFloat = 14.0
        }
        
    }
    
    /**
     * Add subviews
     */
    private func addSubviews() {
        addSubview(topSeparatorImageView)
        addSubview(titleLabel)
        addSubview(bottomSeparatorImageView)
        
        addConstraintsWithFormat("H:|[v0]|", views: topSeparatorImageView)
        addConstraintsWithFormat("V:|[v0(\(Layout.SeparatorImageView.height))]", views: topSeparatorImageView)
        
        addConstraintsWithFormat("H:|-\(Layout.TitleLabel.leading)-[v0]-\(Layout.TitleLabel.trailing)-|", views: titleLabel)
        addConstraintsWithFormat("V:|[v0]|", views: titleLabel)
        
        addConstraintsWithFormat("H:|[v0]|", views: bottomSeparatorImageView)
        addConstraintsWithFormat("V:[v0(\(Layout.SeparatorImageView.height))]|", views: bottomSeparatorImageView)
    }
    
}




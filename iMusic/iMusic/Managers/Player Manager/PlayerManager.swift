//
//  PlayerManager.swift
//  iMusic
//
//  Created by Ricardo Casanova on 24/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import Foundation
import AVFoundation

protocol PlayerManagerDelegate: class {
    func didFinishPlaying()
}

class PlayerManager {
    
    public weak var delegate: PlayerManagerDelegate?
    
    private var player: AVPlayer?
    private var url: URL?
    
    var isPlaying: Bool {
        return player?.timeControlStatus == .playing
    }
    
    static let shared: PlayerManager = { return PlayerManager() }()
    
    public func prepare(with url: URL) {
        self.url = url
        
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
    }
    
    public func play() {
        player?.play()
    }
    
    public func pause() {
        player?.pause()
    }

}

extension PlayerManager {
    
    @objc func didFinishPlaying() {
        delegate?.didFinishPlaying()
    }
    
}

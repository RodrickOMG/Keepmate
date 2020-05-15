//
//  PlayerView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/5/7.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI
import AVFoundation

// video player
struct PlayerView: UIViewRepresentable {
    @Binding var title: String
    @Binding var isBegin: Bool
    @Binding var isFinished: Bool
    
    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        if isBegin {
            uiView.beginPlayVideo()
        }
        if isFinished {
            uiView.stopPlayVideo()
        }
    }
    func makeUIView(context: Context) -> PlayerUIView {
        return PlayerUIView(frame: .zero, title: title)
    }
}

class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    var title = "Cossack Squat"
    var player = AVPlayer()
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        self.title = title
        print(title)
        let mediaPath = Bundle.main.path(forResource: "\(title)", ofType: "mp4")
        let mediaURL = URL(fileURLWithPath: mediaPath!)

        player = AVPlayer(url:mediaURL as URL)
        player.actionAtItemEnd = .none
        
        playerLayer.player = player
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
        
        layer.addSublayer(playerLayer)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
        }
    }
    func beginPlayVideo() {
        player.play()
    }
    func stopPlayVideo() {
        player.pause()
    }
}

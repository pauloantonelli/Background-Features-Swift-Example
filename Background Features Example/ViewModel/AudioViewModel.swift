//
//  AudioView.swift
//  Background Features Example
//
//  Created by Paulo Antonelli on 13/10/22.
//

import Foundation
import AVFoundation
import Combine

class AudioViewModel {
    private var itemObserver: AnyCancellable = AnyCancellable(({}))
    private var timeObserver: Any?
    private var player: AVQueuePlayer
    var timer: TimeInterval = 0
    var avPlayerItem: AVPlayerItem?
    
    var isPlaying: Bool = false
    var currentTrackIndex: Int = 0
    var itemTitle: String {
        if let asset = self.avPlayerItem?.asset as? AVURLAsset {
            return asset.url.lastPathComponent
        } else {
            return "-"
        }
    }
    static var songList: Array<AVPlayerItem> = {
        let songNameList: Array<String> = ["FeelinGood", "IronBacon", "WhatYouWant"]
        return songNameList.map { songName in
            guard let songUrl = Bundle.main.url(forResource: songName, withExtension: "mp3") else {
                return nil
            }
            return AVPlayerItem(url: songUrl)
        }.compactMap { $0 }
    }()
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback,mode: .default)
        } catch {
            print("Failed to set audio session category. Error: \(error)")
        }
        self.player = AVQueuePlayer(items: Self.songList)
        self.player.actionAtItemEnd = .advance
        self.itemObserver = player.publisher(for: \.currentItem).sink { [weak self] avPlayerItem in
            self?.avPlayerItem = avPlayerItem
        }
        self.timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 600),
            queue: nil,
            using: { [weak self] timer in
                self?.timer = timer.seconds
            }
        )
    }
}

extension AudioViewModel {    
    func playPauseAudio() -> Void {
        self.isPlaying.toggle()
        if isPlaying {
            self.player.play()
        } else {
            self.player.pause()
        }
    }
    
    func playTrack() -> Void {
        if Self.songList.count > 0 {
            self.isPlaying = false
            self.player.pause()
            self.player.replaceCurrentItem(with: Self.songList[self.currentTrackIndex])
            self.player.play()
            self.isPlaying = true
        }
    }
    
    func goToNextSong() -> Void {
        if self.currentTrackIndex > Self.songList.count {
            self.currentTrackIndex = 0
        } else {
            self.currentTrackIndex += 1
        }
        self.player.advanceToNextItem()
        self.playPauseAudio()
    }
    
    func goToPreviousSong() -> Void {
        if self.currentTrackIndex - 1 < 0 {
            self.currentTrackIndex = (Self.songList.count - 1) < 0 ? 0 : (Self.songList.count - 1)
        } else {
            self.currentTrackIndex -= 1
        }
        self.playTrack()
    }
}

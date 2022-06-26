//
//  FakeDownloadAppsService.swift
//  iOSArchitecturesDemo
//
//  Created by Никита Мошенцев on 22.06.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import Foundation

protocol PlaySongServiceInterface: class {
    var playingSongs: [PlayingSong] { get }
    var onProgressPlaying:(() -> Void)? { get set }
    func startPlayingSong(_ song: ITunesSong)
}

final class PlayingSong {
    enum PlayState {
        case notStarted
        case inProgress(Progress: Double)
        case isPlayed
    }
    
    let song: ITunesSong
    
    var playingState: PlayState = .notStarted
    
    init(song: ITunesSong) {
        self.song = song
    }
}

final class FakePlayingSongService: PlaySongServiceInterface {
    
    private(set) var playingSongs: [PlayingSong] = []
    
    var onProgressPlaying: (() -> Void)?
    
    func startPlayingSong(_ song: ITunesSong) {
        let playingSong = PlayingSong(song: song)
        if !self.playingSongs.contains(where: { $0.song.trackName == song.trackName}) {
            self.playingSongs.append(playingSong)
            self.startTimer(for: playingSong)
        }
    }
    
    private var timers: [Timer] = []
    
    private func startTimer(for playingSong: PlayingSong) {
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            [weak self] timer in
            switch playingSong.playingState {
            case .notStarted:
                playingSong.playingState = .inProgress(Progress: 0.1)
            case .inProgress(let progress):
                let newProgress = progress + 0.1
                if newProgress >= 1 {
                    playingSong.playingState = .isPlayed
                    self?.invalidateTimer(timer)
                } else {
                    playingSong.playingState = .inProgress(Progress: progress + 0.1)
                }
            case .isPlayed:
                self?.invalidateTimer(timer)
            }
            self?.onProgressPlaying?()
        }
        RunLoop.main.add(timer, forMode: .common)
        self.timers.append(timer)
    }
    
    private func invalidateTimer(_ timer: Timer) {
        timer.invalidate()
        self.timers.removeAll() { $0 === timer }
    }
}

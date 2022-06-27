//
//  MusicDetailViewModel.swift
//  iOSArchitecturesDemo
//
//  Created by Никита Мошенцев on 26.06.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import Foundation
import UIKit

final class MusicDetailViewModel {
    
    //MARK: - Properties
    
    let songModel = Observable<MusicDetailModel?>(nil)
    let isPlaying = Observable<Bool>(false)
    
    weak var viewController: UIViewController?
    
    private var songITunes: ITunesSong
    
    private let playingSongService: PlaySongServiceInterface
    
    //MARK: - Init
    
    init(playingSongService: PlaySongServiceInterface, songITunes: ITunesSong) {
        self.playingSongService = playingSongService
        self.songITunes = songITunes
        isPlaying.value = false
        self.songModel.value = MusicDetailModel(trackName: songITunes.trackName, artistName: songITunes.artistName , albumImage: songITunes.artwork, playingState: .notStarted)
        playingSongService.onProgressPlaying = {[weak self] in
            guard let self = self else { return }
            self.songModel.value = self.viewModel()
        }
    }
    
    //MARK: - Methods
    
    func didTapPlaySong(_ songViewModel: MusicDetailModel) {
        self.isPlaying.value = true
        self.playingSongService.startPlayingSong(songITunes)
    }
    
    private func viewModel() -> MusicDetailModel {
       let playingSong = self.playingSongService.playingSongs.first { playingSong -> Bool in
            return playingSong.song.trackName == songITunes.trackName
        }
        return MusicDetailModel(trackName: songITunes.trackName ,
                                artistName: songITunes.artistName,
                                albumImage: songITunes.artwork,
                                playingState: playingSong?.playingState ?? .notStarted)
    }
    
    private func song(with viewModel: MusicDetailModel) -> ITunesSong? {
        guard viewModel.artistName == self.songITunes.trackName
        else {
            return ITunesSong(trackName: "", artistName: nil, collectionName: nil, artwork: nil)
        }
             return songITunes
    }
}

struct MusicDetailModel {
    let trackName: String
    var artistName: String?
    let albumImage: String?
    let playingState: PlayingSong.PlayState
}

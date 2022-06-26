//
//  SearchMusicViewModel.swift
//  iOSArchitecturesDemo
//
//  Created by Никита Мошенцев on 23.06.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import Foundation
import UIKit

final class SearchMusicViewModel {
    
    //MARK: - Observable properties
    
    let musicCellModels = Observable<[SearchMusicCellModel]>([])
    let isPlaying = Observable<Bool>(false)
    let showEmptyResults = Observable<Bool>(false)
    let error = Observable<Error?>(nil)
    
    //MARK: - Properties
    
    weak var viewController: UIViewController?
    
    private var songs: [ITunesSong] = []
    
    private let searchService: ITunesSearchService
    private let playingSongsService: PlaySongServiceInterface
    
    //MARK: - Init
    
    init(searchService: ITunesSearchService, playingSongService: PlaySongServiceInterface) {
        self.searchService = searchService
        self.playingSongsService = playingSongService
        playingSongService.onProgressPlaying = { [weak self] in
            guard let self = self else { return }
            self.musicCellModels.value = self.viewModels()
        }
    }
    
    //MARK: - ViewModel methods
    
    func search(for query: String) {
        self.isPlaying.value = true
        self.searchService.getSongs(forQuery: query) { [weak self] result in
            guard let self = self else { return }
            result.withValue { songs in
                self.songs = songs
                self.musicCellModels.value = self.viewModels()
                self.isPlaying.value = false
                self.showEmptyResults.value = songs.isEmpty
                self.error.value = nil
            }
            .withError {
                self.songs = []
                self.musicCellModels.value = []
                self.isPlaying.value = false
                self.showEmptyResults.value = true
                self.error.value = $0
            }
        }
    }
    
    func didSelectSong(_ songViewModel: SearchMusicCellModel) {
//        guard let song = self.song(with: songViewModel) else { return }
//        let songDetailViewController = SongDetailViewController(song: song)
//        self.viewController?.navigationController?.pushViewController(songDetailViewController, animated: true)
        //TODO: - release MusicDetailViewController
        
    }
    
    func didTapPlaySong(_ songViewModel: SearchMusicCellModel) {
        guard let song = self.song(with: songViewModel) else { return }
            self.playingSongsService.startPlayingSong(song)
    }
    
    private func viewModels() -> [SearchMusicCellModel] {
        return self.songs.compactMap { song -> SearchMusicCellModel in
            let playingSong = self.playingSongsService.playingSongs.first {
                playingSong -> Bool in
                return playingSong.song.trackName == song.trackName
        }
            return SearchMusicCellModel(trackName: song.trackName,
                                        artistName: song.artistName,
                                        collectionName: song.collectionName,
                                        playingState: playingSong?.playingState ?? .notStarted)
        }
    }
    
    private func song(with viewModel: SearchMusicCellModel) -> ITunesSong? {
        return self.songs.first { viewModel.trackName == $0.trackName }
    }
}

//MARK: - Model for View

struct SearchMusicCellModel {
    let trackName: String
    let artistName: String?
    let collectionName: String?
    let playingState: PlayingSong.PlayState
}

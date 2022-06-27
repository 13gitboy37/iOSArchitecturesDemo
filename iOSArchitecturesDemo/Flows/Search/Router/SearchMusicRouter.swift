//
//  SearchMusicRouter.swift
//  iOSArchitecturesDemo
//
//  Created by Никита Мошенцев on 22.06.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import Foundation
import UIKit

protocol SearchMusicRouterInput {
    func openDetails(for song: ITunesSong)
    
    func openSongsInITunes(_ song: ITunesSong)
}

final class SearchMusicRouter: SearchMusicRouterInput {
    
    weak var viewController: UIViewController?
    
    func openDetails(for song: ITunesSong) {
        let playingSongService = FakePlayingSongService()
        let musicDetailViewModel = MusicDetailViewModel(playingSongService: playingSongService, songITunes: song)
        let songDetailViewController = MusicDetailViewController(viewModel: musicDetailViewModel)
        self.viewController?.navigationController?.pushViewController(songDetailViewController, animated: true)
        
//        let viewModel = MusicDetailViewModel(playingSongService: FakePlayingSongService())
//        let viewController = MusicDetailPlayViewController(viewModel: viewModel)
//        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openSongsInITunes(_ song: ITunesSong) {

    }
}

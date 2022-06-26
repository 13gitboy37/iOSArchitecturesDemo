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
//        let songDetailViewController = SongDetailViewController(song: song)
//        self.viewController?.navigationController?.pushViewController(songDetailViewController, animated: true)
    }
    
    func openSongsInITunes(_ song: ITunesSong) {
//        guard let urlString = song.artistName, let url = URL(string: urlString)
//            else { return }
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

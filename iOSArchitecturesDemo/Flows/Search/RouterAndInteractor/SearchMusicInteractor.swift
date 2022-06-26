//
//  SearchMusicInteractor.swift
//  iOSArchitecturesDemo
//
//  Created by Никита Мошенцев on 22.06.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import Foundation
import Alamofire

protocol SearchMusicInteractorInput {
    func requestSongs(with query: String, completion: @escaping (Result<[ITunesSong]>) -> Void)
}

final class SearchMusicInteractor: SearchMusicInteractorInput {
    
    private let searchService = ITunesSearchService()
    
    func requestSongs(with query: String, completion: @escaping (Result<[ITunesSong]>) -> Void) {
        self.searchService.getSongs(forQuery: query, completion: completion)
        
        //MARK: - Здесь нужно засейвить в кэш
    }
}

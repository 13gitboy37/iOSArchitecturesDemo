//
//  SearchMusicPresenter.swift
//  iOSArchitecturesDemo
//
//  Created by Никита Мошенцев on 21.06.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//
//
import UIKit

protocol SearchMusicViewInput: AnyObject {
    var searchResults: [ITunesSong] { get set }
    func showError(error: Error)
    func showNoResults()
    func hideNoResults()
}

protocol SearchMusicViewOutput: AnyObject {
    func viewDidSearch(with query: String)
    func viewDidSelectSong(_ song: ITunesSong)
}

class SearchMusicPresenter {
    
    weak var viewInput: (UIViewController & SearchMusicViewInput)?
    let interactor: SearchMusicInteractorInput
    let router: SearchMusicRouterInput
    
    //MARK: - Private properties
    
    private let searchService = ITunesSearchService()
    
    //MARK: - Init
    
    init(interactor: SearchMusicInteractorInput, router: SearchMusicRouterInput) {
        self.interactor = interactor
        self.router = router
    }
    
    //MARK: - Private methods
    
    private func requestApps(with query: String) {

        interactor.requestSongs(with: query) { [weak self] result in
            guard let self = self else { return }
                result.withValue { songs in
                guard !songs.isEmpty else {
                        self.viewInput?.showNoResults()
                        return
                    }
                    self.viewInput?.hideNoResults()
                    self.viewInput?.searchResults = songs
                    } .withError {
                        self.viewInput?.showError(error: $0)
                    }
            }
        }
    
    private func openDetails(with song: ITunesSong) {
        router.openDetails(for: song)
    }
}

extension SearchMusicPresenter: SearchMusicViewOutput {
    func viewDidSelectSong(_ song: ITunesSong) {
        self.openDetails(with: song)
    }
    
    func viewDidSearch(with query: String) {
        self.requestApps(with: query)
    }
}

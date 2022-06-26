//
//  SearchMusicViewController.swift
//  iOSArchitecturesDemo
//
//  Created by Никита Мошенцев on 21.06.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

final class SearchMusicViewController: UIViewController {
    
    // MARK: - Properties
    
    var searchResults = [SearchMusicCellModel]() {
        didSet {
            self.searchView.tableView.isHidden = false
            self.searchView.tableView.reloadData()
            self.searchView.searchBar.resignFirstResponder()
        }
    }
    
    // MARK: - Private Properties
    
    private var searchView: SearchView {
        return self.view as! SearchView
    }
    
    private let searchService = ITunesSearchService()
    private struct Constants {
        static let reuseIdentifier = "reuseId"
    }
    
    private let viewModel: SearchMusicViewModel
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let emptyResultView = UIView()
    private let emptyResultLabel = UILabel()
    
    // MARK: - Construction
    
    init(viewModel: SearchMusicViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = SearchView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.searchView.searchBar.delegate = self
        self.searchView.tableView.register(MusicCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
        self.searchView.tableView.delegate = self
        self.searchView.tableView.dataSource = self
        
        self.bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.throbber(show: false)
    }
    
    private func bindViewModel() {
        self.viewModel.isPlaying.addObserver(self) { [weak self] (isPlaying, _) in
            self?.throbber(show: isPlaying)
        }
        
        self.viewModel.error.addObserver(self) { [weak self] (error, _) in
            if let error = error {
                self?.showError(error: error)
            }
        }
        
        self.viewModel.showEmptyResults.addObserver(self) { [weak self]
            (showEmptuResults, _) in
            self?.emptyResultView.isHidden = !showEmptuResults
            self?.tableView.isHidden = showEmptuResults
        }
        
        self.viewModel.musicCellModels.addObserver(self) { [weak self] (searchResults, _) in
            self?.searchResults = searchResults
        }
    }
}


//MARK: - UITableViewDataSource
extension SearchMusicViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)
        
        guard let cell = dequeuedCell as? MusicCell else {
            return dequeuedCell
        }
        
        let song = self.searchResults[indexPath.row]
//        let cellModel = MusicCellModelFactory.cellModel(from: song)
        
        congigure(cell: cell, with: song)
        
        return cell
    }
    
    func congigure(cell: MusicCell, with song: SearchMusicCellModel) {
        cell.titleLabel.text = song.trackName
        cell.subtitleLabel.text = song.artistName
        cell.ratingLabel.text = song.collectionName
        
        switch song.playingState {
        case .notStarted:
            break
        case .inProgress(Progress: let progress):
            let progressToShow = round(progress * 60.0) / 60.0
            cell.ratingLabel.text = "\(progressToShow)"
        case .isPlayed:
            cell.ratingLabel.text = "Проигрование закончено"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                cell.ratingLabel.text = song.collectionName
            })
        }
    }
}

//MARK: - UITableViewDelegate
extension SearchMusicViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = searchResults[indexPath.row]
//        view.viewDidSearch(with: "\(song)")
        viewModel.didTapPlaySong(song)
    }
}

//MARK: - UISearchBarDelegate
extension SearchMusicViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            searchBar.resignFirstResponder()
            return
        }
        if query.count == 0 {
            searchBar.resignFirstResponder()
            return
        }
        
//        self.presenter.viewDidSearch(with: query)
        viewModel.search(for: query)
    }
}

// MARK: - Input
extension SearchMusicViewController: SearchMusicViewInput {
    func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNoResults() {
        self.emptyResultView.isHidden = false
        self.searchResults = []
        self.tableView.reloadData()
    }
    
    func hideNoResults() {
        self.emptyResultView.isHidden = true
    }
    
    func throbber(show: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = show
    }
}

protocol SearchMusicViewInput: AnyObject {
    var searchResults: [SearchMusicCellModel] { get set }
    func showError(error: Error)
    func showNoResults()
    func hideNoResults()
}

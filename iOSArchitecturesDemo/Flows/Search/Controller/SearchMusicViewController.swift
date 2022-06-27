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
        
        var searchResults = [ITunesSong]() {
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
        
        private let presenter: SearchMusicViewOutput
        
        private let searchBar = UISearchBar()
        private let tableView = UITableView()
        private let emptyResultView = UIView()
        private let emptyResultLabel = UILabel()
        
        // MARK: - Construction
        
        init(presenter: SearchMusicViewOutput) {
            self.presenter = presenter
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
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            self.throbber(show: false)
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
            let cellModel = MusicCellModelFactory.cellModel(from: song)
            cell.configure(with: cellModel)
            
            return cell
        }
    }

    //MARK: - UITableViewDelegate

    extension SearchMusicViewController: UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let song = searchResults[indexPath.row]
            presenter.viewDidSelectSong(song)
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
            
            self.presenter.viewDidSearch(with: query)
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

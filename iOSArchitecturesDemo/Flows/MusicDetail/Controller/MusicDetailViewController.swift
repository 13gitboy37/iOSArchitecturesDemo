//
//  MusicDetailViewController.swift
//  iOSArchitecturesDemo
//
//  Created by Никита Мошенцев on 26.06.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

final class MusicDetailViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let viewModel: MusicDetailViewModel
    
    private var song: MusicDetailModel?
    
    private let imageDownloader = ImageDownloader()
    
    private var musicDetailView: MusicDetailView {
        return self.view as! MusicDetailView
    }
    
    //MARK: - Init
    
    init(viewModel: MusicDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = MusicDetailView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModels()
        configure(with: viewModel.songModel.value ?? MusicDetailModel(trackName: "", artistName: "", albumImage: "", playingState: .notStarted))
    }

    //MARK: - Private Methods
    private func downloadImage() {
        guard let url = self.viewModel.songModel.value?.albumImage else {
            return
        }
        self.imageDownloader.getImage(fromUrl: url) { [weak self] (image, _) in
            self?.musicDetailView.albumImage.image = image
        }
    }
    
    private func bindViewModels() {
        self.viewModel.isPlaying.addObserver(self) { [weak self] (isPlaying, _) in
            self?.musicDetailView.timeSongLabel.isHidden = !isPlaying
        }
        
        self.viewModel.songModel.addObserver(self) { [weak self] (song, _) in
            self?.song = song
            switch song?.playingState {
            case .notStarted:
                self?.musicDetailView.timeSongLabel.isHidden = false
            case .inProgress(Progress: let progress):
                let progressToShow = progress * 100 / 100
                self?.musicDetailView.timeSongLabel.text = "0:0\(progressToShow)"
            case .isPlayed:
                self?.musicDetailView.timeSongLabel.text = "Play is over"
                self?.musicDetailView.playSongButton.isHidden = true
            case .none:
                break
            }
        }
    }
    
    private func configure(with song: MusicDetailModel) {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.largeTitleDisplayMode = .never
        
        self.musicDetailView.trackNameLabel.text = song.trackName
        self.musicDetailView.artistNameLabel.text = song.artistName
        self.downloadImage()
        
        self.musicDetailView.playSongButton.addTarget(self, action: #selector(tapPlayButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapPlayButton(_ sender: UIButton) {
        viewModel.didTapPlaySong(viewModel.songModel.value ?? MusicDetailModel(trackName: "", artistName: "", albumImage: "", playingState: .notStarted))
        }
    }

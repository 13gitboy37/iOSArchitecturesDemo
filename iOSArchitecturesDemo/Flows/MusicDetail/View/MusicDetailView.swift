//
//  MusicDetailView.swift
//  iOSArchitecturesDemo
//
//  Created by Никита Мошенцев on 26.06.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

class MusicDetailView: UIView {
    
    //MARK: - Private properties
    
    private(set) lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        
        return label
    }()
    
    private(set) lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 1
        
        return label
    }()
    
    private(set) lazy var albumImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30.0
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private(set) lazy var playSongButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.imageView?.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    private(set) lazy var timeSongLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0:00"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 22)
        label.isHidden = true
        return label
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupLayout()
    }
    
    //MARK: - Setup Layouts
    
    func setupLayout() {
        self.addSubview(trackNameLabel)
        self.addSubview(artistNameLabel)
        self.addSubview(albumImage)
        self.addSubview(playSongButton)
        self.addSubview(timeSongLabel)
        
        NSLayoutConstraint.activate([
            self.albumImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.albumImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100),
            self.albumImage.widthAnchor.constraint(equalToConstant: 200.0),
            self.albumImage.heightAnchor.constraint(equalToConstant: 200.0),
            
            self.trackNameLabel.topAnchor.constraint(equalTo: self.albumImage.bottomAnchor, constant: 30),
            self.trackNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            self.artistNameLabel.topAnchor.constraint(equalTo: self.trackNameLabel.bottomAnchor, constant: 10),
            self.artistNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            
            self.timeSongLabel.topAnchor.constraint(equalTo:self.artistNameLabel.topAnchor, constant: 30),
            self.timeSongLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            self.playSongButton.topAnchor.constraint(equalTo: self.timeSongLabel.bottomAnchor, constant: 10),
            self.playSongButton.centerXAnchor.constraint(equalTo: self.timeSongLabel.centerXAnchor),
            self.playSongButton.widthAnchor.constraint(equalToConstant: 40),
                    self.playSongButton.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
    }

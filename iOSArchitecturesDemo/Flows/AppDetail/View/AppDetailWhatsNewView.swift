//
//  AppDetailWhatsNewView.swift
//  iOSArchitecturesDemo
//
//  Created by Никита Мошенцев on 20.06.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

class AppDetailWhatsNewView: UIView {
    
    //MARK: - Private properties
    
    private(set) lazy var whatsNewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.numberOfLines = 1
        return label
    }()
    
    private(set) lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()
    
    private(set) lazy var dateVersionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()
    
    private(set) lazy var textAboutVersionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 8
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
    
    //MARK: - UI
    private func setupLayout() {
        self.addSubview(whatsNewLabel)
        self.addSubview(versionLabel)
        self.addSubview(dateVersionLabel)
        self.addSubview(textAboutVersionLabel)
        
        NSLayoutConstraint.activate([
            self.whatsNewLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12),
            self.whatsNewLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.whatsNewLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 20),
            self.versionLabel.topAnchor.constraint(equalTo: self.whatsNewLabel.bottomAnchor, constant: 10),
            self.versionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.versionLabel.rightAnchor.constraint(equalTo: self.dateVersionLabel.leftAnchor,constant: -20),
            self.dateVersionLabel.topAnchor.constraint(equalTo: self.whatsNewLabel.bottomAnchor, constant: 10),
            self.dateVersionLabel.leftAnchor.constraint(equalTo: self.versionLabel.rightAnchor, constant: 20),
            self.dateVersionLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -12),
            self.textAboutVersionLabel.topAnchor.constraint(equalTo: self.versionLabel.bottomAnchor, constant: 15),
            self.textAboutVersionLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 16),
            self.textAboutVersionLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -5)
        ])
    }
}

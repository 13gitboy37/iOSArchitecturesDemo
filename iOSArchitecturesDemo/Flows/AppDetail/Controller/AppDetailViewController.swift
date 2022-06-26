//
//  AppDetailViewController.swift
//  iOSArchitecturesDemo
//
//  Created by ekireev on 20.02.2018.
//  Copyright © 2018 ekireev. All rights reserved.
//

import UIKit

final class AppDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    public var app: ITunesApp
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = .white
        view.frame = self.view.bounds
        view.contentSize = contentViewSize
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.frame.size = contentViewSize
        return view
    }()
    
    lazy var headerViewController = AppDetailHeaderViewController(app: self.app)
    
    lazy var whatsNewViewController = AppDetailWhatsNewViewController(app: self.app)
    
    lazy var screenshotsViewController = AppDetailScreenshotsViewController(app: self.app)
        
    // MARK: - Construction
    
    init(app: ITunesApp) {
        self.app = app
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    // MARK: - Private Functions
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.largeTitleDisplayMode = .never
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        addHeaderViewController()
        addWhatsNewViewController()
        addScreenshotsViewController()
    }
    
    private func addHeaderViewController() {
        contentView.addSubview(headerViewController.view)
        
        headerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.headerViewController.view.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.headerViewController.view.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.headerViewController.view.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)

        ])
    }
    
    private func addWhatsNewViewController() {
        contentView.addSubview(whatsNewViewController.view)
        
        whatsNewViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            whatsNewViewController.view.topAnchor.constraint(equalTo: self.headerViewController.view.bottomAnchor),
            whatsNewViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            whatsNewViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            whatsNewViewController.view.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    private func addScreenshotsViewController() {
            contentView.addSubview(screenshotsViewController.view)
           screenshotsViewController.view.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               screenshotsViewController.view.topAnchor.constraint(equalTo: self.whatsNewViewController.view.bottomAnchor, constant: 0),
               screenshotsViewController.view.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
               screenshotsViewController.view.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
               screenshotsViewController.view.heightAnchor.constraint(equalToConstant: self.contentView.frame.width)
           ])
       }
}


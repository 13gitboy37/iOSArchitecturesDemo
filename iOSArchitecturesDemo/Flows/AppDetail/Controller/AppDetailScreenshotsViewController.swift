//
//  AppDetailScreenshots.swift
//  iOSArchitecturesDemo
//
//  Created by Никита Мошенцев on 20.06.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

final class AppDetailScreenshotsViewController: UIViewController {
    
    private let app: ITunesApp
    private let imageDownloader = ImageDownloader()
    
    private var images: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var collectionView: UICollectionView!
    
    private struct Constants {
           static let reuseIdentifier = "reuseId"
       }
    
    init(app: ITunesApp) {
        self.app = app
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
              layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
              layout.itemSize = CGSize(width: view.frame.width, height: view.frame.width)
              layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentMode = .scaleAspectFit
        collectionView.register(AppDetailScreenshotsCell.self, forCellWithReuseIdentifier: Constants.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        self.view.addSubview(collectionView)
        
        collectionView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        fillData()
    }
    
    private func fillData() {
        self.downloadImage()
    }
    
    private func downloadImage() {
        self.app.screenshotUrls.forEach { url in
            self.imageDownloader.getImage(fromUrl: url) { [weak self] (image, _) in
                self?.images.append(image ?? UIImage(named: "Profile")!)
            }
        }
    }
}

extension AppDetailScreenshotsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: Data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath)
        guard let cell = dequeuedCell as? AppDetailScreenshotsCell
            else {return UICollectionViewCell()}
        let image = images[indexPath.row]
        cell.configure(image: image)
        return cell
    }
    
    //MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let galleryViewController = FullScreenScreenShotsViewController(app: app)
        self.navigationController?.pushViewController(galleryViewController, animated: true)
    }
}

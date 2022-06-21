//
//  SearchModuleBuilder.swift
//  iOSArchitecturesDemo
//
//  Created by Alexander Rubtsov on 21.02.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

class SearchModuleBuilder {
    
    static func build() -> (UITabBarController) {
        
        let presenter = SearchPresenter()
        let viewController = SearchViewController(presenter: presenter)
        presenter.viewInput = viewController
        viewController.tabBarItem = UITabBarItem(title: "Apps", image: UIImage(systemName: "square.stack.3d.up"), selectedImage: UIImage(systemName: "square.stack.3d.up.fill"))
        
        let musicPresenter = SearchMusicPresenter()
        let musicViewController = SearchMusicViewController(presenter: musicPresenter)
        musicPresenter.viewInput = musicViewController
        musicViewController.tabBarItem = UITabBarItem(title: "Music", image: UIImage(systemName: "music.mic.circle"), selectedImage: UIImage(systemName: "music.mic.circle.fill"))
        
        let tabBarContoller = TabBarController(controllers: [viewController, musicViewController])
        return tabBarContoller
    }
}

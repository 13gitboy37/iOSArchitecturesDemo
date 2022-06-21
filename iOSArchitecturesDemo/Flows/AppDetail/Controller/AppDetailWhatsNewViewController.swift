//
//  AppDetailWhatsNewViewController.swift
//  iOSArchitecturesDemo
//
//  Created by Никита Мошенцев on 20.06.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

class AppDetailWhatsNewViewController: UIViewController {
    
    //MARK: - Properties
    
    private var app: ITunesApp
    private var appDetailWhatsNewView: AppDetailWhatsNewView {
        return self.view as! AppDetailWhatsNewView
    }
    
    //MARK: - Init
    
    init(app: ITunesApp) {
        self.app = app
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = AppDetailWhatsNewView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillData()
    }
    
    //MARK: - Methods
    
    private func fillData() {
        self.appDetailWhatsNewView.whatsNewLabel.text = "Что нового"
        self.appDetailWhatsNewView.versionLabel.text = "Версия \(app.version)"
        self.appDetailWhatsNewView.dateVersionLabel.text = dateFormatter(date: app.currentVersionReleaseDate)
        self.appDetailWhatsNewView.textAboutVersionLabel.text = app.releaseNotes
    }
    
    private func dateFormatter(date: String) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
           let newFormDate = dateFormatter.date(from: date)
           let formatter = DateFormatter()
           formatter.dateFormat = "dd.MM.yyyy"
           let dateFormat = formatter.string(from: newFormDate ?? Date())
           return dateFormat
       }
}

//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by alexander on 09.03.2025.
//

import UIKit

final class StatisticsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyScreenImage.image = UIImage(named: "emptyStatistics")
        emptyScreenText.text = "Анализировать пока нечего"
        view.backgroundColor = .ypWhite
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.topItem?.title = "Статистика"
            navigationBar.prefersLargeTitles = true
            navigationBar.topItem?.largeTitleDisplayMode = .always
        }
    }
    
    private lazy var emptyScreenImage: UIImageView = {
        let emptyScreenImage = UIImageView()
        view.addSubview(emptyScreenImage)
        emptyScreenImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyScreenImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyScreenImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        return emptyScreenImage
    }()
    
    private lazy var emptyScreenText: UILabel = {
        let emptyScreenText = UILabel()
        view.addSubview(emptyScreenText)
        emptyScreenText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyScreenText.topAnchor.constraint(equalTo: emptyScreenImage.bottomAnchor, constant: 8),
            emptyScreenText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        emptyScreenText.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return emptyScreenText
    }()
}

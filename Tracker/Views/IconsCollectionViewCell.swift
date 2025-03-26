//
//  IconsCollectionViewCell.swift
//  Tracker
//
//  Created by alexander on 26.03.2025.
//

import UIKit

final class IconsCollectionViewCell: UICollectionViewCell {
    var icon: String? {
        didSet {
            iconLabel.text = icon
        }
    }
    
    private var iconLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var iconBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .ypLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubviews()
        constraintSubviews()
        backgroundColor = .ypWhite
        
        self.selectedBackgroundView = iconBackground
    }
    
    private func addSubviews() {
        contentView.addSubview(iconLabel)
    }
    
    private func constraintSubviews() {
        NSLayoutConstraint.activate([
            iconLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}


//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by alexander on 11.03.2025.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    var delegate: TrackerCollectionViewCellDelegate?
    
    var daysCounter: Int = 0 {
        didSet {
            updateCounterLabel()
        }
    }
    
    var tracker: Tracker? {
        didSet {
            title.text = tracker?.title
            icon.text = tracker?.icon
            rectangleView.backgroundColor = tracker?.color
            counterButton.backgroundColor = tracker?.color
        }
    }
    
    var completedTracker: Bool = false {
        didSet {
            updateButtonState()
        }
    }
    
    lazy var rectangleView: UIView = {
        let rectangleView = UIView()
        rectangleView.translatesAutoresizingMaskIntoConstraints = false
        rectangleView.layer.cornerRadius = 16
        return rectangleView
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .white
        title.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        title.numberOfLines = 0
        return title
    }()
    
    lazy var iconBackground: UIView = {
        let iconBackground = UIView()
        iconBackground.translatesAutoresizingMaskIntoConstraints = false
        iconBackground.layer.cornerRadius = 15
        iconBackground.backgroundColor = UIColor(white: 1, alpha: 0.3)
        return iconBackground
    }()
    
    lazy var icon: UILabel = {
        let icon = UILabel()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.font = .systemFont(ofSize: 16)
        return icon
    }()
    
    lazy var days: UILabel = {
        let days = UILabel()
        days.translatesAutoresizingMaskIntoConstraints = false
        days.font = .systemFont(ofSize: 12, weight: .medium)
        return days
    }()
    
    lazy var counterButton: UIButton = {
        let counterButton = UIButton()
        counterButton.translatesAutoresizingMaskIntoConstraints = false
        counterButton.layer.cornerRadius = 20
        counterButton.addTarget(self, action: #selector(checkForToday), for: .touchUpInside)
        return counterButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        constraintSubviews()
        updateButtonState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) hasn't implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(rectangleView)
        rectangleView.addSubview(title)
        rectangleView.addSubview(iconBackground)
        iconBackground.addSubview(icon)
        contentView.addSubview(days)
        contentView.addSubview(counterButton)
    }
    
    private func constraintSubviews() {
        NSLayoutConstraint.activate([
            rectangleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rectangleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rectangleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rectangleView.heightAnchor.constraint(equalToConstant: 90),
            
            title.topAnchor.constraint(greaterThanOrEqualTo: iconBackground.bottomAnchor, constant: 4),
            title.bottomAnchor.constraint(equalTo: rectangleView.bottomAnchor, constant: -12),
            title.leadingAnchor.constraint(equalTo: rectangleView.leadingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: rectangleView.trailingAnchor, constant: -12),
            
            iconBackground.heightAnchor.constraint(equalToConstant: 30),
            iconBackground.widthAnchor.constraint(equalToConstant: 30),
            iconBackground.topAnchor.constraint(equalTo: rectangleView.topAnchor, constant: 12),
            iconBackground.leadingAnchor.constraint(equalTo: rectangleView.leadingAnchor, constant: 12),
            
            icon.centerXAnchor.constraint(equalTo: iconBackground.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconBackground.centerYAnchor),
            
            days.topAnchor.constraint(equalTo: rectangleView.bottomAnchor, constant: 16),
            days.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            counterButton.topAnchor.constraint(equalTo: rectangleView.bottomAnchor, constant: 8),
            counterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            counterButton.heightAnchor.constraint(equalToConstant: 40),
            counterButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc
    private func checkForToday() {
        if completedTracker {
            daysCounter -= 1
        } else {
            daysCounter += 1
        }
        completedTracker = !completedTracker
        guard let tracker else { return }
        delegate?.didComplete(completedTracker, tracker: tracker)
    }
    
    private func updateButtonState() {
        switch completedTracker {
        case true:
            counterButton.setImage(UIImage(named: "Check"), for: .normal)
            counterButton.alpha = 0.3
            counterButton.imageView?.tintColor = .ypWhite
        case false:
            counterButton.setImage(UIImage(systemName: "plus"), for: .normal)
            counterButton.alpha = 1
            counterButton.imageView?.tintColor = .ypWhite
        }
    }
    
    private func updateCounterLabel() {
        let daysLabelForCell = "\(daysCounter) дней"
        days.text = daysLabelForCell
    }
}

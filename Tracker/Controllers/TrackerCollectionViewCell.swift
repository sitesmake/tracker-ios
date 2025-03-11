//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by alexander on 11.03.2025.
//

import UIKit

class TrackerCollectionViewCell: UICollectionViewCell {
    var delegate: TrackerCollectionViewCellDelegate?

    var daysCounter: Int = 0 {
        didSet {
            updateCounterLabel()
        }
    }

    var tracker: Tracker? {
        didSet {
            name.text = tracker?.title
            emoji.text = tracker?.icon
            rectangleView.backgroundColor = tracker?.color
            counterButton.backgroundColor = tracker?.color
        }
    }

    var comletedTracker: Bool = false {
        didSet {
            upadateButtonState()
        }
    }

    lazy var rectangleView: UIView = {
        let rectangleView = UIView()
        rectangleView.translatesAutoresizingMaskIntoConstraints = false
        rectangleView.layer.cornerRadius = 16
        return rectangleView
    }()

    lazy var name: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .white
        name.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        name.numberOfLines = 0
        return name
    }()

    lazy var emojiBackground: UIView = {
        let emojiBackground = UIView()
        emojiBackground.translatesAutoresizingMaskIntoConstraints = false
        emojiBackground.layer.cornerRadius = 15
        emojiBackground.backgroundColor = UIColor(white: 1, alpha: 0.3)
        return emojiBackground
    }()

    lazy var emoji: UILabel = {
        let emoji = UILabel()
        emoji.translatesAutoresizingMaskIntoConstraints = false
        emoji.font = .systemFont(ofSize: 16)

        return emoji
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
        upadateButtonState()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) hasn't implemented")
    }

    private func addSubviews() {
        contentView.addSubview(rectangleView)
        rectangleView.addSubview(name)
        rectangleView.addSubview(emojiBackground)
        emojiBackground.addSubview(emoji)
        contentView.addSubview(days)
        contentView.addSubview(counterButton)
    }

    private func constraintSubviews() {
        NSLayoutConstraint.activate([
            rectangleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rectangleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rectangleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rectangleView.heightAnchor.constraint(equalToConstant: 90),

            name.topAnchor.constraint(greaterThanOrEqualTo: emojiBackground.bottomAnchor, constant: 4),
            name.bottomAnchor.constraint(equalTo: rectangleView.bottomAnchor, constant: -12),
            name.leadingAnchor.constraint(equalTo: rectangleView.leadingAnchor, constant: 12),
            name.trailingAnchor.constraint(equalTo: rectangleView.trailingAnchor, constant: -12),

            emojiBackground.heightAnchor.constraint(equalToConstant: 30),
            emojiBackground.widthAnchor.constraint(equalToConstant: 30),
            emojiBackground.topAnchor.constraint(equalTo: rectangleView.topAnchor, constant: 12),
            emojiBackground.leadingAnchor.constraint(equalTo: rectangleView.leadingAnchor, constant: 12),

            emoji.centerXAnchor.constraint(equalTo: emojiBackground.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: emojiBackground.centerYAnchor),

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
        if comletedTracker {
            daysCounter -= 1
        } else {
            daysCounter += 1
        }
        comletedTracker = !comletedTracker
        guard let tracker else { return }
        delegate?.didComlete(comletedTracker, tracker: tracker)
    }

    private func upadateButtonState() {
        switch comletedTracker {
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

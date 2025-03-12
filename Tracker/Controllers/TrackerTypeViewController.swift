//
//  TrackerTypeViewController.swift
//  Tracker
//
//  Created by alexander on 11.03.2025.
//

import UIKit

class TrackerTypeViewController: UIViewController, TrackerTypeViewControllerProtocol {
    var presenter: TrackerTypePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.topItem?.title = "Создание трекера"
        }
        view.backgroundColor = .ypWhite
        addSubViews()
        addHabbitButton.setTitle("Привычка", for: .normal)
        addUnregularEventButton.setTitle("Нерегулярное событие", for: .normal)
    }

    private lazy var addHabbitButton: UIButton = {
        let addHabbitButton = UIButton()
        addHabbitButton.layer.cornerRadius = 16
        addHabbitButton.backgroundColor = .ypBlack
        addHabbitButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addHabbitButton.setTitleColor(.ypWhite, for: .normal)
        addHabbitButton.addTarget(self, action: #selector(pushAddHabbitViewController), for: .touchUpInside)
        return addHabbitButton
    }()

    private lazy var addUnregularEventButton: UIButton = {
        let addUnregularEventButton = UIButton()
        addUnregularEventButton.layer.cornerRadius = 16
        addUnregularEventButton.backgroundColor = .ypBlack
        addUnregularEventButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addUnregularEventButton.setTitleColor(.ypWhite, for: .normal)
        addUnregularEventButton.addTarget(self, action: #selector(pushUnregularEventViewController), for: .touchUpInside)
        return addUnregularEventButton
    }()

    private lazy var buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView()
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.addArrangedSubview(addHabbitButton)
        buttonsStackView.addArrangedSubview(addUnregularEventButton)
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 16
        buttonsStackView.distribution = .fillEqually
        return buttonsStackView
    }()

    private func addSubViews() {
        view.addSubview(addHabbitButton)
        view.addSubview(addUnregularEventButton)
        view.addSubview(buttonsStackView)
        NSLayoutConstraint.activate([
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 136)
        ])
    }

    @objc
    private func pushAddHabbitViewController(sender: UIButton) {
        dismiss(animated: true) {
            self.presenter?.selectType(.Habbit)
        }
    }

    @objc
    private func pushUnregularEventViewController(sender: UIButton) {
        dismiss(animated: true) {
            self.presenter?.selectType(.UnregularEvent)
        }
    }
}

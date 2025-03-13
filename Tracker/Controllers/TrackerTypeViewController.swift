//
//  TrackerTypeViewController.swift
//  Tracker
//
//  Created by alexander on 11.03.2025.
//

import UIKit

final class TrackerTypeViewController: UIViewController, TrackerTypeViewControllerProtocol {
    var presenter: TrackerTypePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.topItem?.title = "Создание трекера"
        }
        view.backgroundColor = .ypWhite
        addSubViews()
        addHabitButton.setTitle("Привычка", for: .normal)
        addUnregularEventButton.setTitle("Нерегулярное событие", for: .normal)
    }
    
    private lazy var addHabitButton: UIButton = {
        let addHabitButton = UIButton()
        addHabitButton.layer.cornerRadius = 16
        addHabitButton.backgroundColor = .ypBlack
        addHabitButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addHabitButton.setTitleColor(.ypWhite, for: .normal)
        addHabitButton.addTarget(self, action: #selector(pushAddHabitViewController), for: .touchUpInside)
        return addHabitButton
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
        buttonsStackView.addArrangedSubview(addHabitButton)
        buttonsStackView.addArrangedSubview(addUnregularEventButton)
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 16
        buttonsStackView.distribution = .fillEqually
        return buttonsStackView
    }()
    
    private func addSubViews() {
        view.addSubview(addHabitButton)
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
    private func pushAddHabitViewController(sender: UIButton) {
        dismiss(animated: true) {
            self.presenter?.selectType(.Habit)
        }
    }
    
    @objc
    private func pushUnregularEventViewController(sender: UIButton) {
        dismiss(animated: true) {
            self.presenter?.selectType(.UnregularEvent)
        }
    }
}

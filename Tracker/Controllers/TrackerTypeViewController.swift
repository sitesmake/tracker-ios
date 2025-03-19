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
        addIrregularEventButton.setTitle("Нерегулярное событие", for: .normal)
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
    
    private lazy var addIrregularEventButton: UIButton = {
        let addIrregularEventButton = UIButton()
        addIrregularEventButton.layer.cornerRadius = 16
        addIrregularEventButton.backgroundColor = .ypBlack
        addIrregularEventButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addIrregularEventButton.setTitleColor(.ypWhite, for: .normal)
        addIrregularEventButton.addTarget(self, action: #selector(pushIrregularEventViewController), for: .touchUpInside)
        return addIrregularEventButton
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView()
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.addArrangedSubview(addHabitButton)
        buttonsStackView.addArrangedSubview(addIrregularEventButton)
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 16
        buttonsStackView.distribution = .fillEqually
        return buttonsStackView
    }()
    
    private func addSubViews() {
        view.addSubview(addHabitButton)
        view.addSubview(addIrregularEventButton)
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
            self.presenter?.selectType(.habit)
        }
    }
    
    @objc
    private func pushIrregularEventViewController(sender: UIButton) {
        dismiss(animated: true) {
            self.presenter?.selectType(.irregularEvent)
        }
    }
}

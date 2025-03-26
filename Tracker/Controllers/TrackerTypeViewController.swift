//
//  TrackerTypeViewController.swift
//  Tracker
//
//  Created by alexander on 11.03.2025.
//

import UIKit

final class TrackerTypeViewController: UIViewController, TrackerTypeViewControllerProtocol {
    var presenter: TrackerTypePresenterProtocol?
    
    private lazy var AddHabitButton: UIButton = {
        let AddHabitButton = UIButton()
        AddHabitButton.layer.cornerRadius = 16
        AddHabitButton.backgroundColor = .ypBlack
        AddHabitButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        AddHabitButton.setTitleColor(.ypWhite, for: .normal)
        AddHabitButton.addTarget(self, action: #selector(pushAddHabitViewController), for: .touchUpInside)
        return AddHabitButton
    }()
    
    private lazy var newIrregularEventButton: UIButton = {
        let newIrregularEventButton = UIButton()
        newIrregularEventButton.layer.cornerRadius = 16
        newIrregularEventButton.backgroundColor = .ypBlack
        newIrregularEventButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        newIrregularEventButton.setTitleColor(.ypWhite, for: .normal)
        newIrregularEventButton.addTarget(self, action: #selector(pushIrregularEventViewController), for: .touchUpInside)
        return newIrregularEventButton
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView()
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.addArrangedSubview(AddHabitButton)
        buttonsStackView.addArrangedSubview(newIrregularEventButton)
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 16
        buttonsStackView.distribution = .fillEqually
        return buttonsStackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTrackerTypeScreen()
    }
    
    private func setupTrackerTypeScreen() {
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        addSubViews()
        AddHabitButton.setTitle("Привычка", for: .normal)
        newIrregularEventButton.setTitle("Нерегулярное событие", for: .normal)
    }
    
    private func setupNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.topItem?.title = "Создание трекера"
        }
    }
    
    private func addSubViews() {
        view.addSubview(AddHabitButton)
        view.addSubview(newIrregularEventButton)
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

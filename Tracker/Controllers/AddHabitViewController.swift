//
//  AddHabitViewController.swift
//  Tracker
//
//  Created by alexander on 12.03.2025.
//

import UIKit

final class AddHabitViewController: UIViewController, AddHabitViewControllerProtocol {
    enum Constants {
        static let textFieldCellIdentifier = "TextFieldCell"
        static let planningCellIdentifier = "PlaningCell"
        static let iconCellIdentifier = "IconCell"
        static let colorCellIdentifier = "ColorCell"
    }
    
    enum Section: Int, CaseIterable {
        case textField
        case planning
        case icon
        case color
        
        enum Row {
            case textField
            case category
            case schedule
            case icon
            case color
        }
    }
    
    var presenter: AddHabitPresenterProtocol?
    
    private let icons: [String] = ["❤️", "😱", "😇", "😡", "🥶", "🤔", "🙂", "😻", "🌺", "🐶", "🙌", "🍔", "🥦", "🏓", "🏝️", "😪", "🥇", "🎸"]

    private let colors: [UIColor?] = [.ypColor1, .ypColor2, .ypColor3, .ypColor4, .ypColor5, .ypColor6, .ypColor7, .ypColor8, .ypColor9, .ypColor10, .ypColor11, .ypColor12, .ypColor13, .ypColor14, .ypColor15, .ypColor16, .ypColor17, .ypColor18]

    private lazy var tableView: UITableView = {
        let planningTableView = UITableView(frame: .zero, style: .insetGrouped)
        planningTableView.translatesAutoresizingMaskIntoConstraints = false
        planningTableView.separatorStyle = .singleLine
        planningTableView.contentInsetAdjustmentBehavior = .never
        planningTableView.backgroundColor = .ypWhite
        planningTableView.isScrollEnabled = true
        planningTableView.showsVerticalScrollIndicator = false
        planningTableView.dataSource = self
        planningTableView.delegate = self
        planningTableView.allowsSelection = true
        return planningTableView
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.backgroundColor = .ypWhite
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelHabitCreation), for: .touchUpInside)
        return cancelButton
    }()
    
    private lazy var createButton: UIButton = {
        let createButton = UIButton()
        createButton.layer.cornerRadius = 16
        createButton.backgroundColor = .ypBlack
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        createButton.setTitleColor(.ypWhite, for: .normal)
        createButton.addTarget(self, action: #selector(createHabit), for: .touchUpInside)
        return createButton
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView()
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(createButton)
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 8
        buttonsStackView.distribution = .fillEqually
        return buttonsStackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddHabitScreen()
        tableView.reloadData()
    }
    
    private func setupAddHabitScreen() {
        self.hideKeyboardOnTap()
        view.backgroundColor = .ypWhite
        addSubViews()
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: Constants.textFieldCellIdentifier)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: Constants.planningCellIdentifier)
        tableView.register(CollectionCell.self, forCellReuseIdentifier: Constants.iconCellIdentifier)
        tableView.register(CollectionCell.self, forCellReuseIdentifier: Constants.colorCellIdentifier)
        
        setupNavigationBar()
        
        cancelButton.setTitle("Отменить", for: .normal)
        createButton.setTitle("Создать", for: .normal)
        updateButtonState()
    }
    
    private func setupNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.topItem?.title = presenter?.pageTitle
        }
    }
    
    private func addSubViews() {
        view.addSubview(tableView)
        view.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func rowsForSection(_ type: Section) -> [Section.Row] {
        switch type {
        case .textField:
            return [.textField]
        case .planning:
            switch presenter?.type {
            case .habit:
                return [.category, .schedule]
            case .irregularEvent:
                return [.category]
            case .none:
                return []
            }
        case .icon:
            return [.icon]
        case .color:
            return [.color]
        }
    }
    
    private func textFieldCell(at indexPath: IndexPath, placeholder: String) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.textFieldCellIdentifier) as? TextFieldCell else {
            return UITableViewCell()
        }
        cell.placeholder = placeholder
        cell.delegate = self
        return cell
    }
    
    private func planningCell(at indexPath: IndexPath, title: String, subtitle: String?) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.planningCellIdentifier) as? TableViewCell else { return UITableViewCell() }
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    private func iconCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.iconCellIdentifier) as? CollectionCell else { return UITableViewCell() }
        cell.delegate = self
        cell.type = .icon(items: icons)
        return cell
    }
    
    private func colorCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.colorCellIdentifier) as? CollectionCell else { return UITableViewCell() }
        cell.delegate = self
        cell.type = .color(items: colors)
        return cell
    }
    
    private func showTimeTable() {
        let vc = TimetableViewController()
        let presenter = TimetablePresenter(view: vc, selected: presenter?.schedule ?? [], delegate: self)
        vc.presenter = presenter
        presenter.view = vc
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .coverVertical
        vc.isModalInPresentation = true
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true)
    }
    
    private func showCategory() {
    }
    
    private func updateButtonState() {
        createButton.isEnabled = presenter?.isValidForm ?? false
        createButton.backgroundColor = createButton.isEnabled ? .ypBlack : .ypGray
    }
    
    @objc
    private func cancelHabitCreation() {
        dismiss(animated: true)
    }
    
    @objc
    private func createHabit() {
        presenter?.createNewTracker()
        dismiss(animated: true)
    }
}

extension AddHabitViewController: TimetableDelegate {
    func didSelect(weekdays: [Int]) {
        presenter?.schedule = weekdays
        updateButtonState()
        let section = Section.planning
        if let row = rowsForSection(section).firstIndex(of: Section.Row.schedule) {
            tableView.reloadRows(at: [IndexPath(row: row, section: section.rawValue)], with: .none)
        }
    }
}

extension AddHabitViewController: TextFieldCellDelegate {
    func didTextChange(text: String?) {
        presenter?.trackerName = text
        updateButtonState()
    }
}

extension AddHabitViewController: CollectionCellDelegate {
    func didIconSet(icon: String?) {
        presenter?.icon = icon
        updateButtonState()
    }
    
    func didColorSet(color: UIColor?) {
        presenter?.color = color
        updateButtonState()
    }
}

extension AddHabitViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        return rowsForSection(section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        switch rowsForSection(section)[indexPath.row] {
            
        case .textField:
            return textFieldCell(at: indexPath, placeholder: "Введите название трекера")
        case .category:
            return planningCell(at: indexPath, title: "Категория", subtitle: presenter?.selectedCategory)
        case .schedule:
            return planningCell(at: indexPath, title: "Расписание", subtitle: presenter?.scheduleString)
        case .icon:
            return iconCell(at: indexPath)
        case .color:
            return colorCell(at: indexPath)
        }
    }
}

extension AddHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch rowsForSection(section)[indexPath.row] {
        case .category:
            showCategory()
        case .schedule:
            showTimeTable()
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else { return 0 }
        switch rowsForSection(section)[indexPath.row] {
            
        case .textField, .category, .schedule:
            return 75
        case .icon, .color:
            return UITableView.automaticDimension
        }
    }
}

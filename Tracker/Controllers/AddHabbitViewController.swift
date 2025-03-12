//
//  AddHabbitViewController.swift
//  Tracker
//
//  Created by alexander on 12.03.2025.
//

import UIKit

class AddHabbitViewController: UIViewController, AddHabbitViewControllerProtocol, TextFieldCellDelegate, TimetableDelegate {
    var presenter: AddHabbitPresenterProtocol?

    enum Constant {
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

    private func rowsForSection(_ type: Section) -> [Section.Row] {
        switch type {
        case .textField:
            return [.textField]
        case .planning:
            switch presenter?.type {
            case .Habbit:
                return [.category, .schedule]
            case .UnregularEvent:
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

    private lazy var tableView: UITableView = {
        let planningTableView = UITableView(frame: .zero, style: .insetGrouped)
        planningTableView.translatesAutoresizingMaskIntoConstraints = false
        planningTableView.separatorStyle = .singleLine
        planningTableView.contentInsetAdjustmentBehavior = .never
        planningTableView.backgroundColor = .ypWhite
        planningTableView.isScrollEnabled = false
        planningTableView.dataSource = self
        planningTableView.delegate = self
        planningTableView.allowsSelection = true
        return planningTableView
    }()

    private lazy var iconLabel: UILabel = {
        let iconLabel = UILabel()
        view.addSubview(iconLabel)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            iconLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
        ])
        iconLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return iconLabel
    }()

    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(named: "ypRed")?.cgColor
        cancelButton.backgroundColor = .ypWhite
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelHabbitCreation), for: .touchUpInside)
        return cancelButton
    }()

    private lazy var createButton: UIButton = {
        let createButton = UIButton()
        createButton.layer.cornerRadius = 16
        createButton.backgroundColor = .ypBlack
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        createButton.setTitleColor(.ypWhite, for: .normal)
        createButton.addTarget(self, action: #selector(createHabbit), for: .touchUpInside)
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
        setupNewHabbitScreen()
    }

    private func setupNewHabbitScreen() {
        self.hideKeyboardOnTap()
        view.backgroundColor = .ypWhite
        addSubViews()
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: Constant.textFieldCellIdentifier)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: Constant.planningCellIdentifier)

        setupNavigationBar()

        cancelButton.setTitle("Отменить", for: .normal)
        createButton.setTitle("Создать", for: .normal)
        updateButtonState()
    }

    private func setupNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.topItem?.title = "Новая привычка"
        }
    }

    private func addSubViews() {
        view.addSubview(tableView)
        view.addSubview(buttonsStackView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
        ])
    }

    @objc
    private func cancelHabbitCreation() {
        dismiss(animated: true)
    }

    @objc
    private func createHabbit() {
        presenter?.createNewTracker()
        dismiss(animated: true)
    }

    private func textFieldCell(at indexPath: IndexPath, placeholder: String) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.textFieldCellIdentifier) as? TextFieldCell else {
            return UITableViewCell()
        }
        cell.placeholder = placeholder
        cell.delegate = self
        return cell
    }

    private func planningCell(at indexPath: IndexPath, title: String, subtitle: String?) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.planningCellIdentifier) as? TableViewCell else { return UITableViewCell() }
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    private func iconCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.iconCellIdentifier) else { return UITableViewCell() }
        return cell
    }

    private func colorCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.colorCellIdentifier) else { return UITableViewCell() }
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

    // MARK: - TimetableDelegate

    func didSelect(weekdays: [Int]) {
        presenter?.schedule = weekdays
        updateButtonState()
        tableView.reloadData()
    }

    // MARK: - TextFieldCellDelegate

    func didTextChange(text: String?) {
        presenter?.trackerTitle = text
        updateButtonState()
    }

}

extension AddHabbitViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count - 2
        // спрятал ненужные для 14 спринта секции
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
            return planningCell(at: indexPath, title: "Категория", subtitle: presenter?.selectedCategory?.title)
        case .schedule:
            return planningCell(at: indexPath, title: "Расписание", subtitle: presenter?.schedule.map{ DaysFormatter.shortWeekday(at: $0)}.joined(separator: ", "))
        case .icon:
            return iconCell(at: indexPath)
        case .color:
            return colorCell(at: indexPath)
        }
    }
}

extension AddHabbitViewController: UITableViewDelegate {

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
        75
    }
}


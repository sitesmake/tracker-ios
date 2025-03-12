//
//  TimetableViewController.swift
//  Tracker
//
//  Created by alexander on 12.03.2025.
//

import UIKit

class TimetableViewController: UIViewController, TimetableViewControllerProtocol {
    var presenter: TimetablePresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.topItem?.title = "Новая привычка"
        }
        view.backgroundColor = .ypWhite
        addSubViews()
        readyButton.setTitle("Готово", for: .normal)
    }

    private func addSubViews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: readyButton.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private lazy var tableView: UITableView = {
        var timetable = UITableView(frame: .zero, style: .insetGrouped)
        timetable.separatorStyle = .singleLine
        timetable.contentInsetAdjustmentBehavior = .never
        timetable.backgroundColor = .ypWhite
        timetable.isScrollEnabled = true
        timetable.dataSource = self
        timetable.delegate = self
        timetable.alwaysBounceVertical = false
        timetable.allowsSelection = false
        timetable.register(TableViewCell.self, forCellReuseIdentifier: "TimetableCell")
        return timetable
    }()

    private lazy var readyButton: UIButton = {
        let readyButton = UIButton()
        view.addSubview(readyButton)
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            readyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            readyButton.heightAnchor.constraint(equalToConstant: 60)

        ])
        readyButton.layer.cornerRadius = 16
        readyButton.backgroundColor = .ypBlack
        readyButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        readyButton.setTitleColor(.ypWhite, for: .normal)
        readyButton.addTarget(self, action: #selector(setTimetable), for: .touchUpInside)
        return readyButton
    }()

    @objc
    private func setTimetable() {
        dismiss(animated: true)
        presenter?.done()
    }

    @objc
    private func didChangeSwitch(_ sender: UISwitch) {
        guard var presenter else { return }

        if sender.isOn {
            presenter.selectedWeekdays.append(sender.tag)
        } else if let index = presenter.selectedWeekdays.firstIndex(of: sender.tag) {
            presenter.selectedWeekdays.remove(at: index)
        }
    }
}

extension TimetableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.weekdays.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimetableCell") as? TableViewCell,
              let presenter
        else { return UITableViewCell() }

        let day = presenter.weekdays[indexPath.row]

        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .ypBackground
        cell.textLabel?.text = day.capitalized

        let weekdaySwitch = UISwitch()
        weekdaySwitch.isOn = presenter.selectedWeekdays.contains(indexPath.row)
        cell.accessoryView = weekdaySwitch
        weekdaySwitch.onTintColor = .ypBlue
        weekdaySwitch.tag = indexPath.row
        weekdaySwitch.addTarget(self, action: #selector(didChangeSwitch), for: .touchUpInside)

        return cell
    }
}

extension TimetableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

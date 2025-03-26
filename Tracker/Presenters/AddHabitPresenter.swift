//
//  AddHabitPresenter.swift
//  Tracker
//
//  Created by alexander on 12.03.2025.
//

import UIKit

final class AddHabitPresenter: AddHabitPresenterProtocol {
    weak var delegate: AddHabitDelegate?
    var trackerName: String?
    var subtitleForCategory: String = ""
    var selectedCategory: String?
    var icon: String?
    var color: UIColor?
    var type: TrackerType
    var schedule: [Int] = []

    var isValidForm: Bool {
        switch type {
        case .habit:
            return selectedCategory != nil && trackerName != nil && !schedule.isEmpty && icon != nil && color != nil
        case .irregularEvent:
            return selectedCategory != nil && trackerName != nil && icon != nil && color != nil
        }
    }

    var scheduleString: String {
        if schedule.count == DaysFormatter.weekdays.count {
            return "Каждый день"
        } else {
            return schedule.map { DaysFormatter.shortWeekday(at: $0)}.joined(separator: ", ")
        }
    }

    var pageTitle: String {
        switch type {
        case .habit:
            return "Новая привычка"
        case .irregularEvent:
            return "Новое нерегулярное событие"
        }
    }

    weak var view: AddHabitViewControllerProtocol?

    private var categories: [String]

    init(type: TrackerType, categories: [String]) {
        self.type = type
        self.selectedCategory = categories.first
        self.categories = categories
    }

    func createNewTracker() {
        guard let name = trackerName,
              let selectedCategory,
              let icon,
              let color
        else { return }
        let newTracker = Tracker(id: UUID(), name: name, color: color, icon: icon, schedule: schedule)
        delegate?.didCreateTracker(newTracker, at: selectedCategory)
    }
}

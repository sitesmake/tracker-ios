//
//  AddHabitPresenter.swift
//  Tracker
//
//  Created by alexander on 12.03.2025.
//

import UIKit

final class AddHabitPresenter: AddHabitPresenterProtocol {
    var delegate: AddHabitDelegate?
    var trackerTitle: String?
    var subtitleForCategory: String = ""
    var categories: [TrackerCategory]
    var selectedCategory: TrackerCategory?
    var view: AddHabitViewControllerProtocol?
    var type: TrackerType
    var schedule: [Int] = []
    var isValidForm: Bool {
        selectedCategory != nil && trackerTitle != nil && !schedule.isEmpty
    }

    init(type: TrackerType, categories: [TrackerCategory]) {
        self.type = type
        self.selectedCategory = categories.first
        self.categories = categories
    }

    func createNewTracker() {
        guard let title = trackerTitle,
              let selectedCategory
        else { return }
        let newTracker = Tracker(id: UUID(), title: title, color: .ypColor1, icon: "🌺", schedule: schedule)
        delegate?.didCreateTracker(newTracker, at: selectedCategory)
    }
}

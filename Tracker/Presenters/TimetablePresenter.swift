//
//  TimetablePresenter.swift
//  Tracker
//
//  Created by alexander on 12.03.2025.
//

import Foundation

class TimetablePresenter: TimetablePresenterProtocol {
    var view: TimetableViewControllerProtocol
    var delegate: TimetableDelegate
    var selectedWeekdays: [Int]
    let weekdays = DaysFormatter.weekdays

    init(view: TimetableViewControllerProtocol, selected: [Int], delegate: TimetableDelegate) {
        self.view = view
        self.delegate = delegate
        self.selectedWeekdays = selected
    }

    func done() {
        delegate.didSelect(weekdays: selectedWeekdays)
        print(selectedWeekdays)
    }
}


//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by alexander on 09.03.2025.
//

import UIKit

final class TrackersPresenter: TrackersPresenterProtocol {
    func addTracker(_ tracker: Tracker, at category: TrackerCategory) {
        service.addTracker(tracker, at: category)
        setupCategories()
    }
    
    private let service = TrackerService()
    weak var view: TrackersViewControllerProtocol?
    var categories: [TrackerCategory] = []
    var currentDate: Date = Calendar.current.startOfDay(for: Date()) {
        didSet {
            setupCategories()
        }
    }
    var search: String = "" {
        didSet {
            setupCategories()
        }
    }
    
    func setupCategories() {
        categories = service.getCategoriesFor(date: currentDate, search: search)
    }
    
    func completeTracker(_ complete: Bool, tracker: Tracker) {
        if complete {
            service.changeCompletedTrackers(tracker: tracker, date: currentDate, complete: complete)
        } else {
            service.changeCompletedTrackers(tracker: tracker, date: currentDate, complete: complete)
        }
    }
    
    func isCompletedTracker(_ tracker: Tracker) -> Bool {
        service.completedTrackers.first(where: { $0.id == tracker.id && $0.date == currentDate }) != nil
    }
    
    func countRecordsTracker(_ tracker: Tracker) -> Int {
        service.completedTrackers.filter { $0.id == tracker.id }.count
    }
    
    func canBeChanged() -> Bool {
        currentDate <= Calendar.current.startOfDay(for: Date())
    }
}

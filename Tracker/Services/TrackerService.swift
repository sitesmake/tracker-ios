//
//  TrackerService.swift
//  Tracker
//
//  Created by alexander on 11.03.2025.
//

import Foundation

final class TrackerService: TrackerServiceProtocol {
    var categories: [TrackerCategory] = []
    var visibleCategories: [TrackerCategory] = []
    var completedTrackers: Set<TrackerRecord> = []

    init() {
        let tracker = Tracker(id: UUID(), title: "Демо трекер 1", color: .ypColor1, icon: "🌺", schedule: [2])
        let category = TrackerCategory(title: "Демо категория 1", trackers: [tracker])
        categories.append(category)
    }

    func addTracker(_ tracker: Tracker, at category: TrackerCategory) {
        var trackers = category.trackers
        trackers.append(tracker)
        let newCategory = TrackerCategory(title: category.title, trackers: trackers)
        var categories = self.categories
        if let index = categories.firstIndex(where: { $0.title == category.title } ) {
            categories[index] = newCategory
        } else {
            categories.append(newCategory)
        }
        self.categories = categories
    }

    func getCategoriesFor(date: Date, search: String) -> [TrackerCategory] {
        let weekday = Calendar.current.component(.weekday, from: date) - 1
        
        var result: [TrackerCategory] = []
        
        for category in categories {
            let trackers = search.isEmpty ? category.trackers.filter({ $0.schedule.contains(weekday) }) : category.trackers.filter({ $0.schedule.contains(weekday) && $0.title.contains(search) })
            if !trackers.isEmpty {
                let newCategory = TrackerCategory(title: category.title, trackers: trackers)
                result.append(newCategory)
            }
        }
        
        return result
    }

    func addToCompletedTrackers(tracker: Tracker, date: Date) {
        var completedTrackers = self.completedTrackers
        let trackerToRecord = TrackerRecord(id: tracker.id, date: date)
        completedTrackers.insert(trackerToRecord)
        self.completedTrackers = completedTrackers

    }

    func removeFromCompletedTrackers(tracker: Tracker, date: Date) {
        var completedTrackers = self.completedTrackers
        let trackerToRemove = TrackerRecord(id: tracker.id, date: date)
        completedTrackers.remove(trackerToRemove)
        self.completedTrackers = completedTrackers
    }
}

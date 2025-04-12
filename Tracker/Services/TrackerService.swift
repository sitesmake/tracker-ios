final class TrackerService: TrackerServiceProtocol {
    private let trackerStore: TrackerStoreProtocol
    private let categoryStore: TrackerCategoryStoreProtocol
    private let recordStore: TrackerRecordStoreProtocol

    init(trackerStore: TrackerStoreProtocol, categoryStore: TrackerCategoryStoreProtocol, recordStore: TrackerRecordStoreProtocol) {
        self.trackerStore = trackerStore
        self.categoryStore = categoryStore
        self.recordStore = recordStore
    }

    var numberOfSections: Int {
        return categoryStore.getCategoryNames().count
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        let categoryNames = categoryStore.getCategoryNames()
        let categoryName = categoryNames[section]
        guard let category = categoryStore.getCategoryWithName(categoryName) else { return 0 }
        return trackerStore.getTrackersInCategory(category).count
    }

    func tracker(at indexPath: IndexPath) -> Tracker {
        let categoryNames = categoryStore.getCategoryNames()
        let categoryName = categoryNames[indexPath.section]
        guard let category = categoryStore.getCategoryWithName(categoryName) else { fatalError("Category not found") }
        let trackers = trackerStore.getTrackersInCategory(category)
        return trackers[indexPath.row]
    }

    func categoryName(at section: Int) -> String {
        let categoryNames = categoryStore.getCategoryNames()
        return categoryNames[section]
    }

    func addTracker(_ tracker: Tracker, at category: String) throws {
        guard let categoryData = categoryStore.getCategoryWithName(category) else {
            throw TrackerServiceError.categoryNotFound
        }
        try trackerStore.addNewTracker(tracker, at: categoryData)
    }

    func deleteTracker(at indexPath: IndexPath) throws {
        let categoryNames = categoryStore.getCategoryNames()
        let categoryName = categoryNames[indexPath.section]
        guard let category = categoryStore.getCategoryWithName(categoryName) else { return }

        let trackers = trackerStore.getTrackersInCategory(category)
        let trackerToDelete = trackers[indexPath.row]

        // Deleting tracker involves deleting associated records too
        try recordStore.deleteTrackerRecord(trackerToDelete, date: Date())
    }
}

enum TrackerServiceError: Error {
    case categoryNotFound
}

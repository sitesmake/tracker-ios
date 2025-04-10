import Foundation

final class TrackerService: NSObject {
    weak var delegate: TrackerServiceDelegate?

    private var trackerStore: TrackerStore?
    private var trackerCategoryStore: TrackerCategoryStore?
    private var trackerRecordStore: TrackerRecordStore?

    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?

    override init() {
        super.init()
        let context = CoreDataStack.shared.viewContext
        self.trackerStore = TrackerStore(context: context)
        self.trackerCategoryStore = TrackerCategoryStore(context: context)
        self.trackerRecordStore = TrackerRecordStore(context: context)
        addTestCategory()
    }

    func updatePredicate(search: String, date: Date) {
    }

    func getAllCategories() -> [String] {
        trackerCategoryStore?.getCategoryNames() ?? []
    }

    func getTrackerRecord(tracker: Tracker, date: Date) -> TrackerRecord? {
        trackerRecordStore?.getTrackerRecordFromCoreData(tracker: tracker, date: date)
    }

    func getTrackersNumber(tracker: Tracker) -> Int {
        trackerRecordStore?.getTrackerRecordsNumber(tracker: tracker) ?? 0
    }

    func addToCompletedTrackers(tracker: Tracker, date: Date) throws {
        try trackerRecordStore?.addNewTrackerRecord(tracker, date: date)
    }

    func removeFromCompletedTrackers(tracker: Tracker, date: Date) throws {
        try trackerRecordStore?.deleteTrackerRecord(tracker, date: date)
    }

    private func addTestCategory() {
        // Add test categories if needed for testing purposes
        if trackerCategoryStore?.getCategoryNames().isEmpty ?? true {
            do {
                try trackerCategoryStore?.addCategory(name: "test")
                try trackerCategoryStore?.addCategory(name: "test2")
                let tracker1 = Tracker(id: UUID(), name: "Flowers", color: .ypColor5, icon: "🌺", schedule: [2])
                try addTracker(tracker1, at: "test")
                let tracker2 = Tracker(id: UUID(), name: "Dog", color: .ypColor10, icon: "🐶", schedule: [0, 1, 2, 3, 4, 5, 6])
                try addTracker(tracker2, at: "test2")
            } catch {
                print("Failed to add test categories or trackers.")
            }
        }
    }
}

extension TrackerService: TrackerServiceProtocol {
    var numberOfSections: Int {
        return trackerCategoryStore?.getCategoryNames().count ?? 0
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        let categories = trackerCategoryStore?.getCategoryNames() ?? []
        if section < categories.count {
            let category = categories[section]
            return trackerStore?.getTrackersInCategory(category).count ?? 0
        }
        return 0
    }

    func tracker(at indexPath: IndexPath) -> Tracker {
        let categories = trackerCategoryStore?.getCategoryNames() ?? []
        if indexPath.section < categories.count {
            let category = categories[indexPath.section]
            let trackers = trackerStore?.getTrackersInCategory(category) ?? []
            return trackers[indexPath.row]
        }
        return Tracker(id: UUID(), name: "test", color: .gray, icon: "", schedule: [])
    }

    func categoryName(at section: Int) -> String {
        let categories = trackerCategoryStore?.getCategoryNames() ?? []
        return categories[section]
    }

    func addTracker(_ tracker: Tracker, at category: String) throws {
        if let categoryCoreData = trackerCategoryStore?.getCategoryWithName(category) {
            try trackerStore?.addNewTracker(tracker, at: categoryCoreData)
        }
    }

    func deleteTracker(at indexPath: IndexPath) throws {
        // Implement delete tracker functionality when needed
    }
}

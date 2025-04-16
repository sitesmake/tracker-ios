import Foundation

final class TrackerStore: TrackerStoreProtocol {
    private let trackerDataSource: TrackerDataSourceProtocol

    init(trackerDataSource: TrackerDataSourceProtocol) {
        self.trackerDataSource = trackerDataSource
    }

    func getTrackersInCategory(_ category: TrackerCategory) -> [Tracker] {
        return trackerDataSource.getTrackersInCategory(category)
    }

    func addNewTracker(_ tracker: Tracker, at category: TrackerCategory) throws {
        try trackerDataSource.addNewTracker(tracker, at: category)
    }
}

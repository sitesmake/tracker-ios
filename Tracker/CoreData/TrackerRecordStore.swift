import Foundation

final class TrackerRecordStore: TrackerRecordStoreProtocol {
    private let recordDataSource: TrackerRecordDataSourceProtocol

    init(recordDataSource: TrackerRecordDataSourceProtocol) {
        self.recordDataSource = recordDataSource
    }

    func getTrackerRecord(tracker: Tracker, date: Date) -> TrackerRecord? {
        return recordDataSource.getTrackerRecord(tracker: tracker, date: date)
    }

    func getTrackerRecordsNumber(tracker: Tracker) -> Int {
        return recordDataSource.getTrackerRecordsNumber(tracker: tracker)
    }

    func addNewTrackerRecord(_ tracker: Tracker, date: Date) throws {
        try recordDataSource.addNewTrackerRecord(tracker, date: date)
    }

    func deleteTrackerRecord(_ tracker: Tracker, date: Date) throws {
        try recordDataSource.deleteTrackerRecord(tracker, date: date)
    }
}

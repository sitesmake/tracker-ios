import Foundation
import CoreData

final class TrackerRecordStore: TrackerRecordStoreProtocol {
    private let context: NSManagedObjectContext
    private let colorMarshaling = ColorMarshaling()
    private let scheduleConverter = ScheduleConverter()

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func getTrackerRecordFromCoreData(tracker: Tracker, date: Date) -> TrackerRecord? {
        guard let date = date.onlyDate else { return nil }
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.tracker.trackerId), tracker.id.uuidString)
        let datePredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.date), date as NSDate)
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [idPredicate, datePredicate])

        do {
            guard let existingTrackerRecord = try context.fetch(request).first else { return nil }
            return TrackerRecord(id: existingTrackerRecord.tracker.trackerId, date: date)
        } catch {
            print("Error fetching tracker record: \(error.localizedDescription)")
        }
        return nil
    }

    func getTrackerRecordsNumber(tracker: Tracker) -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.resultType = .countResultType
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.tracker.trackerId), tracker.id.uuidString)
        request.predicate = idPredicate
        do {
            return try context.count(for: request)
        } catch {
            print("Error fetching tracker record number: \(error.localizedDescription)")
        }
        return 0
    }

    func addNewTrackerRecord(_ tracker: Tracker, date: Date) throws {
        guard let date = date.onlyDate else { return }
        let newTrackerRecord = TrackerRecordCoreData(context: context)
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.trackerId), tracker.id.uuidString)
        request.predicate = idPredicate
        if let existingTracker = try? context.fetch(request).first {
            newTrackerRecord.tracker = existingTracker
            newTrackerRecord.date = date
        }
        try context.save()
    }

    func deleteTrackerRecord(_ tracker: Tracker, date: Date) throws {
        guard let date = date.onlyDate else { return }
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.tracker.trackerId), tracker.id.uuidString)
        let datePredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.date), date as NSDate)
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [idPredicate, datePredicate])

        if let existingTracker = try? context.fetch(request).first {
            context.delete(existingTracker)
            try context.save()
        }
    }
}

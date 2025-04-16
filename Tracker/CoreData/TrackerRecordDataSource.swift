import CoreData

final class TrackerRecordDataSource: TrackerRecordDataSourceProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func getTrackerRecord(tracker: Tracker, date: Date) -> TrackerRecord? {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "tracker.id == %@ AND date == %@", tracker.id as CVarArg, date as CVarArg)

        do {
            let results = try context.fetch(request)
            return results.first.map { TrackerRecord(id: $0.id, date: $0.date) }
        } catch {
            return nil
        }
    }

    func getTrackerRecordsNumber(tracker: Tracker) -> Int {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "tracker.id == %@", tracker.id as CVarArg)

        do {
            let results = try context.fetch(request)
            return results.count
        } catch {
            return 0
        }
    }

    func addNewTrackerRecord(_ tracker: Tracker, date: Date) throws {
        let record = TrackerRecordCoreData(context: context)
        record.date = date

        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)

        let existingTrackers = try context.fetch(request)

        if let existingTracker = existingTrackers.first {
            record.tracker = existingTracker
        } else {
            let newTracker = TrackerCoreData(context: context)
            newTracker.id = tracker.id
            record.tracker = newTracker
        }

        try context.save()
    }

    func deleteTrackerRecord(_ tracker: Tracker, date: Date) throws {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "tracker.id == %@ AND date == %@", tracker.id as CVarArg, date as CVarArg)

        do {
            if let recordToDelete = try context.fetch(request).first {
                context.delete(recordToDelete)
                try context.save()
            }
        } catch {
            throw error
        }
    }
}

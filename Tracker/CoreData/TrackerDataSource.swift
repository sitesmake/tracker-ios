import CoreData

final class TrackerDataSource: TrackerDataSourceProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func getTrackersInCategory(_ category: TrackerCategory) -> [Tracker] {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        // Add filtering by category if needed
        do {
            let results = try context.fetch(request)
            return results.map { Tracker(id: $0.id, name: $0.name, color: $0.color, icon: $0.icon, schedule: $0.schedule) }
        } catch {
            return []
        }
    }

    func addNewTracker(_ tracker: Tracker, at category: TrackerCategory) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = tracker.color
        trackerCoreData.icon = tracker.icon
        trackerCoreData.schedule = tracker.schedule
        try context.save()
    }
}

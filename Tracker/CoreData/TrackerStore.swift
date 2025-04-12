import Foundation
import CoreData

final class TrackerStore: TrackerStoreProtocol {
    private let colorMarshaling = ColorMarshaling()
    private let scheduleConverter = ScheduleConverter()
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func getTrackerFromCoreData(from trackerCoreData: TrackerCoreData) -> Tracker {
        return Tracker(id: trackerCoreData.trackerId,
                       name: trackerCoreData.name,
                       color: colorMarshaling.color(from: trackerCoreData.color),
                       icon: trackerCoreData.icon,
                       schedule: scheduleConverter.convertToArray(string: trackerCoreData.schedule))
    }

    func addNewTracker(_ tracker: Tracker, at category: TrackerCategoryCoreData) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        updateTrackers(trackerCoreData, tracker)
        trackerCoreData.category = category
        try context.save()
    }

    private func updateTrackers(_ trackerCoreData: TrackerCoreData, _ tracker: Tracker) {
        trackerCoreData.trackerId = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = colorMarshaling.hexString(from: tracker.color)
        trackerCoreData.icon = tracker.icon
        trackerCoreData.schedule = scheduleConverter.convertToString(array: tracker.schedule)
    }

    func getTrackersInCategory(_ category: String) -> [Tracker] {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        let categoryPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.category.name), category)
        request.predicate = categoryPredicate

        do {
            let results = try context.fetch(request)
            return results.map { getTrackerFromCoreData(from: $0) }
        } catch {
            return []
        }
    }

}

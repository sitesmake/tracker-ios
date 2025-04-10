import Foundation
import CoreData

class TrackerCategoryStore: TrackerCategoryStoreProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func getCategoryNames() -> [String] {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.propertiesToFetch = ["name"]
        let categoryNames = try? context.fetch(request)
        return categoryNames?.map { $0.name } ?? []
    }

    func getCategoryWithName(_ name: String) -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let namePredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.name), name)
        request.predicate = namePredicate
        return try? context.fetch(request).first
    }

    func addCategory(name: String) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.name = name
        trackerCategoryCoreData.trackers = []
        try context.save()
    }
}

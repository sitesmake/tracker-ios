import CoreData

final class TrackerCategoryDataSource: TrackerCategoryDataSourceProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func getCategoryNames() -> [String] {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results.map { $0.name }
        } catch {
            return []
        }
    }

    func getCategoryWithName(_ name: String) -> TrackerCategory? {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        do {
            let results = try context.fetch(request)
            guard let category = results.first else { return nil }
            return TrackerCategory(name: category.name, trackers: [])
        } catch {
            return nil
        }
    }

    func addCategory(name: String) throws {
        let category = TrackerCategoryCoreData(context: context)
        category.name = name
        try context.save()
    }
}

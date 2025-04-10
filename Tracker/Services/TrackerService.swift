import Foundation
import CoreData

final class TrackerService: NSObject {
    weak var delegate: TrackerServiceDelegate?

    private var trackerStore: TrackerStore?
    private var trackerCategoryStore: TrackerCategoryStore?
    private var trackerRecordStore: TrackerRecordStore?

    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Error in loading CoreData persistent store: \(error.localizedDescription)")
            }
        }
        return container
    }()

    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.name, ascending: true)
        ]

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: "category.name", cacheName: nil)
        controller.delegate = self
        try? controller.performFetch()
        return controller
    }()

    override init() {
        super.init()
        self.trackerStore = TrackerStore(context: persistentContainer.viewContext)
        self.trackerCategoryStore = TrackerCategoryStore(context: persistentContainer.viewContext)
        self.trackerRecordStore = TrackerRecordStore(context: persistentContainer.viewContext)
        addTestCategory()
    }

    func updatePredicate(search: String, date: Date) {
        let weekday = String(date.weekdayIndex)
        let namePredicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(TrackerCoreData.name), search)
        let datePredicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(TrackerCoreData.schedule), weekday)

        if date.onlyDate == Date().onlyDate {
            if search.count != 0 {
                fetchedResultsController.fetchRequest.predicate = namePredicate
            } else {
                fetchedResultsController.fetchRequest.predicate = NSPredicate(value: true)
            }
        } else {
            if search.count != 0 {
                fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [namePredicate, datePredicate])
            } else {
                fetchedResultsController.fetchRequest.predicate = datePredicate
            }
        }
        try? fetchedResultsController.performFetch()
    }

    func getAllCategories() -> [String] {
        return trackerCategoryStore?.getCategoryNames() ?? []
    }

    func getTrackerRecord(tracker: Tracker, date: Date) -> TrackerRecord? {
        return trackerRecordStore?.getTrackerRecordFromCoreData(tracker: tracker, date: date)
    }

    func getTrackersNumber(tracker: Tracker) -> Int {
        return trackerRecordStore?.getTrackerRecordsNumber(tracker: tracker) ?? 0
    }

    func addToCompletedTrackers(tracker: Tracker, date: Date) throws {
        try trackerRecordStore?.addNewTrackerRecord(tracker, date: date)
    }

    func removeFromCompletedTrackers(tracker: Tracker, date: Date) throws {
        try trackerRecordStore?.deleteTrackerRecord(tracker, date: date)
    }

    private func addTestCategory() {
        if fetchedResultsController.sections?.count ?? 0 == 0 {
            do {
                try trackerCategoryStore?.addCategory(name: "test")
                try trackerCategoryStore?.addCategory(name: "test2")
                let tracker1 = Tracker(id: UUID(), name: "Flowers", color: .ypColor5, icon: "🌺", schedule: [2])
                try addTracker(tracker1, at: "test")
                let tracker2 = Tracker(id: UUID(), name: "Dog", color: .ypColor10, icon: "🐶", schedule: [0,1,2,3,4,5,6])
                try addTracker(tracker2, at: "test2")
            } catch {
                print("Error while adding test categories and trackers: \(error.localizedDescription)")
            }
        }
    }
}

extension TrackerService: TrackerServiceProtocol {
    var numberOfSections: Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tracker(at indexPath: IndexPath) -> Tracker {
        let trackerCoreData = fetchedResultsController.object(at: indexPath)
        return trackerStore?.getTrackerFromCoreData(from: trackerCoreData) ?? Tracker(id: UUID(), name: "test", color: .gray, icon: "", schedule: [])
    }

    func categoryName(at section: Int) -> String {
        return fetchedResultsController.object(at: IndexPath(item: 0, section: section)).category.name ?? "Unknown"
    }

    func addTracker(_ tracker: Tracker, at category: String) throws {
        if let categoryCoreData = trackerCategoryStore?.getCategoryWithName(category) {
            try trackerStore?.addNewTracker(tracker, at: categoryCoreData)
        }
    }

    func deleteTracker(at indexPath: IndexPath) throws {
        // This method can be implemented as needed
    }
}

extension TrackerService: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(TrackerServiceUpdate(
            insertedIndexes: insertedIndexes ?? IndexSet(),
            deletedIndexes: deletedIndexes ?? IndexSet()
        ))
        insertedIndexes = nil
        deletedIndexes = nil
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes?.insert(indexPath.item)
            }
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes?.insert(indexPath.item)
            }
        default:
            break
        }
    }
}

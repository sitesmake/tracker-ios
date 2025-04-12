//
//  Protocols.swift
//  Tracker
//
//  Created by alexander on 26.03.2025.
//

import UIKit

protocol TrackerStoreProtocol {
    func getTrackersInCategory(_ category: TrackerCategory) -> [Tracker]
    func addNewTracker(_ tracker: Tracker, at category: TrackerCategory) throws
}

protocol TrackerCategoryStoreProtocol {
    func getCategoryNames() -> [String]
    func getCategoryWithName(_ name: String) -> TrackerCategory?
    func addCategory(name: String) throws
}

protocol TrackerRecordStoreProtocol {
    func getTrackerRecord(tracker: Tracker, date: Date) -> TrackerRecord?
    func getTrackerRecordsNumber(tracker: Tracker) -> Int
    func addNewTrackerRecord(_ tracker: Tracker, date: Date) throws
    func deleteTrackerRecord(_ tracker: Tracker, date: Date) throws
}

protocol TrackerDataSourceProtocol {
    func getTrackersInCategory(_ category: TrackerCategory) -> [Tracker]
    func addNewTracker(_ tracker: Tracker, at category: TrackerCategory) throws
}

protocol TrackerCategoryDataSourceProtocol {
    func getCategoryNames() -> [String]
    func getCategoryWithName(_ name: String) -> TrackerCategory?
    func addCategory(name: String) throws
}

protocol TrackerRecordDataSourceProtocol {
    func getTrackerRecord(tracker: Tracker, date: Date) -> TrackerRecord?
    func getTrackerRecordsNumber(tracker: Tracker) -> Int
    func addNewTrackerRecord(_ tracker: Tracker, date: Date) throws
    func deleteTrackerRecord(_ tracker: Tracker, date: Date) throws
}


protocol TrackerServiceProtocol {
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    func tracker(at: IndexPath) -> Tracker
    func categoryName(at section: Int) -> String
    func addTracker(_ tracker: Tracker, at category: String) throws
    func deleteTracker(at indexPath: IndexPath) throws
}

protocol TrackersPresenterProtocol {
    var view: TrackersViewControllerProtocol? { get }
    var currentDate: Date { get set }
    var categories: [String] { get }
    var search: String { get set }
    var isEmpty: Bool { get }
    func addTracker(_ tracker: Tracker, at category: String)
    func numberOfSections() -> Int?
    func numberOfItemsInSection(section: Int) -> Int
    func titleInSection(section: Int) -> String
    func updateCategories()
    func completeTracker(_ complete: Bool, tracker: Tracker)
    func trackerViewModel(at indexPath: IndexPath) -> TrackerCellViewModel
}

protocol TrackerTypePresenterProtocol {
    var view: TrackerTypeViewControllerProtocol? { get set }
    func selectType(_ type: TrackerType)
}

protocol AddHabitPresenterProtocol {
    var view: AddHabitViewControllerProtocol? { get }
    var trackerName: String? { get set }
    var subtitleForCategory: String { get set }
    var type: TrackerType { get set }
    var selectedCategory: String? { get }
    var schedule: [Int] { get set }
    var isValidForm: Bool { get }
    var scheduleString: String { get }
    var icon: String? { get set }
    var color: UIColor? { get set }
    var pageTitle: String { get }
    func createNewTracker()
}

protocol TimetablePresenterProtocol {
    var view: TimetableViewControllerProtocol? { get }
    var selectedWeekdays: [Int] { get set }
    var weekdays: [String] { get }
    func done()
}

protocol TrackersViewControllerProtocol: AnyObject {
    var presenter: TrackersPresenterProtocol? { get }
    var trackersCollectionView: UICollectionView { get }
    func setupEmptyScreen()
}

protocol TrackerTypeViewControllerProtocol: AnyObject {
    var presenter: TrackerTypePresenterProtocol? { get }
}

protocol AddHabitViewControllerProtocol: AnyObject {
    var presenter: AddHabitPresenterProtocol? { get }
}

protocol TimetableViewControllerProtocol: AnyObject {
    var presenter: TimetablePresenterProtocol? { get }
}

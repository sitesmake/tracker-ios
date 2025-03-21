//
//  AddHabitPresenterProtocol.swift
//  Tracker
//
//  Created by alexander on 12.03.2025.
//

protocol AddHabitPresenterProtocol {
    var view: AddHabitViewControllerProtocol? { get }
    var trackerTitle: String? { get set }
    var subtitleForCategory: String { get set }
    var type: TrackerType { get set }
    func createNewTracker()
    var selectedCategory: TrackerCategory? { get }
    var schedule: [Int] { get set }
    var isValidForm: Bool { get }
}

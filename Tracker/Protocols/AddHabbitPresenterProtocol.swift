//
//  AddHabbitPresenterProtocol.swift
//  Tracker
//
//  Created by alexander on 12.03.2025.
//

protocol AddHabbitPresenterProtocol {
    var view: AddHabbitViewControllerProtocol? { get }
    var trackerTitle: String? { get set }
    var subtitleForCategory: String { get set }
    var type: TrackerType { get set }
    func createNewTracker()
    var selectedCategory: TrackerCategory? { get }
    var schedule: [Int] { get set }
    var isValidForm: Bool { get }
}

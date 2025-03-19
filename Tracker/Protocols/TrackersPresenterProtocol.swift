//
//  TrackersPresenterProtocol.swift
//  Tracker
//
//  Created by alexander on 11.03.2025.
//

import Foundation

protocol TrackersPresenterProtocol {
    var view: TrackersViewControllerProtocol? { get }
    var currentDate: Date { get set }
    var categories: [TrackerCategory] { get }
    func addTracker(_ tracker: Tracker, at category: TrackerCategory)
}

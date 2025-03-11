//
//  TrackerServiceProtocol.swift
//  Tracker
//
//  Created by alexander on 11.03.2025.
//

protocol TrackerServiceProtocol {
    var categories: [TrackerCategory] { get set }
    var visibleCategories: [TrackerCategory] { get set }
    var completedTrackers: Set<TrackerRecord> { get set }
}

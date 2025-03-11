//
//  TrackerTypePresenterProtocol.swift
//  Tracker
//
//  Created by alexander on 11.03.2025.
//

protocol TrackerTypePresenterProtocol {
    var view: TrackerTypeViewControllerProtocol? { get }
    func selectType(_ type: TrackerType)
}

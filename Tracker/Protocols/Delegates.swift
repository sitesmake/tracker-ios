//
//  Delegates.swift
//  Tracker
//
//  Created by alexander on 26.03.2025.
//

import UIKit

protocol AddHabitDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker, at category: String)
}

protocol TrackerServiceDelegate: AnyObject {
    func didUpdate(_ update: TrackerServiceUpdate)
}

protocol TrackerTypeDelegate: AnyObject {
    func didSelectType(_ type: TrackerType)
}

protocol TimetableDelegate: AnyObject {
    func didSelect(weekdays: [Int])
}

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func didComplete(_ complete: Bool,  tracker: Tracker)
}

protocol TextFieldCellDelegate: AnyObject {
    func didTextChange(text: String?)
}

protocol CollectionCellDelegate: AnyObject {
    func didIconSet(icon: String?)
    func didColorSet(color: UIColor?)
}

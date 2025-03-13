//
//  TrackerCollectionViewCellDelegate.swift
//  Tracker
//
//  Created by alexander on 11.03.2025.
//

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func didComplete(_ complete: Bool,  tracker: Tracker)
}

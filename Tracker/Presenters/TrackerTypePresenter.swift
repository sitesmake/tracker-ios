//
//  TrackerTypePresenter.swift
//  Tracker
//
//  Created by alexander on 11.03.2025.
//

import UIKit

class TrackerTypePresenter: TrackerTypePresenterProtocol {
    var view: TrackerTypeViewControllerProtocol?
    var delegate: TrackerTypeDelegate?
    
    func selectType(_ type: TrackerType) {
        delegate?.didSelectType(type)
    }
}

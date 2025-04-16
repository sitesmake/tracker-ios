//
//  TrackerTypePresenter.swift
//  Tracker
//
//  Created by alexander on 11.03.2025.
//

import UIKit

final class TrackerTypePresenter: TrackerTypePresenterProtocol {
    weak var delegate: TrackerTypeDelegate?
    weak var view: TrackerTypeViewControllerProtocol?

    func selectType(_ type: TrackerType) {
        delegate?.didSelectType(type)
    }
}

//
//  TimetablePresenterProtocol.swift
//  Tracker
//
//  Created by alexander on 12.03.2025.
//

protocol TimetablePresenterProtocol {
    var view: TimetableViewControllerProtocol { get }
    var selectedWeekdays: [Int] { get set }
    var weekdays: [String] { get }
    func done()
}

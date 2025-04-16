//
//  UIViewController+Extension.swift
//  Tracker
//
//  Created by alexander on 12.03.2025.
//

import UIKit

extension UIViewController {
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

class DaysFormatter {
    static let weekdays = Calendar.current.weekdaySymbols
    private static let dateFormatter = DateFormatter()
    
    static func shortWeekday(at index: Int) -> String {
        dateFormatter.shortWeekdaySymbols[index]
    }
}

extension Date {
    var weekdayIndex: Int {
        Calendar.current.component(.weekday, from: self) - 1
    }
    
    var onlyDate: Date? {
        get {
            let calendar = Calendar.current
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
            dateComponents.timeZone = NSTimeZone.system
            return calendar.date(from: dateComponents)
        }
    }
}

class ColorMarshaling {
    func hexString(from color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        return String.init(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
    }
    
    func color(from hex: String) -> UIColor {
        var rgbValue:UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

class ScheduleConverter {
    func convertToString(array: [Int]) -> String {
        array.map { String($0) }.joined()
    }
    
    func convertToArray(string: String) -> [Int] {
        string.map { Int(String($0)) ?? 9 }
    }
}

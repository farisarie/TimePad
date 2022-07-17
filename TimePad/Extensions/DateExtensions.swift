//
//  DateExtensions.swift
//  TimePad
//
//  Created by yoga arie on 31/05/22.
//

import Foundation

extension Date{
    func addDays(_ value: Int) -> Date? {
        let calendar = Calendar.autoupdatingCurrent
        let date = calendar.date(byAdding: .day, value: value, to: self)
        return date
    }
    
    func isSameDay(_ date: Date) -> Bool{
        let calendar = Calendar.autoupdatingCurrent
        return calendar.isDate(date, inSameDayAs: self)
    }
}

//
//  Date+Formatting.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Foundation

extension Date {
    var relativeDescription: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    var shortDate: String {
        formatted(date: .abbreviated, time: .omitted)
    }

    var daysDifference: Int {
        Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
    }

    func adding(days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}

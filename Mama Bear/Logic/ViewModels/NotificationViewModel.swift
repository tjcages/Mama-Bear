//
//  NotificationViewModel.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI

struct NotificationViewModel {
    let sections: [NotificationGroup]

    init() {
        // Create some test events
        var events = [
            Notification(start: NotificationViewModel.constructDate(day: 6, month: 9, year: 2020), title: "$10 Coupon for you!", priority: .high),
            Notification(start: NotificationViewModel.constructDate(day: 6, month: 9, year: 2020), title: "Claudia rated you 5 stars", priority: .low),
            Notification(start: NotificationViewModel.constructDate(day: 6, month: 9, year: 2020), title: "A new message is waiting for you", priority: .low),

            Notification(start: NotificationViewModel.constructDate(day: 2, month: 9, year: 2020), title: "Important policy update", priority: .high),
            Notification(start: NotificationViewModel.constructDate(day: 2, month: 9, year: 2020), title: "Check our blog!", priority: .high),

            Notification(start: NotificationViewModel.constructDate(day: 20, month: 7, year: 2020), title: "New features", priority: .low),
            Notification(start: NotificationViewModel.constructDate(day: 20, month: 7, year: 2020), title: "Protect your account", priority: .low),
        ]

        // Create an array of the occurrence objects and then sort them this makes sure that they are in ascending date order
        events = events.sorted { $0.start < $1.start }

        // Create a DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        // We use the Dictionary(grouping:) function so that all the events are group together, one downside of this is that the Dictionary keys may not be in order that we require, but we can fix that
        let grouped = Dictionary(grouping: events) { (occurrence: Notification) -> String in
            dateFormatter.string(from: occurrence.start)
        }

        // We now map over the dictionary and create our Day objects making sure to sort them on the date of the first object in the occurrences array
        // You may want a protection for the date value but it would be unlikely that the occurrences array would be empty (but you never know)
        // Then we want to sort them so that they are in the correct order
        self.sections = grouped.map { day -> NotificationGroup in
            NotificationGroup(title: day.key, occurrences: day.value, date: day.value[0].start)
        }.sorted { $0.date < $1.date }.reversed()
    }

    /// This is a helper function to quickly create dates so that this code will work. You probably don't need this in your code.
    static func constructDate(day: Int, month: Int, year: Int, hour: Int = 10, minute: Int = 0) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.timeZone = TimeZone(abbreviation: "GMT")
        dateComponents.hour = hour
        dateComponents.minute = minute

        // Create date from components
        let userCalendar = Calendar.current // user calendar
        let someDateTime = userCalendar.date(from: dateComponents)
        return someDateTime!
    }

}

//
//  Notification.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI

enum Priority: Int {
    case high
    case low
}

struct Notification: Identifiable {
    let id = UUID()
    let start: Date
    let title: String
    let priority: Priority
}

struct NotificationGroup: Identifiable {
    let id = UUID()
    let title: String
    let occurrences: [Notification]
    let date: Date
}

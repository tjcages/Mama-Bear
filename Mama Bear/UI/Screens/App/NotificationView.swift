//
//  NotificationView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI

struct NotificationView: View {
    let events = NotificationViewModel() // Data mockup

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Sizes.xSmall) {
                Text("Notifications")
                    .customFont(.heavy, category: .extraLarge)
                    .foregroundColor(Colors.headline)
                    .padding(.top, Sizes.Large)
                    .padding(.bottom, Sizes.Default)

                ForEach(events.sections) { group in
                    Section(header:
                            NotificationHeader(group: group)
                        , footer: Rectangle()
                            .foregroundColor(Colors.subheadline.opacity(0.3))
                            .frame(height: 1)
                            .padding(.vertical, Sizes.Default)
                    ) {
                        ForEach(group.occurrences) { notification in
                            NotificationRow(notification: notification)
                        }
                    }
                }

                Spacer()
            }
                .padding(.horizontal, Sizes.Default)
        }
    }
}

struct NotificationRow: View {
    var notification: Notification

    var body: some View {
        HStack(spacing: Sizes.xSmall) {
            Image(systemName: "bell")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Sizes.xSmall, height: Sizes.xSmall)
                .foregroundColor(notification.priority == .high ? Colors.white : Colors.subheadline)
                .padding(Sizes.Spacer)
                .background(notification.priority == .high ? Colors.blue : Colors.subheadline.opacity(0.1))
                .cornerRadius(Sizes.Large)

            Text(notification.title)
                .customFont(.medium, category: .medium)
                .foregroundColor(notification.priority == .high ? Colors.headline : Colors.subheadline)
        }
    }
}

struct NotificationHeader: View {
    var group: NotificationGroup

    var body: some View {
        HStack {
            Text(group.title)
                .customFont(.medium, category: .small)
                .foregroundColor(Colors.subheadline)

            Spacer()
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}

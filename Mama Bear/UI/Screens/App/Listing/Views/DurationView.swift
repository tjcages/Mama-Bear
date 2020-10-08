//
//  DurationView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI

struct DurationView: View {
    @Binding var activeSheet: ActiveSheet

    @State private var listingDate = Date()
    @State private var endingTime = Date().addingTimeInterval(28800)
    @State private var showingDate = false

    var newListing: Bool

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }

    init(newListing: Bool, activeSheet: Binding<ActiveSheet>) {
        self.newListing = newListing
        self._activeSheet = activeSheet
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Date selection
            if showingDate {
                DatePicker(selection: $listingDate.didSet { _ in
                    withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                        self.showingDate.toggle()
                    }
                }, in: Date()..., displayedComponents: .date) {
                    Image(systemName: "calendar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Sizes.Default, height: Sizes.Default)
                        .foregroundColor(Colors.coral)
                        .colorMultiply(Colors.coral)
                }
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .modifier(ColorInvert())
            } else {
                ZStack(alignment: .top) {
                    HStack {
                        Spacer()

                        Image(systemName: "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Sizes.Default, height: Sizes.Default)
                            .foregroundColor(Colors.coral)

                        Text("\(listingDate, formatter: dateFormatter)")
                            .customFont(.medium, category: .medium)
                            .foregroundColor(Colors.headline)
                            .padding(.leading, Sizes.Spacer)

                        Spacer()
                    }
                        .padding(Sizes.xSmall)
                        .padding(.trailing, Sizes.Spacer)
                        .overlay(
                            RoundedRectangle(cornerRadius: Sizes.Spacer)
                                .stroke(Colors.subheadline.opacity(0.4), lineWidth: 1)
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if newListing {
                                withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                                    self.showingDate.toggle()
                                }
                            }
                    }

                    Text(newListing ? "Select date" : "Request date")
                        .customFont(.medium, category: .small)
                        .foregroundColor(Colors.subheadline)
                        .padding(.horizontal, Sizes.Spacer)
                        .background(Colors.cellBackground)
                        .padding(.leading, Sizes.Spacer)
                        .offset(x: 0, y: -Sizes.Spacer - Sizes.Spacer / 2)
                }
            }

            // Divider
            Rectangle()
                .foregroundColor(Colors.subheadline.opacity(0.3))
                .frame(height: 1)
                .padding(.vertical, Sizes.xSmall)

            // Duration
            HStack {
                // Start
                VStack(alignment: .leading) {
                    Text("Start time")
                        .customFont(.medium, category: .small)
                        .foregroundColor(Colors.subheadline)

                    HStack {
                        Image(systemName: "clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Sizes.Small, height: Sizes.Small)
                            .foregroundColor(Colors.coral)

                        DatePicker("", selection: $listingDate, displayedComponents: .hourAndMinute)
                            .colorInvert().colorMultiply(Colors.coral)
                            .offset(x: newListing ? -Sizes.xSmall : -Sizes.Default)
                            .disabled(!newListing)

                        Spacer()
                    }
                }

                Spacer()

                Image(systemName: "arrow.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Sizes.xSmall, height: Sizes.xSmall)
                    .foregroundColor(Colors.subheadline)
                    .offset(y: Sizes.xSmall)

                Spacer()

                // Start
                VStack(alignment: .leading) {
                    Text("End time")
                        .customFont(.medium, category: .small)
                        .foregroundColor(Colors.subheadline)

                    HStack {
                        Spacer()

                        Image(systemName: "clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Sizes.Small, height: Sizes.Small)
                            .foregroundColor(Colors.coral)

                        DatePicker("", selection: $endingTime, displayedComponents: .hourAndMinute)
                            .colorInvert().colorMultiply(Colors.coral)
                            .offset(x: newListing ? -Sizes.xSmall : -Sizes.Default)
                            .disabled(!newListing)
                    }
                }
                    .offset(x: newListing ? Sizes.xSmall : Sizes.Default)
            }
        }
            .padding(Sizes.Default)
            .background(Colors.cellBackground)
            .cornerRadius(Sizes.Spacer)
            .shadow()
            .padding(.horizontal, Sizes.Default)
    }
}

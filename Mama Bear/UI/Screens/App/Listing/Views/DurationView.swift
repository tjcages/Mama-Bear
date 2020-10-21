//
//  DurationView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI

struct DurationView: View {
    @Binding var listingDate: Date
    @Binding var endingTime: Date

    @State private var showingDate = false
    @State private var showingStartTime = false
    @State private var showingEndTime = false

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

    init(newListing: Bool, startDate: Binding<Date>, endDate: Binding<Date>) {
        self.newListing = newListing
        self._listingDate = startDate
        self._endingTime = endDate
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Date selection
            if showingDate {
                DatePicker(selection: $listingDate.didSet { _ in
                    endingTime = listingDate.addingTimeInterval(28800)
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

            HStack {
                Text("Start time")
                    .customFont(.medium, category: .small)
                    .foregroundColor(Colors.subheadline)
                    .opacity(showingEndTime ? 0 : 1)

                Spacer()

                Text("End time")
                    .customFont(.medium, category: .small)
                    .foregroundColor(Colors.subheadline)
                    .opacity(showingStartTime ? 0 : 1)
            }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                        self.showingStartTime = false
                        self.showingEndTime = false
                    }
            }

            // Duration
            if !showingStartTime && !showingEndTime {
                HStack(alignment: .center) {
                    // Start
                    HStack {
                        Image(systemName: "clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Sizes.Small, height: Sizes.Small)
                            .foregroundColor(Colors.coral)

                        Text("\(listingDate, formatter: timeFormatter)")
                            .customFont(.medium, category: .medium)
                            .foregroundColor(Colors.headline)

                        Spacer()
                    }
                        .onTapGesture {
                            if newListing {
                                withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                                    self.showingStartTime.toggle()
                                }
                            }
                    }

                    Spacer()

                    Image(systemName: "arrow.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Sizes.xSmall, height: Sizes.xSmall)
                        .foregroundColor(Colors.subheadline)

                    Spacer()

                    // End
                    HStack {
                        Spacer()

                        Image(systemName: "clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Sizes.Small, height: Sizes.Small)
                            .foregroundColor(Colors.coral)

                        Text("\(endingTime, formatter: timeFormatter)")
                            .customFont(.medium, category: .medium)
                            .foregroundColor(Colors.headline)
                    }
                        .onTapGesture {
                            if newListing {
                                withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                                    self.showingEndTime.toggle()
                                }
                            }
                    }
                }
            } else {
                VStack(spacing: 0) {
                    DatePicker(selection: showingStartTime ? $listingDate.didSet { _ in
                        //
                    }: $endingTime.didSet { _ in
                            //
                        }, in: Date()..., displayedComponents: .hourAndMinute) {
                        Rectangle()
                            .frame(width: Sizes.Default, height: Sizes.Default)
                            .foregroundColor(.clear)
                    }
                        .datePickerStyle(WheelDatePickerStyle())
                        .frame(maxWidth: UIScreen.main.bounds.width - Sizes.Big * 2)
                        .offset(y: -Sizes.Spacer)

                    Button(action: {
                        // Save time
                        withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                            self.showingStartTime = false
                            self.showingEndTime = false
                        }
                    }, label: {
                            Text("Set time")
                                .customFont(.heavy, category: .small)
                                .foregroundColor(Colors.white)
                                .padding(.vertical, Sizes.Spacer)
                                .padding(.horizontal, Sizes.Big)
                                .background(Colors.lightCoral)
                                .cornerRadius(Sizes.Spacer)
                        })
                        .offset(x: Sizes.Default / 2)
                }
            }
        }
            .padding(Sizes.Default)
            .background(Colors.cellBackground)
            .cornerRadius(Sizes.Spacer)
            .shadow()
            .padding(.horizontal, Sizes.Default)
    }
}

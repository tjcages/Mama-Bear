//
//  ScheduleView.swift
//  Gather
//
//  Created by Tyler Cagle on 9/30/20.
//

import SwiftUI

enum ScheduleOptions: String {
    case today = "calendar"
    case minutes = "timer"
}

struct ScheduleView: View {
    @Binding var currentlySelectedId: ScheduleOptions

    init(selection: Binding<ScheduleOptions>) {
        self._currentlySelectedId = selection
    }

    var body: some View {
        HStack(spacing: Sizes.xSmall) {
            ScheduleOptionsView(task: .today, title: "Today", scheduleColor: Colors.green, itemSelected: $currentlySelectedId)

            ScheduleOptionsView(task: .minutes, title: "5-10 minutes", scheduleColor: Colors.blue, itemSelected: $currentlySelectedId)
        }
    }
}

struct ScheduleOptionsView: View {
    @State var task: ScheduleOptions
    @State var title: String
    @State var scheduleColor: Color

    @Binding var itemSelected: ScheduleOptions {
        didSet {
            if itemSelected == task {
                expanded.toggle()

                delayWithSeconds(Animation.animationIn) {
                    withAnimation(Animation.easeInOut(duration: Animation.animationQuick)) {
                        self.expanded.toggle()
                    }
                }
            }
        }
    }

    @State var expanded = false

    var body: some View {
        let size = Sizes.xSmall

        HStack(alignment: .center, spacing: Sizes.Spacer / 2) {
            Image(systemName: task.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
                .foregroundColor(scheduleColor)
                .padding(.trailing, Sizes.Spacer)

            Text(title)
                .customFont(.heavy, category: .small)
                .foregroundColor(scheduleColor)
                .fixedSize()
        }
            .padding(.all, Sizes.Spacer)
            .padding(.horizontal, Sizes.Spacer)
            .contentShape(Rectangle())
            .overlay(
                RoundedRectangle(cornerRadius: Sizes.Spacer)
                    .stroke(Colors.subheadline.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(expanded ? 1.1 : 1.0)
            .onTapGesture {
                withAnimation(Animation.easeInOut(duration: Animation.animationQuick)) {
                    self.itemSelected = self.task
                }
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(selection: .constant(.today))
    }
}

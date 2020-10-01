//
//  AddNewView.swift
//  Gather
//
//  Created by Tyler Cagle on 9/29/20.
//

import SwiftUI

enum TaskItems: String {
    case task = "checkmark.circle.fill"
    case project = "lightbulb"
    case event = "calendar.badge.plus"
}

struct AddNewView: View {
    @Binding var currentlySelectedId: TaskItems

    init(selection: Binding<TaskItems>) {
        self._currentlySelectedId = selection
    }

    var body: some View {
        HStack(spacing: Sizes.xSmall) {
            AddNewItem(task: .task, title: "Task", itemSelected: $currentlySelectedId)

            AddNewItem(task: .event, title: "Event", itemSelected: $currentlySelectedId)

            AddNewItem(task: .project, title: "Project", itemSelected: $currentlySelectedId)
        }
            .padding(.top, Sizes.xSmall)
            .background(
                VStack {
                    Spacer()

                    RoundedRectangle(cornerRadius: (Sizes.xLarge - 4)/2)
                        .frame(height: Sizes.xLarge - 4)
                        .padding(.horizontal, 2)
                        .foregroundColor(Colors.backgroundInvert.opacity(0.2))
                }
            )
    }
}

struct AddNewItem: View {
    @State var task: TaskItems
    @State var title: String

    @Binding var itemSelected: TaskItems {
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
        let size = Sizes.Small
        let selected = itemSelected == task

        VStack(alignment: .center, spacing: Sizes.Spacer / 2) {
            Text(title)
                .customFont(.heavy, category: .medium)
                .foregroundColor(Colors.white)
                .opacity(selected ? 1 : 0)
                .fixedSize()

            Image(systemName: task.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
                .foregroundColor(Colors.white)
                .padding(Sizes.xSmall - Sizes.Spacer/2)
                .background(selected ? Colors.sienna : Color.clear)
                .cornerRadius(Sizes.Default - 2)
        }
            .frame(width: Sizes.xLarge)
            .scaleEffect(expanded ? 1.1 : 1.0)
            .onTapGesture {
                withAnimation(Animation.easeInOut(duration: Animation.animationQuick)) {
                    self.itemSelected = self.task
                }
        }
    }
}

struct AddNewView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewView(selection: .constant(.task))
    }
}

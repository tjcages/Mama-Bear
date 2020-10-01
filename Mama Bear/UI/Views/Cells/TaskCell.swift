//
//  TaskCell.swift
//  Gather
//
//  Created by Tyler Cagle on 9/28/20.
//

import SwiftUI

struct TaskCell: View {
    @ObservedObject var taskCellVM: TaskCellViewModel
    var onCommit: (Result<Task, InputError>) -> Void = { _ in }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Colors.cellBackground

            if taskCellVM.task.completed {
                Colors.lightGreen
                    .transition(.iris)
            }

            HStack {
                // Details
                VStack(alignment: .leading, spacing: 0) {
                    Text("11:45 to noon")
                        .customFont(.medium, category: .small)
                        .foregroundColor(taskCellVM.task.completed ? Colors.gray : Colors.subheadline)

                    TextField("Enter task title", text: $taskCellVM.task.title,
                        onCommit: {
                            if !self.taskCellVM.task.title.isEmpty {
                                self.onCommit(.success(self.taskCellVM.task))
                            } else {
                                self.onCommit(.failure(.empty))
                            }
                        })
                        .id(taskCellVM.id)
                        .customFont(.medium, category: .medium)
                        .foregroundColor(taskCellVM.task.completed ? Colors.black : Colors.headline)
                }

                // Checkmark
                Image(systemName: taskCellVM.completionStateIconName)
                    .resizable()
                    .frame(width: Sizes.Large, height: Sizes.Large)
                    .foregroundColor(Colors.green)
                    .onTapGesture {
                        withAnimation(Animation.easeInOut(duration: Animation.animationIn)) {
                            self.taskCellVM.task.completed.toggle()
                        }
                }
            }
                .frame(maxWidth: .infinity)
                .padding(.all, Sizes.xSmall)
        }
            .cornerRadius(Sizes.cornerRadius)
            .shadow()
            .padding(.horizontal, Sizes.Default)
    }
}

enum InputError: Error {
    case empty
}

struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        TaskCell(taskCellVM: TaskCellViewModel(task: testDataTasts.first!))
    }
}

struct ScaledCircle: Shape {
    var animatableData: CGFloat

    func path(in rect: CGRect) -> Path {
        let maximumCircleRadius = sqrt(rect.width * rect.width + rect.height * rect.height)
        let circleRadius = maximumCircleRadius * animatableData

        let x = rect.midX - circleRadius / 2
        let y = rect.midY - circleRadius / 2

        let circleRect = CGRect(x: x, y: y, width: circleRadius, height: circleRadius)

        return Circle().path(in: circleRect)
    }
}

struct ClipShapeModifier<T: Shape>: ViewModifier {
    let shape: T

    func body(content: Content) -> some View {
        content.clipShape(shape)
    }
}

extension AnyTransition {
    static var iris: AnyTransition {
            .modifier(
                active: ClipShapeModifier(shape: ScaledCircle(animatableData: 0)),
                identity: ClipShapeModifier(shape: ScaledCircle(animatableData: 1))
            )
    }
}

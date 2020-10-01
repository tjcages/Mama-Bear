//
//  TaskListView.swift
//  Gather
//
//  Created by Tyler Cagle on 9/28/20.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var taskListVM = TaskListViewModel()
//    @Binding var presentAddNewItem: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: Sizes.xSmall) {
            ForEach(taskListVM.taskCellViewModels) { taskCellVM in
                TaskCell(taskCellVM: taskCellVM)
            }
                .onDelete { indexSet in
                    self.taskListVM.removeTasks(atOffsets: indexSet)
            }
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}

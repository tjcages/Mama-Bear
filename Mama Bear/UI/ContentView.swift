//
//  ContentView.swift
//  Gather
//
//  Created by Tyler Cagle on 9/27/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    @ObservedObject var taskListVM = TaskListViewModel()

    @State var showSettingsScreen = false
    @State var presentAddNewItem = false

    let sheetStyle = PartialSheetStyle(background: Color.clear,
                                       handlerBarColor: Colors.subheadline,
                                       enableCover: true,
                                       coverColor: Color.black.opacity(0.6),
                                       blurEffectStyle: nil,
                                       cornerRadius: Sizes.xSmall,
                                       minTopDistance: 0
    )

    var body: some View {
        Text("FUCK YOU")
//        NavigationView {
//            ZStack(alignment: .topLeading) {
//                Colors.background
//                    .edgesIgnoringSafeArea(.all)
//
//                // Main feed for posts
//                ScrollView(.vertical) {
//                    VStack(alignment: .leading, spacing: Sizes.Spacer) {
//                        GreetingView()
//                            .padding(.top, Sizes.Spacer)
//
//                        RoutineView()
//                    }
//                }
//                    .offset(x: 0, y: 0)
//                    .background(Color.clear)
//
//                // Bottom stack for buttons
//                VStack {
//                    Spacer()
//
//                    HStack(alignment: .top) {
//                        Spacer()
//
//                        AddTaskButton(addTask: $presentAddNewItem)
//                    }
//                        .padding(.horizontal, Sizes.Default)
//                }
//
//                // Add a new cell to the list and publish to Firestore
////                if presentAddNewItem {
////                    TaskCell(taskCellVM: TaskCellViewModel.newTask()) { result in
////                        if case .success(let task) = result {
////                            self.taskListVM.addTask(task: task)
////                        }
////                        self.presentAddNewItem.toggle()
////                    }
////                }
//            }
//                .hideNavigationBar()
//                .sheet(isPresented: $showSettingsScreen) {
//                    SettingsView()
//                }
//                .addPartialSheet(style: sheetStyle)
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

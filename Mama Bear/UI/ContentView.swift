//
//  ContentView.swift
//  Gather
//
//  Created by Tyler Cagle on 9/27/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var taskListVM = TaskListViewModel()

    var body: some View {
        OnboardingView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

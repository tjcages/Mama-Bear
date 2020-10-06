//
//  ContentView.swift
//  Gather
//
//  Created by Tyler Cagle on 9/27/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var taskListVM = TaskListViewModel()
    @ObservedObject var viewRouter = ViewRouter()
    
    @State var userLoggedIn: Bool = true // BUILDING PURPOSES -> SHOULD BE FALSE

    var body: some View {
        if userLoggedIn {
            AppView(viewRouter: viewRouter)
        } else {
            OnboardingView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

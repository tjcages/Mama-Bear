//
//  ProfileView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI

enum ActiveSheet {
    case first
    case second
}

struct ProfileView: View {
    @ObservedObject var viewRouter: ViewRouter

    @State var showSheet = false
    @State var activeSheet: ActiveSheet = .first

    @State var selectedIndex = 0

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            // Profile header
            Header_ProfileView(viewRouter: viewRouter)
                .padding(.bottom, Sizes.xSmall)

            BrandSegmentedPickerView(selectedIndex: $selectedIndex, titles: ["Manage", "Personal"])
                .padding(.horizontal, Sizes.Default)
                .padding(.bottom, Sizes.xSmall)

            if selectedIndex == 0 {
                Manage_ProfileView(activeSheet: $activeSheet, showSheet: $showSheet)
            } else {
                Personal_ProfileView()
            }

            Color.clear.padding(.bottom, Sizes.Big * 2)
        }
            .edgesIgnoringSafeArea(.top)
            .sheet(isPresented: $showSheet) {
                if activeSheet == .first {
                    Requests_ProfileView(showingRequests: $showSheet)
                } else if activeSheet == .second {
                    TransactionsView(showingTransactions: $showSheet)
                }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewRouter: ViewRouter())
    }
}

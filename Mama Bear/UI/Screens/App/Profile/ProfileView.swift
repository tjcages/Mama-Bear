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
    case third
}

struct ProfileView: View {
    @ObservedObject var authenticationService: AuthenticationService
    @ObservedObject var viewRouter: ViewRouter

    @State var showSheet = false
    @State var activeSheet: ActiveSheet = .first

    @State var selectedIndex = 0

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                // Profile header
                Header_ProfileView(authenticationService: authenticationService, viewRouter: viewRouter)
                    .padding(.bottom, Sizes.xSmall)

                BrandSegmentedPickerView(selectedIndex: $selectedIndex, titles: ["Manage", "Personal"])
                    .padding(.horizontal, Sizes.Default)
                    .padding(.bottom, Sizes.xSmall)

                if selectedIndex == 0 {
                    Manage_ProfileView(activeSheet: $activeSheet.didSet { _ in 
                        showSheet = true
                    })
                } else {
                    Personal_ProfileView(authenticationService: authenticationService, activeSheet: $activeSheet.didSet { _ in
                        showSheet = true
                    })
                }

                Color.clear.padding(.bottom, Sizes.Big * 2)

                Spacer()
            }
        }
            .edgesIgnoringSafeArea(.top)
            .sheet(isPresented: $showSheet) {
                if activeSheet == .first {
                    Requests_ProfileView(showingRequests: $showSheet)
                } else if activeSheet == .second {
                    TransactionsView(showingTransactions: $showSheet)
                } else if activeSheet == .third {
                    NewAddress_ProfileView(showSheet: $showSheet)
                }
            }
            .responsiveKeyboard()
    }
}

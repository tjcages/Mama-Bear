//
//  Profile_ManageView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI

struct Manage_ProfileView: View {
    @Binding var activeSheet: ActiveSheet

    var accounts: [CreateAccount] = [
        CreateAccount(title: "Your requests", subtitle: "Manage your jobs", color: Colors.subheadline.opacity(0.1), image: "jobsGraphic", type: .unknown),
        CreateAccount(title: "Payment", subtitle: "Your recent transactions", color: Colors.subheadline.opacity(0.1), image: "paymentsGraphic", type: .unknown)
    ]

    var body: some View {
        VStack {
            ForEach(accounts, id: \.title) { account in
                AccountSelectionView(account)
                    .onTapGesture {
                        // Handle tap gesture
                        if account.title == "Your requests" {
                            activeSheet = .first
                        } else if account.title == "Payment" {
                            activeSheet = .second
                        }
                }
            }
        }
    }
}

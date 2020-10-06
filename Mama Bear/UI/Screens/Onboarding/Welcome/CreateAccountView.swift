//
//  CreateAccountView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

struct CreateAccount {
    let title: String
    let subtitle: String
    let color: Color
}

struct CreateAccountView: View {
    var backPressed: () -> () = { }
    var accountPressed: () -> () = { }

    var accounts: [CreateAccount] = [
        CreateAccount(title: "Parent account", subtitle: "Find the best babysitter", color: Colors.lightCoral.opacity(0.5)),
        CreateAccount(title: "Nanny account", subtitle: "Get jobs near you", color: Colors.lightBlue)
    ]

    var body: some View {
        VStack(alignment: .center, spacing: Sizes.Spacer) {
            Text("Choose your account type. \nAre you a parent or nanny?")
                .customFont(.medium, category: .medium)
                .foregroundColor(Colors.subheadline)

            Spacer()

            ForEach(accounts, id: \.title) { account in
                AccountSelectionView(account)
                    .onTapGesture {
                        accountPressed()
                }
            }

            Spacer()

            HStack(spacing: Sizes.Spacer) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Sizes.Small, height: Sizes.Small)
                    .foregroundColor(Colors.subheadline)

                Text("Back to login")
                    .customFont(.heavy, category: .small)
                    .foregroundColor(Colors.subheadline)
            }
                .padding(.vertical, Sizes.Default)
                .contentShape(Rectangle())
                .onTapGesture {
                    backPressed()
            }

            Spacer()
        }
            .onTapGesture {
                UIApplication.shared.endEditing()
        }
    }
}

struct AccountSelectionView: View {
    var account: CreateAccount

    init(_ account: CreateAccount) {
        self.account = account
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(account.title)
                    .customFont(.medium, category: .medium)
                    .foregroundColor(Colors.headline)

                Text(account.subtitle)
                    .customFont(.medium, category: .small)
                    .foregroundColor(Colors.subheadline)
            }

            Spacer()

            // Account graphic
            Rectangle()
                .foregroundColor(Color.black.opacity(0.1))
                .frame(width: Sizes.Big, height: Sizes.Big)
        }
            .padding(.all, Sizes.xLarge)
            .frame(maxWidth: .infinity)
            .background(account.color)
            .cornerRadius(Sizes.xSmall)
            .padding(.horizontal, Sizes.xSmall)
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}

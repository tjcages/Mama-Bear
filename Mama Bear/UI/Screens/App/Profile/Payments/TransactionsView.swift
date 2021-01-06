//
//  AddPaymentView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI

struct TransactionsView: View {
    @Binding var showingTransactions: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            BackButton() {
                showingTransactions.toggle()
            }

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Sizes.xSmall) {
                    Text("Transaction methods")
                        .customFont(.heavy, category: .extraLarge)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Large)
                        .padding(.horizontal, Sizes.Default)

                    // Payment methods
                    Group {
                        PaymentView(card: false)

                        PaymentView(card: true)
                    }
                        .padding(.horizontal, Sizes.Default)

                    // Last transactions
                    Text("Transactions")
                        .customFont(.medium, category: .large)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Default)
                        .padding(.horizontal, Sizes.Default)

                    ForEach(0..<10) { index in
                        TransactionsCell()
                    }

                    Spacer()
                }
            }
        }
    }
}

struct TransactionsCell: View {
    var body: some View {
        HStack {
            // Children icon
            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Sizes.Small, height: Sizes.Small)
                .foregroundColor(Colors.blue)
                .padding(.trailing, Sizes.xSmall)

            // Details
            VStack(alignment: .leading, spacing: Sizes.Spacer / 2) {
                Text("Sitter account")
                    .customFont(.heavy, category: .medium)
                    .foregroundColor(Colors.headline)

                // Sub details
                Text("01.09.2019")
                    .customFont(.medium, category: .small)
                    .foregroundColor(Colors.subheadline)
            }

            Spacer()

            Text("$20.50")
                .customFont(.medium, category: .medium)
                .foregroundColor(Colors.headline)
        }
            .padding(.horizontal, Sizes.xSmall)
            .padding(.vertical, Sizes.Small)
            .background(Colors.cellBackground)
            .cornerRadius(Sizes.Spacer)
            .shadow()
            .padding(.horizontal, Sizes.Default)
    }
}

struct PaymentView: View {
    var card: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // Logo
                Image(systemName: card ? "creditcard" : "cart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Sizes.Default, height: Sizes.Default)
                    .foregroundColor(card ? Colors.darkCoral : Colors.blue)
                    .padding(Sizes.xSmall)
                    .background(Colors.cellBackground
                    )
                    .cornerRadius(Sizes.Spacer)
                    .shadow()
                    .padding(.bottom, Sizes.Default)

                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(card ? "Credit card" : "Bank account")
                            .customFont(.heavy, category: .medium)
                            .foregroundColor(Colors.white)

                        Text(card ? "Linked with bank" : "Online transfers")
                            .customFont(.medium, category: .small)
                            .foregroundColor(Colors.white)
                    }

                    Spacer()

                    Button(action: {

                    }, label: {
                            Text("See details")
                                .customFont(.medium, category: .small)
                                .foregroundColor(Colors.headline)
                                .padding(Sizes.Spacer)
                                .padding(.horizontal, Sizes.Spacer / 2)
                                .background(Colors.cellBackground)
                                .cornerRadius(Sizes.Spacer)
                        })
                }
            }

            Spacer()
        }
            .padding(Sizes.Small)
            .background(LinearGradient(gradient: Gradient(colors: card ? [Colors.lightCoral, Colors.darkCoral] : [Colors.blue, Colors.darkBlue]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(Sizes.Spacer)
            .shadow()
            .padding(.bottom, Sizes.Spacer)
    }
}

struct AddPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView(showingTransactions: .constant(true))
    }
}

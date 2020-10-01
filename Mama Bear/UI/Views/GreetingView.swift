//
//  GreetingView.swift
//  Gather
//
//  Created by Tyler Cagle on 9/28/20.
//

import SwiftUI

struct GreetingView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()

            Text("Today")
                .customFont(.heavy, category: .extraLarge)
                .foregroundColor(Colors.headline)
                .multilineTextAlignment(.leading)

            Text("Monday, Sept. 28th")
                .customFont(.medium, category: .large)
                .foregroundColor(Colors.subheadline)
                .multilineTextAlignment(.leading)
        }
            .frame(height: 92)
            .padding(.horizontal, Sizes.Default)
            .padding(.bottom, Sizes.Spacer)
    }
}

struct GreetingView_Previews: PreviewProvider {
    static var previews: some View {
        GreetingView()
    }
}

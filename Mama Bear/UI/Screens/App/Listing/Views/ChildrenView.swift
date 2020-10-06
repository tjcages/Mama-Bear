//
//  ChildrenView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI

struct ChildrenView: View {
    var body: some View {
        VStack {
            WrappedHStack(tags: ["First kid", "Second kid", "Third kid"], item: AnyView(ChildAgeView()))
        }
            .padding([.leading, .top, .trailing], Sizes.Default)
            .padding(.bottom, Sizes.xSmall)
            .background(Colors.white)
            .cornerRadius(Sizes.Spacer)
            .shadow()
            .padding(.horizontal, Sizes.Default)
    }
}

struct ChildAgeView: View {
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Sizes.Small, height: Sizes.Small)
                .foregroundColor(Colors.blue)

            Text("2 years")
                .customFont(.medium, category: .small)
                .foregroundColor(Colors.blue)
        }
            .padding(.vertical, 12)
            .padding(.horizontal, Sizes.xSmall)
            .background(Colors.lightBlue)
            .cornerRadius(Sizes.Spacer)
            .padding([.bottom, .trailing], Sizes.Spacer)
    }
}

struct ChildrenView_Previews: PreviewProvider {
    static var previews: some View {
        ChildrenView()
    }
}

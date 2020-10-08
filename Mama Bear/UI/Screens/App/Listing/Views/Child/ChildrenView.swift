//
//  ChildrenView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI

struct ChildrenView: View {
    @Binding var activeSheet: ActiveSheet
    
    var body: some View {
        VStack {
            Child_WrappedHStack(children: [
                Child(name: "Mark", age: .baby, gender: .male),
                Child(name: "Sally", age: .teenager, gender: .female),
                Child(name: "Jewbear", age: .toddler, gender: .unknown),
                Child()
            ], activeSheet: $activeSheet
            )
        }
            .padding([.leading, .top, .trailing], Sizes.Default)
            .padding(.bottom, Sizes.xSmall)
            .background(Colors.cellBackground)
            .cornerRadius(Sizes.Spacer)
            .shadow()
            .padding(.horizontal, Sizes.Default)
    }
}

struct ChildAgeView: View {
    var child: Child
    @Binding var activeSheet: ActiveSheet

    var body: some View {
        let addNew = child.name == ""
        HStack {
            Image(systemName: addNew ? "plus.circle" : "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Sizes.Small, height: Sizes.Small)
                .foregroundColor(Colors.blue)

            Text(addNew ? "Add a child" : child.name)
                .customFont(.medium, category: .small)
                .foregroundColor(Colors.blue)
        }
            .padding(.vertical, 12)
            .padding(.horizontal, Sizes.xSmall)
            .background(addNew ? Colors.subheadline.opacity(0.1) : Colors.lightBlue)
            .cornerRadius(Sizes.Spacer)
            .padding([.bottom, .trailing], Sizes.Spacer)
            .onTapGesture {
                if addNew {
                    // Add child sheet
                    activeSheet = .first
                }
        }
    }
}

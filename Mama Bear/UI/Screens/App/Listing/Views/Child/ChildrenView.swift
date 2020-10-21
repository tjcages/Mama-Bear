//
//  ChildrenView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI

struct ChildrenView: View {
    @ObservedObject var authenticationService: AuthenticationService

    @Binding var selectedChild: Child

    var body: some View {
        VStack {
            Child_WrappedHStack(authenticationService: authenticationService, selectedChild: $selectedChild)
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
    @Binding var selectedChild: Child

    var body: some View {
        let addNew = child.name == ""
        HStack {
            Image(addNew ? "plus.circle" : (child.gender == Gender.male.rawValue ? (child.ageCategory == .baby ? "babyIcon" : (child.ageCategory == .toddler ? "toddlerIcon" : "teenagerIcon")) : (child.ageCategory == .baby ? "babyIcon" : (child.ageCategory == .toddler ? "toddlerFemaleIcon" : "teenagerFemaleIcon"))))
                .renderingMode(.template)
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
            .background(addNew ? Colors.subheadline.opacity(0.1) : Colors.blue.opacity(0.2))
            .cornerRadius(Sizes.Spacer)
            .padding([.bottom, .trailing], Sizes.Spacer)
            .onTapGesture {
                // Add child sheet
                selectedChild = child
        }
    }
}

struct Child_WrappedHStack: View {
    @ObservedObject var authenticationService: AuthenticationService

    @Binding var selectedChild: Child

    private var children: [Child] {
        if let children = authenticationService.userChildren {
            return children
        }
        return []
    }

    @State private var totalHeight
        = CGFloat.zero // << variant for ScrollView/List
    //    = CGFloat.infinity   // << variant for VStack

    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
            .frame(height: totalHeight)// << variant for ScrollView/List
        //.frame(maxHeight: totalHeight) // << variant for VStack
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(children) { child in
                self.item(for: child)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        width -= d.width
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { d in
                        let result = height
                        return result
                    })
            }
            self.item(for: Child())
                .alignmentGuide(.leading, computeValue: { d in
                    if (abs(width - d.width) > g.size.width)
                    {
                        width = 0
                        height -= d.height
                    }
                    let result = width
                    width = 0 // Last item
                    return result
                })
                .alignmentGuide(.top, computeValue: { d in
                    let result = height
                    height = 0 // Last item
                    return result
                })
        }
            .background(viewHeightReader($totalHeight))
    }

    private func item(for child: Child) -> some View {
        return ChildAgeView(child: child, selectedChild: $selectedChild)
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

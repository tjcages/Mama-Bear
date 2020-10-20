//
//  AddChildView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/7/20.
//

import SwiftUI

struct AddChildView: View {
    @ObservedObject var authenticationService: AuthenticationService
    
    @Binding var showSheet: Bool

    var child: Child

    @State var childName: String = ""
    @State var gender: Gender = .male
    @State var age: Int = 8

    var body: some View {
        let newChild = self.child.name == ""

        VStack(alignment: .leading) {
            BackButton() {
                showSheet.toggle()
            }

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Sizes.Default) {
                    Text("Add a child")
                        .customFont(.heavy, category: .extraLarge)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Large)
                        .padding(.horizontal, Sizes.Default)

                    VStack(spacing: Sizes.Default) {
                        Group {
                            BrandTextView(item: .firstName, $childName)

                            AgeView(age: $age)

                            GenderView(gender: $gender)
                        }
                            .padding(.top, Sizes.Default)
                            .onTapGesture {
                                UIApplication.shared.endEditing()
                        }

                        Spacer()

                        Group {
                            ConfirmButton(title: "Save", style: .fill) {
                                // Save child
                                var child = Child(name: childName, age: age, gender: gender)
                                if !newChild { child.id = self.child.id }
                                authenticationService.addChildToFirestore(child: child)

                                showSheet.toggle()
                            }

                            ConfirmButton(title: newChild ? "Cancel" : "Delete", style: .lined) {
                                if !newChild {
                                    authenticationService.removeChild(child)
                                }
                                showSheet.toggle()
                            }
                        }
                            .padding(.bottom, Sizes.Spacer)
                    }
                        .padding(.horizontal, Sizes.Default)
                }
            }
        }
            .background(Colors.cellBackground.edgesIgnoringSafeArea(.all))
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .onAppear {
                childName = child.name
                age = child.age
                gender = Gender(rawValue: child.gender) ?? .unknown
        }
    }
}

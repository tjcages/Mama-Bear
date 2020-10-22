//
//  ProfileView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI
import Firebase
import FirebaseStorage

enum ActiveSheet {
    case first
    case second
    case third
    case fourth
    case none
}

struct ProfileView: View {
    @ObservedObject var authenticationService: AuthenticationService
    @ObservedObject var listingListVM: ListingListViewModel
    @ObservedObject var viewRouter: ViewRouter

    @State var showSheet = false
    @State var activeSheet: ActiveSheet = .first

    @State var selectedIndex = 0
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                // Profile header
                Header_ProfileView(authenticationService: authenticationService, viewRouter: viewRouter, activeSheet: $activeSheet.didSet { _ in
                    showSheet = true
                })
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
            .sheet(isPresented: $showSheet, onDismiss: loadImageToFirebase) {
                if activeSheet == .first {
                    Requests_ProfileView(authenticationService: authenticationService, listingListVM: listingListVM, viewRouter: viewRouter, showingRequests: $showSheet)
                } else if activeSheet == .second {
                    TransactionsView(showingTransactions: $showSheet)
                } else if activeSheet == .third {
                    NewAddress_ProfileView(authenticationService: authenticationService, showSheet: $showSheet)
                } else if activeSheet == .fourth {
                    ImagePicker(image: self.$inputImage)
                }
            }
            .responsiveKeyboard()
    }

    func loadImageToFirebase() {
        guard let data = inputImage?.pngData(), let uid = authenticationService.user?.uid else { return }
        let storageRef = Storage.storage().reference().child("userPhotos/\(uid)")
        let _ = storageRef.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error upbloading image: \(error)")
                return
            }
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error downloading image: \(error)")
                    return
                }
                if var user = authenticationService.firestoreUser {
                    user.photoURL = url?.absoluteString ?? ""
                    authenticationService.addUserToFirestore(user: user)
                }
                authenticationService.updatePhotoURL(url: url) { _ in
                    //
                }
            }
        }
    }
}

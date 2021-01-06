//
//  SignInWithGoogleCoordinator.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/20/20.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn

struct GoogleSignInRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    @Environment(\.presentationMode) var presentationMode

    var onCommit: (AuthDataResult) -> Void = { _ in }

    func makeCoordinator() -> GoogleSignInRepresentable.Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.presentingViewController = controller
        GIDSignIn.sharedInstance().delegate = context.coordinator
        
        let image = UIImage(named: "google")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        controller.view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Sizes.Big).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: Sizes.Big).isActive = true
        
        delayWithSeconds(Animation.animationOut) {
            GIDSignIn.sharedInstance().signIn()
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //
    }

    class Coordinator: NSObject, GIDSignInDelegate {
        var parent: GoogleSignInRepresentable
        var onCommit: (AuthDataResult) -> Void = { _ in }

        init(_ controller: GoogleSignInRepresentable) {
            self.parent = controller
        }

        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            if let error = error {
                print("Error signing into Google: \(error.localizedDescription)")
                parent.presentationMode.wrappedValue.dismiss()
                return
            }

            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Error logging into Google with credential: \(error)")
                }
                // Successful sign in
                if let result = authResult {
                    self.parent.onCommit(result)
                }
            }
        }
        
        func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
            print("Error signing into Google: \(error.localizedDescription)")
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

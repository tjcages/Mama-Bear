//
//  User.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/19/20.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreUser: Identifiable, Codable {
    var id: String?
    var name: String
    var email: String
    var phoneNumber: String?
    
    var photoURL: String?
    var accountType: AccountType.RawValue
    
    @ServerTimestamp var createdTime: Timestamp?
    @ServerTimestamp var updatedTime = Timestamp.init(date: Date())
}

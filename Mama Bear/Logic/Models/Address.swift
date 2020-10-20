//
//  Address.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/20/20.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Address: Identifiable, Codable {
    @DocumentID var id: String?
    let street: String
    let city: String
    let state: String
    let zip: String
    
    @ServerTimestamp var createdTime: Timestamp?
    @ServerTimestamp var updatedTime = Timestamp.init(date: Date())
    var userId: String?
}

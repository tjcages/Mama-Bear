//
//  Pet.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/7/20.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

enum Animal: String {
    case cat = "Cat"
    case dog = "Dog"
}

struct Pet: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    let name: String
    let type: Animal.RawValue
    let gender: Gender.RawValue
    
    @ServerTimestamp var createdTime: Timestamp?
    @ServerTimestamp var updatedTime = Timestamp.init(date: Date())
    var userId: String?
    
    init(name: String, type: Animal, gender: Gender) {
        self.name = name
        self.type = type.rawValue
        self.gender = gender.rawValue
    }
    
    init() {
        self.name = ""
        self.type = "Dog"
        self.gender = "Female"
    }
}

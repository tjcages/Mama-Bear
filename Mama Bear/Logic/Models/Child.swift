//
//  Child.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/7/20.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

enum Gender: String {
    case male = "Male"
    case female = "Female"
    case unknown = "Other"
}

enum Age: Int {
    case baby = 0
    case toddler = 1
    case teenager = 2
}

struct Child: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    let name: String
    let age: Int
    let gender: Gender.RawValue
    
    @ServerTimestamp var createdTime: Timestamp?
    @ServerTimestamp var updatedTime = Timestamp.init(date: Date())
    var userId: String?
    
    init(name: String, age: Int, gender: Gender) {
        self.name = name
        self.age = age
        self.gender = gender.rawValue
    }
    
    init() {
        self.name = ""
        self.age = 8
        self.gender = "Female"
    }
}

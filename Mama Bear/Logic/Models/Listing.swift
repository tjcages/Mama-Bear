//
//  Task.swift
//  Gather
//
//  Created by Tyler Cagle on 9/28/20.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Listing: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String?
    var sitterId: String = ""
    @ServerTimestamp var createdTime: Timestamp?
    @ServerTimestamp var updatedTime = Timestamp.init(date: Date())

    var startDate: Timestamp
    var endDate: Timestamp
    var childrenId: [String]
    var petsId: [String]?
    var sitterRequirement: SitterRequirement.RawValue
    
    var completed: Bool
}

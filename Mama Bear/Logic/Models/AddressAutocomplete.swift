//
//  AddressAutocomplete.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 12/15/20.
//

import SwiftUI
import MapKit

struct AutocompleteAddress: Hashable {
    let placemark: MKPlacemark
    var results: [NSTextCheckingKey: String]?
    
    var id = UUID()
    var street: String {
        if let results = results {
            return String(results[NSTextCheckingKey.street] ?? "")
        } else {
            return ""
        }
    }
    var city: String {
        if let results = results {
            return String(results[NSTextCheckingKey.city] ?? "")
        } else {
            return ""
        }
    }
    var state: String {
        if let results = results {
            return String(results[NSTextCheckingKey.state] ?? "")
        } else {
            return ""
        }
    }
    var zip: String {
        if let results = results {
            return String(results[NSTextCheckingKey.zip] ?? "")
        } else {
            return ""
        }
    }
    
    init(placemark: MKPlacemark) {
        self.placemark = placemark
        
        self.results = getAddress(from: self.placemark.title ?? "")
    }
    
    func getAddress(from dataString: String) -> [NSTextCheckingKey: String] {
      let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.address.rawValue)
      let matches = detector.matches(in: dataString, options: [], range: NSRange(location: 0, length: dataString.utf16.count))

      var resultsArray =  [NSTextCheckingKey: String]()
      // put matches into array of Strings
      for match in matches {
        if match.resultType == .address,
          let components = match.addressComponents {
          resultsArray = components
        } else {
          print("no components found")
        }
      }
      return resultsArray
    }
}

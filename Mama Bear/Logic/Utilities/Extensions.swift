//
//  Extensions.swift
//  Gather
//
//  Created by Tyler Cagle on 9/29/20.
//

import UIKit
import SwiftUI

func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Binding {
/// Execute block when value is changed.
///     Slider(value: $amount.didSet { print($0) }, in: 0...10)
    func didSet(execute: @escaping (Value) -> Void) -> Binding {
        return Binding(
            get: {
                return self.wrappedValue
            },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
}

extension Date {
    static func -(recent: Date, previous: Date) -> (month: Int, day: Int, hour: Int, minute: Int, second: Int) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second
        if let day = day, let month = month, let hour = hour, let minute = minute, let second = second {
            return (month: month, day: day, hour: hour, minute: minute, second: second)
        }
        return (month: month ?? 0, day: day ?? 0, hour: hour ?? 0, minute: minute ?? 0, second: second ?? 0)
    }
}

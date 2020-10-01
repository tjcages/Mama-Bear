//
//  Publisher+Assign.swift
//  Gather
//
//  Created by Tyler Cagle on 9/28/20.
//

import Combine

// https://forums.swift.org/t/does-assign-to-produce-memory-leaks/29546/11
extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
        sink { [weak root] in
            root?[keyPath: keyPath] = $0
        }
    }
}

//
//  Observable.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import SwiftUI

extension Observable where Self: AnyObject {
    
    /// Creates a `Binding` to the given writeable property.
    ///
    /// Useful for situations like when `Self` is referenced through
    /// `Environment` and cannot use `Bindable`.
    func binding<Value>(for keypath: ReferenceWritableKeyPath<Self, Value>) -> Binding<Value> {
        .init(
            get: { self[keyPath: keypath] },
            set: { self[keyPath: keypath] = $0 }
        )
    }
}

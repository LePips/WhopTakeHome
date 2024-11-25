//
//  Set.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import Foundation

extension Set {
    
    /// If the element is in the set, remove it. If it is not, insert it.
    mutating func toggle(_ element: Element) {
        if contains(element) {
            remove(element)
        } else {
            insert(element)
        }
    }
}

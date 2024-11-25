//
//  FormatStyle.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import Foundation

/// A format style that returns the `description` of a CustomStringConvertible value.
struct VerbatimStringFormatStyle<Value: CustomStringConvertible>: FormatStyle {
    func format(_ value: Value) -> String {
        value.description
    }
}

extension FormatStyle where FormatInput: CustomStringConvertible {
    
    var verbatim: VerbatimStringFormatStyle<FormatInput> {
        VerbatimStringFormatStyle()
    }
}

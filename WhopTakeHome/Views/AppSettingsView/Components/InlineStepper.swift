//
//  InlineStepper.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import SwiftUI

/// A wrapper around `Stepper` so that the value is inline
/// to a `List` row.
struct InlineStepper<Value: Strideable, Format: FormatStyle>: View where Format.FormatInput == Value, Format.FormatOutput == String {
    
    private let title: String
    private let value: Binding<Value>
    private let range: ClosedRange<Value>
    private let step: Value.Stride
    private let format: Format
    
    init(
        title: String,
        value: Binding<Value>,
        range: ClosedRange<Value>,
        step: Value.Stride,
        format: Format
    ) {
        self.title = title
        self.value = value
        self.range = range
        self.step = step
        self.format = format
    }
    
    var body: some View {
        Stepper(
            value: value,
            in: range,
            step: step
        ) {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(value.wrappedValue, format: format)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

extension InlineStepper where Value: CustomStringConvertible, Format == VerbatimStringFormatStyle<Value> {
    
    init(
        title: String,
        value: Binding<Value>,
        range: ClosedRange<Value>,
        step: Value.Stride
    ) {
        self.init(
            title: title,
            value: value,
            range: range,
            step: step,
            format: VerbatimStringFormatStyle<Value>()
        )
    }
}

#Preview {
    List {
        InlineStepper(
            title: "Test Number",
            value: .constant(0),
            range: 0 ... 10,
            step: 1,
            format: .number
        )
        
        InlineStepper(
            title: "Test Percent",
            value: .constant(0.5),
            range: 0 ... 1,
            step: 0.1,
            format: .percent
        )
    }
}

//
//  View+Extensions.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import SwiftUI

extension View {
    
    /// Apply a closure given the current `View`. Useful for iOS or platform availability checks.
    func apply<Content: View>(@ViewBuilder transform: (Self) -> Content) -> some View {
        transform(self)
    }
        
    /// Call a closure when the frame of the View changes.
    func onFrameChanged(_ onChange: @escaping (CGRect) -> Void) -> some View {
        background {
            GeometryReader { reader in
                Color.clear
                    .preference(key: FramePreferenceKey.self, value: reader.frame(in: .global))
            }
        }
        .onPreferenceChange(FramePreferenceKey.self, perform: onChange)
    }
    
    /// Make the current view pulse in opacity.
    func pulse() -> some View {
        modifier(PulseViewModifier())
    }
}

/// A View modifier to make the current view pulse in opacity.
struct PulseViewModifier: ViewModifier {

    @State
    private var isActive: Bool = false

    // Would typically pass in modifier to toggle pulsing and customization
    private let range: ClosedRange<Double> = 0.3 ... 1.0
    private let duration: TimeInterval = 1.0

    func body(content: Content) -> some View {
        content
            .opacity(isActive ? range.upperBound : range.lowerBound)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: duration)
                    .repeatForever(autoreverses: true)
                ) {
                    isActive = true
                }
            }
    }
}

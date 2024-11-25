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
}


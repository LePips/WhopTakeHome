//
//  PreferenceKeys.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import SwiftUI

/// A PreferenceKey for capturing the frame of a view.
struct FramePreferenceKey: PreferenceKey {

    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}

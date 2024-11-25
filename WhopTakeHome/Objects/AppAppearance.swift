//
//  AppAppearance.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import UIKit

/// An enum representing the possible appearances of the app.
enum AppAppearance: String, CaseIterable, Hashable {

    case system
    case dark
    case light

    /// The display title of the appearance.
    var displayTitle: String {
        switch self {
        case .system: "System"
        case .dark: "Dark"
        case .light: "Light"
        }
    }

    /// The `UIUserInterfaceStyle` that corresponds to the appearance.
    var style: UIUserInterfaceStyle {
        switch self {
        case .system: .unspecified
        case .dark: .dark
        case .light: .light
        }
    }
}

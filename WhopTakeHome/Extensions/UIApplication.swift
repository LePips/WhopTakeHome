//
//  UIApplication.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import UIKit

extension UIApplication {
    
    /// Sets the appearance of the main window.
    func setAppearance(_ newAppearance: UIUserInterfaceStyle) {
        guard let keyWindow else { return }

        UIView.transition(with: keyWindow, duration: 0.2, options: .transitionCrossDissolve) {
            keyWindow.overrideUserInterfaceStyle = newAppearance
        }
    }
}

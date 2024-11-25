//
//  UINavigationController.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import UIKit

extension UINavigationController {

    // Remove back button text.
    override open func viewWillLayoutSubviews() {
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}

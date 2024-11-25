//
//  MainCoordinator.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import SwiftUI

/// A basic coordinator for navigation from
/// the main view.
@Observable
class MainCoordinator {
    
    enum Destination: Hashable {
        case webView(WebsiteContent.StaticWebsite)
    }
    
    var path = NavigationPath()
    
    init() {}
    
    func push(_ destination: Destination) {
        path.append(destination)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}

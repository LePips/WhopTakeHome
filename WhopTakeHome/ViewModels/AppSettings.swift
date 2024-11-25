//
//  AppSettings.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import Foundation

@Observable
class AppSettings {
    
    /// Global shared observable instance.
    static let shared = AppSettings()
    
    /// The current appearance of the app.
    var appearance: AppAppearance = .system
    
    /// The amount of time an API call should take
    /// to load a page.
    var listPageLoadTime: TimeInterval = 2.0
    
    /// The probability that a web view will result
    /// in a forced error.
    var webContentErrorProbability: Double = 0.0
    
    /// The minimum number of seconds a web view should
    /// take to load its contents.
    var webContentMinimumLoadTime: TimeInterval = 0.0
}

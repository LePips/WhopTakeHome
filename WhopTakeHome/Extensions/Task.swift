//
//  Task.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import Combine

extension Task {
    
    /// Returns the current `Task` as an `AnyCancellable`.
    func asAnyCancellable() -> AnyCancellable {
        .init(cancel)
    }
}

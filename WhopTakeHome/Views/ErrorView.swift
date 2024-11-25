//
//  ErrorView.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import SwiftUI

struct ErrorView: View {
    
    let onRetry: () async -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 50))
                .fontWeight(.bold)
                .foregroundStyle(.orange)
            
            Text("Uh oh! Something went wrong.")
            
            Button("Retry") {
                Task {
                    await onRetry()
                }
            }
        }
    }
}

#Preview {
    ErrorView {}
}


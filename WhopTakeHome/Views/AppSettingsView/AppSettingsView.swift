//
//  AppSettingsView.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import SwiftUI

struct AppSettingsView: View {
    
    @Environment(\.dismiss)
    private var dismiss
    
    @Environment(AppSettings.self)
    private var appSettings: AppSettings
    
    var body: some View {
        NavigationStack {
            List {
                
                Picker(
                    "Apperance",
                    selection: appSettings.binding(for: \.appearance)
                ) {
                    ForEach(AppAppearance.allCases, id: \.self) { appearance in
                        Text(appearance.displayTitle)
                            .tag(appearance)
                    }
                }
                
                Section {
                    InlineStepper(
                        title: "Minimum page load time",
                        value: appSettings.binding(for: \.listPageLoadTime),
                        range: 0 ... 10,
                        step: 1,
                        format: .number
                    )
                } footer: {
                    Text("The amount of time an API call should take to load a page.")
                }
                
                Section {
                    InlineStepper(
                        title: "Error Probability",
                        value: appSettings.binding(for: \.webContentErrorProbability),
                        range: 0 ... 1.0,
                        step: 0.1,
                        format: .percent
                    )
                } footer: {
                    Text("The probability that a web view will result in a forced error.")
                }
                
                Section {
                    InlineStepper(
                        title: "Minimum web view load time",
                        value: appSettings.binding(for: \.webContentMinimumLoadTime),
                        range: 0 ... 10,
                        step: 1,
                        format: .number
                    )
                } footer: {
                    Text("The minimum number of seconds a web view should take to load its contents.")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                    .labelStyle(.iconOnly)
                    .fontWeight(.bold)
                }
            }
            .onChange(of: appSettings.appearance) { oldValue, newValue in
                UIApplication.shared.setAppearance(newValue.style)
            }
        }
    }
}

#Preview {
    AppSettingsView()
        .environment(AppSettings.shared)
}


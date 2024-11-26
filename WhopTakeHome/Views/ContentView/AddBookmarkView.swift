//
//  AddBookmarkView.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/26/24.
//

import SwiftUI

struct AddBookmarkView: View {
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State
    private var titleText: String = ""
    @State
    private var urlText: String = ""
//    @State
//    private var url: URL? = nil
    
    var isValid: Bool {
//        print(url)
//        guard let url else { return false }
//        return url.absoluteString.hasPrefix("http://") || url.absoluteString.hasPrefix("https://")
        
//        URL(string: urlText) != nil &&
//        urlText.hasPrefix("http://") || urlText.hasPrefix("https://")

        if let _ = try? URL.FormatStyle.Strategy().parse(urlText) {
            return urlText.hasPrefix("http://") || urlText.hasPrefix("https://")
        }
        
        return false
    }
    
    var isDuplicate: Bool {
        guard let newURL = try? URL.FormatStyle.Strategy().parse(urlText) else { return false }
        
        return viewModel.rows.contains { row in
            switch row {
            case .folder: return false
            case let .static(content):
                return content.url == newURL
            }
        }
    }
    
    var viewModel: ContentViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $titleText)
                    
//                    TextField("URL", value: $url, format: .url)
//                        .textInputAutocapitalization(.never)
//                        .keyboardType(.URL)
                    
                    TextField("URL", text: $urlText)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.URL)
                } footer: {
                    if !isValid {
                        Label("A valid http/https URL required.", systemImage: "exclamationmark.circle")
                            .foregroundStyle(.orange)
                    }
                    
                    if isDuplicate {
                        Label("URL is already a bookmark", systemImage: "exclamationmark.circle")
                            .foregroundStyle(.orange)
                    }
                }
            }
            .navigationTitle("Add Bookmark")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        guard let newURL = URL(string: urlText) else { return }
//                        guard let url else { return }
                        viewModel.addBookmark(titleText, url: newURL)
                        
                        dismiss()
                    }
                    .disabled(!isValid || isDuplicate)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

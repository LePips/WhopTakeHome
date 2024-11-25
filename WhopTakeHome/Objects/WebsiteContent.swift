//
//  WebsiteContent.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import Foundation

/// Model namespace for representing a website or a folder of websites.
indirect enum WebsiteContent: Identifiable, Equatable {
    
    case `static`(StaticWebsite)
    case folder(Folder)
    
    var title: String {
        switch self {
        case .static(let staticWebsite):
            staticWebsite.title
        case .folder(let folder):
            folder.title
        }
    }
    
    var id: UUID {
        switch self {
        case let .static(content):
            content.id
        case let .folder(content):
            content.id
        }
    }
    
    /// Model for a simple site with a row.
    struct StaticWebsite: Hashable, Identifiable {
        
        let id: UUID = UUID()
        let title: String
        let url: URL
    }
    
    /// Model for a folder with multiple sites.
    struct Folder: Hashable, Identifiable {
        
        let id: UUID = UUID()
        let title: String
        let contents: [StaticWebsite]
    }
}


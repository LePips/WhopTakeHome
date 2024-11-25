//
//  WebContentView.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import SwiftUI
import WebKit

struct WebContentView: View {
    
    @Environment(AppSettings.self)
    private var appSettings
    
    private var webViewProxy: StatefulWebViewProxy
    
    init(content: WebsiteContent.StaticWebsite) {
        self.webViewProxy = .init(content: content)
    }
    
    var body: some View {
        ZStack {
            // Main web view, but don't show if should not be
            // presenting content.
            StatefulWebView(proxy: webViewProxy, appSettings: appSettings)
                .opacity(webViewProxy.state == .content ? 1 : 0)
                .ignoresSafeArea(edges: .bottom)
            
            switch webViewProxy.state {
            case .content: EmptyView()
            case .error:
                ErrorView {
                    webViewProxy.reload()
                }
            case .loading:
                ProgressView()
            }
        }
        .animation(.linear(duration: 0.2), value: webViewProxy.state)
        .navigationTitle(webViewProxy.content.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Refresh", systemImage: "arrow.clockwise") {
                    webViewProxy.reload()
                }
            }
        }
    }
}

/// A proxy for a `StatefulWebView`.
@Observable
class StatefulWebViewProxy {
    
    let content: WebsiteContent.StaticWebsite
    var state: StatefulWebView.State
    
    @ObservationIgnored
    fileprivate weak var webView: WKWebView?
    
    init(content: WebsiteContent.StaticWebsite) {
        self.content = content
        self.state = .loading
        self.webView = nil
    }
    
    func cancel() {
        webView?.stopLoading()
    }
    
    func reload() {
        webView?.reload()
    }
}

struct StatefulWebView: UIViewRepresentable {
    
    /// The states of the web view.
    enum State {
        case content
        case error
        case loading
    }
    
    // Current app settings. Would typically be
    // injected through a factory method instead.
    private let appSettings: AppSettings
    
    /// The current proxy that contains the web site to view,
    /// the state of this web view, and can perform actions
    /// on this web view.
    private let proxy: StatefulWebViewProxy
    
    init(proxy: StatefulWebViewProxy, appSettings: AppSettings) {
        self.appSettings = appSettings
        self.proxy = proxy
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(proxy: proxy, appSettings: appSettings)
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        let webView = WKWebView()
        
        proxy.webView = webView
        
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: proxy.content.url))
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}

    class Coordinator: NSObject, WKNavigationDelegate {
        
        /// `AppSettings` passed into the parent view
        let appSettings: AppSettings
        /// Proxy for the parent view
        var proxy: StatefulWebViewProxy
        
        /// For demo purposes, instead of listening to the `WKWebView` navigation
        /// a separate system will handle the state
        var isPerformingDemoOverride: Bool = false
        
        /// For demo purposes, track when navigation has started
        var startNavigationDate: Date = .now
        
        init(proxy: StatefulWebViewProxy, appSettings: AppSettings) {
            self.appSettings = appSettings
            self.proxy = proxy
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            
            isPerformingDemoOverride = false
            proxy.state = .loading
            startNavigationDate = .now
            
            /// For demo purposes, may simulate an error along with a minimum reload time
            if Double.random(in: 0 ... 1.0) < appSettings.webContentErrorProbability {
                isPerformingDemoOverride = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + appSettings.webContentMinimumLoadTime) {
                    self.proxy.state = .error
                }
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            
            guard !isPerformingDemoOverride else { return }
            
            /// For demo purposes, simulate a minimum load time
            let loadInterval = Date.now.timeIntervalSince(startNavigationDate)
            
            if loadInterval < appSettings.webContentMinimumLoadTime {
                DispatchQueue.main.asyncAfter(deadline: .now() + appSettings.webContentMinimumLoadTime - loadInterval) {
                    self.proxy.state = .content
                }
            } else {
                proxy.state = .content
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
            
            guard !isPerformingDemoOverride else { return }
            
            proxy.state = .error
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
            
            guard !isPerformingDemoOverride else { return }
            
            proxy.state = .error
        }
    }
}

#Preview {
    NavigationStack {
        WebContentView(content: .init(title: "Apple", url: URL(string: "https://apple.com")!))
            .navigationBarTitleDisplayMode(.inline)
    }
    .environment(AppSettings.shared)
}

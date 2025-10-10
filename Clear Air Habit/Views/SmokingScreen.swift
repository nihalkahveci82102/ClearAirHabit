import SwiftUI
import WebKit

struct SmokingScreen: View {
    let contentPath: String
    @State private var isInitialLoading = true
    
    var body: some View {
        ZStack {
            ContentDisplayView(contentPath: contentPath, isLoading: $isInitialLoading)
                .ignoresSafeArea()
                .statusBar(hidden: true)
            
            if isInitialLoading {
                Color.black.ignoresSafeArea()
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
            }
        }
    }
}

struct ContentDisplayView: UIViewRepresentable {
    let contentPath: String
    @Binding var isLoading: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = preferences
        
        let contentView = WKWebView(frame: .zero, configuration: configuration)
        contentView.scrollView.contentInsetAdjustmentBehavior = .never
        contentView.isOpaque = false
        contentView.backgroundColor = .black
        contentView.navigationDelegate = context.coordinator
        
        return contentView
    }
    
    func updateUIView(_ contentView: WKWebView, context: Context) {
        guard let requestPath = URL(string: contentPath) else { return }
        let request = URLRequest(url: requestPath)
        contentView.load(request)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: ContentDisplayView
        
        init(_ parent: ContentDisplayView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
    }
}


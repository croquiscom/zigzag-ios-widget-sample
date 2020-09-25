import UIKit
import WebKit

final class MainViewController: UIViewController {
    let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    let webview: WKWebView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view = webview

        webview.navigationDelegate = self
        webview.load(URLRequest(url: URL(string: "https://zigzag.kr")!))

        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = .systemPink
        view.addSubview(activityIndicatorView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicatorView.center = view.center
    }
}

extension MainViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        activityIndicatorView.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicatorView.stopAnimating()
    }
}

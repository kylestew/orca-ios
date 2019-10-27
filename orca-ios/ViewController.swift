import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!

    override var prefersStatusBarHidden: Bool {
        get { return true }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "")!
        let request = URLRequest(url: url)

        // bypass CORS
        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")

        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        webView.load(request)
        webView.becomeFirstResponder()
    }
}


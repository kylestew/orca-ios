import UIKit
import WebKit

class ViewController: UIViewController, OrcaJSBridgeDelegate {

    @IBOutlet weak var webView: WKWebView!
    let jsBridge = OrcaJSBridge()

    override var prefersStatusBarHidden: Bool {
        get { return true }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // JS bridge
        jsBridge.delegate = self
        jsBridge.attach(webView)

        // bypass CORS
        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")

        embedMenu()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "")!
        let request = URLRequest(url: url)
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        webView.load(request)
        webView.becomeFirstResponder()
    }

    // MARK: - ORCA JS Bridge

    func jsBridgeMenuDidUpdate(info: [[String: Any]]?) {
        menuViewController.bind(info)
    }

    // MARK: - Menu

    @IBOutlet weak var menuViewContainer: UIView!
    let menuViewController = MenuViewController()

    func embedMenu() {
        addChild(menuViewController)
        menuViewContainer.addSubview(menuViewController.view)
        menuViewController.view.frame = menuViewContainer.bounds
        menuViewController.didMove(toParent: self)

        menuViewController.jsBridge = jsBridge
    }
}

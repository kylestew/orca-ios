import WebKit

protocol OrcaJSBridgeDelegate {
    func jsBridgeMenuDidUpdate(info: [[String: Any]]?)
}

class OrcaJSBridge : NSObject, WKScriptMessageHandler {

    var delegate: OrcaJSBridgeDelegate?
    weak var webView: WKWebView?
    let webViewDelegate = WebViewDelegate()

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func attach(_ webView: WKWebView) {
        self.webView = webView

        // register callbacks
        let controller = webView.configuration.userContentController
        controller.add(self, name: "menuDidUpdate")

        injectMIDIPolyfill(controller)
    }

    // MARK: - JS Message Reciever

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "menuDidUpdate":
            if let jsonString = message.body as? String {
                parseMenu(jsonString)
            }
            return
        default: break
        }

        // pass on to MIDI handler
        webViewDelegate.userContentController(userContentController, didReceive: message)
    }

    // MARK: - MIDI

    private func injectMIDIPolyfill(_ controller: WKUserContentController) {
        // inject polyfill script
        let url = Bundle.main.url(forResource: "WebMIDIAPIPolyfill", withExtension: ".js", subdirectory: "ios")!
        let scriptString = try! String.init(contentsOf: url)
        let script = WKUserScript.init(source: scriptString, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        controller.addUserScript(script)

        // register callbacks
        controller.add(self, name: "onready")
        controller.add(self, name: "send")
        controller.add(self, name: "clear")

        // TEMP: encapsulate this
        webViewDelegate.midiDriver = MIDIDriver()
    }

    // MARK: - Menu

    private var menu: [[String: Any]]?

    private func parseMenu(_ menuString: String) {
        guard let data = menuString.data(using: .utf8) else {
            return
        }

        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            self.menu = json
            delegate?.jsBridgeMenuDidUpdate(info: json)
        } catch {
            print(error.localizedDescription)
        }
    }

    func runMenuCommand(menu: String, item: String) {
        webView?.evaluateJavaScript("require('electron').remote.app.invokeMenuItem(\"\(menu)\", \"\(item)\")") { (result, error) in
            assert(error == nil, error!.localizedDescription)
        }
    }
}

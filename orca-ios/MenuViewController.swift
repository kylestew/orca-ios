import UIKit

class MenuViewController: UIViewController {

    var stackView: UIStackView!
    var jsBridge: OrcaJSBridge?
    var acceleratorStore: AcceleratorStore!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0.0
        stackView.distribution = .fillEqually
        self.stackView = stackView

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    // MARK: - Bind Menu

    private let exclude = [
        "*",
        //        "File",
        //        "Edit",
        //        "Clock",
        //        "UDP",
        //        "OSC",
        //        "Theme"
    ]

    private var menu = [String:[String]]()

    func bind(_ info: [[String: Any]]?) {
        // clear existing
        for view in stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        menu = [String:[String]]()

        guard let info = info else {
            return
        }

        for item in info {
            if let menuLabel = item["label"] as? String,
                !exclude.contains(menuLabel),
                let submenu = item["submenu"] as? [[String: Any]] {

                // parse submenu titles
                var subs = [String]()
                for subitem in submenu {
                    if let label = subitem["label"] as? String {
                        subs.append(label)
                        if let accelerator = subitem["accelerator"] as? String {
                            acceleratorStore.add(accelerator, menu: menuLabel, label: label)
                        }
                    }
                }
                menu[menuLabel] = subs

                let button = createMenuButton(label: menuLabel)
                stackView.addArrangedSubview(button)
            }
        }
    }
}

// MARK: - Private
extension MenuViewController {
    @objc func menuButtonTapped(sender: UIButton!) {
        guard let label = sender.titleLabel?.text else {
            return
        }
        openSubmenu(label)
    }

    func activateMenuItem(menu: String, item: String) {
        jsBridge?.runMenuCommand(menu: menu, item: item)
    }

    private func openSubmenu(_ label: String) {
        guard let items = menu[label] else {
            return
        }

        let submenu = UIAlertController.init(title: label, message: nil, preferredStyle: .actionSheet)

        for item in items {
            submenu.addAction(UIAlertAction(title: item, style: .default, handler: { [weak self] action in
                self?.activateMenuItem(menu: label, item: item)
            }))
        }

        submenu.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // iPad
        if let popoverController = submenu.popoverPresentationController {
            let pView = parent?.view ?? view!
            popoverController.sourceView = pView
            popoverController.sourceRect = CGRect(x: pView.bounds.midX, y: pView.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        present(submenu, animated: true)
    }

    private func createMenuButton(label: String) -> UIButton {
        let button = UIButton()
        button.setTitle(label, for: .normal)
        button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        return button
    }
}

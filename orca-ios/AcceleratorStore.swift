import UIKit

class AcceleratorStore {

    private var commands = [UIKeyCommand]()

    func add(_ accelerator: String, menu: String, label: String) {

        // TODO: handle ALT and others
        // maybe add a filter list to not squash local CMDs

        if accelerator.starts(with: "CmdOrCtrl+") {
            let cmd = UIKeyCommand(title: label,
                                   image: nil,
                                   action: #selector(invokeAccelerator(_:)),
                                   input: String(accelerator.last!),
                                   modifierFlags: .command,
                                   propertyList: ["menu": menu, "label": label])
            commands.append(cmd)
        }
    }

    func all() -> [UIKeyCommand] {
        return commands
    }

    @objc func invokeAccelerator(_ sender: UIKeyCommand) {
        // DUMMY placed here to make the compiler happy - real invokation is in ViewController
    }
}

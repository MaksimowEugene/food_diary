import UIKit

func createButton(withTitle title: String, target: Any?, action: Selector) -> UIButton {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(title, for: .normal)
    button.backgroundColor = UIColor.systemBlue
    button.layer.cornerRadius = 8
    button.addTarget(target, action: action, for: .touchUpInside)
    return button
}

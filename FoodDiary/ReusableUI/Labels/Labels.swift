import UIKit

func createLabel(withText text: String) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = text
    label.font = UIFont.systemFont(ofSize: 16)
    label.textAlignment = .center
    return label
}

import UIKit

func createTextField(placeholder: String, borderStyle: UITextField.BorderStyle, keyboardType: UIKeyboardType) -> UITextField {
    let textField = UITextField()
    textField.placeholder = placeholder
    textField.borderStyle = borderStyle
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.keyboardType = keyboardType
    return textField
}

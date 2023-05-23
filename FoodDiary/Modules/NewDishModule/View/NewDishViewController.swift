import UIKit

class NewDishViewController: UIViewController {
    
    lazy var productNameTextField: UITextField = createTextField(placeholder: "Product name", borderStyle: .roundedRect, keyboardType: .namePhonePad)
    lazy var calsTextField: UITextField = createTextField(placeholder: "Calories", borderStyle: .roundedRect, keyboardType: .decimalPad)
    lazy var proteinsTextField: UITextField = createTextField(placeholder: "Proteins", borderStyle: .roundedRect, keyboardType: .decimalPad)
    lazy var fatsTextField: UITextField = createTextField(placeholder: "Fats", borderStyle: .roundedRect, keyboardType: .decimalPad)
    lazy var carbsTextField: UITextField = createTextField(placeholder: "Carbs", borderStyle: .roundedRect, keyboardType: .decimalPad)
    lazy var addButton: UIButton = createButton(withTitle: "Add", target: self, action: #selector(addButtonTapped))
    
    var presenter: NewDishPresenter
    
    init(presenter: NewDishPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            productNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            productNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            productNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            calsTextField.topAnchor.constraint(equalTo: productNameTextField.bottomAnchor, constant: 16),
            calsTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            calsTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            proteinsTextField.topAnchor.constraint(equalTo: calsTextField.bottomAnchor, constant: 16),
            proteinsTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            proteinsTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            fatsTextField.topAnchor.constraint(equalTo: proteinsTextField.bottomAnchor, constant: 16),
            fatsTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            fatsTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            carbsTextField.topAnchor.constraint(equalTo: fatsTextField.bottomAnchor, constant: 16),
            carbsTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            carbsTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addButton.topAnchor.constraint(equalTo: carbsTextField.bottomAnchor, constant: 16),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(productNameTextField)
        view.addSubview(calsTextField)
        view.addSubview(proteinsTextField)
        view.addSubview(fatsTextField)
        view.addSubview(carbsTextField)
        view.addSubview(addButton)
    }
    
    @objc private func addButtonTapped() {
        guard let dishName = productNameTextField.text,
              let calsString = calsTextField.text,
              let cals = Double(calsString),
              let proteinsString = proteinsTextField.text,
              let proteins = Double(proteinsString),
              let fatsString = fatsTextField.text,
              let fats = Double(fatsString),
              let carbsString = carbsTextField.text,
              let carbs = Double(carbsString)
        else {
            let alert = UIAlertController(title: "Error", message: "Please fill out all fields with valid data.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        let newDishModel = NewDishModel(dishName: dishName, cals: cals, proteins: proteins, fats: fats, carbs: carbs)
        presenter.addDish(newDishModel: newDishModel)
        navigationController?.popViewController(animated: true)
    }
}

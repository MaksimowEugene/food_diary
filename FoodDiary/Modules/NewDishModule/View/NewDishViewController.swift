import UIKit

class NewDishViewController: UIViewController {

    lazy var productNameTextField: UITextField = {
        let productNameTextField = UITextField()
        productNameTextField.placeholder = "Product Name"
        productNameTextField.borderStyle = .roundedRect
        productNameTextField.translatesAutoresizingMaskIntoConstraints = false
        return productNameTextField
    }()
    
    lazy var calsTextField: UITextField = {
        let calsTextField = UITextField()
        calsTextField.placeholder = "Calories"
        calsTextField.borderStyle = .roundedRect
        calsTextField.translatesAutoresizingMaskIntoConstraints = false
        calsTextField.keyboardType = .decimalPad
        return calsTextField
    }()
    
    lazy var proteinsTextField: UITextField = {
        let proteinsTextField = UITextField()
        proteinsTextField.placeholder = "Proteins"
        proteinsTextField.borderStyle = .roundedRect
        proteinsTextField.translatesAutoresizingMaskIntoConstraints = false
        proteinsTextField.keyboardType = .decimalPad
        return proteinsTextField
    }()
    
    lazy var fatsTextField: UITextField = {
        let fatsTextField = UITextField()
        fatsTextField.placeholder = "Fats"
        fatsTextField.borderStyle = .roundedRect
        fatsTextField.translatesAutoresizingMaskIntoConstraints = false
        fatsTextField.keyboardType = .decimalPad
        return fatsTextField
    }()
    
    lazy var carbsTextField: UITextField = {
        let carbsTextField = UITextField()
        carbsTextField.placeholder = "Carbs"
        carbsTextField.borderStyle = .roundedRect
        carbsTextField.translatesAutoresizingMaskIntoConstraints = false
        carbsTextField.keyboardType = .decimalPad
        return carbsTextField
    }()
    
    lazy var addButton: UIButton = {
        let addButton = UIButton()
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(.systemBlue, for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        return addButton
    }()
    
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
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        view.addSubview(addButton)
    }
    
    @objc private func addButtonTapped() {
        
//        if calsTextField.hasText && fatsTextField.hasText && carbsTextField.hasText && 
//        let newDishModel = NewDishModel(dishName: <#String#>, cals: <#String#>, proteins: <#String#>, fats: <#String#>, carbs: <#String#>)
//        
//        else {
//            let alert = UIAlertController(title: "Error", message: "Please fill out all fields with valid data.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            //present(alert, animated: true, completion: nil)
//            return
//        }
//        presenter.addDish()
        //        let context = CoreDataStack.shared.context
        //
        //        guard let dishName = productNameTextField.text,
        //              let calsString = calsTextField.text,
        //              let cals = Double(calsString),
        //              let proteinsString = proteinsTextField.text,
        //              let proteins = Double(proteinsString),
        //              let fatsString = fatsTextField.text,
        //              let fats = Double(fatsString),
        //              let carbsString = carbsTextField.text,
        //              let carbs = Double(carbsString)
        //        else {
        //            let alert = UIAlertController(title: "Error", message: "Please fill out all fields with valid data.", preferredStyle: .alert)
        //            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //            present(alert, animated: true, completion: nil)
        //            return
        //        }
        //
        //        let dish = Dishes(context: context)
        //        dish.id = UUID()
        //        dish.name = dishName
        //        dish.cals = cals as Double
        //        dish.protein = proteins as Double
        //        dish.fats = fats as Double
        //        dish.carbohydrates = carbs as Double
        //
        //        do {
        //            try context.save()
        //            navigationController?.popViewController(animated: true)
        //        } catch {
        //        }
        //    }
    }
}

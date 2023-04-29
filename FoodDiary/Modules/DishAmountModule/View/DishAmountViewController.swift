import UIKit
import CoreData

private struct Constants {
    static let translatesAutoresizingMaskIntoConstraints = false
    static let save = "Save"
    static let cornerRadius: CGFloat = 8
    static let buttonBackgroundColor: UIColor = .systemBlue
    static let backgroundColor: UIColor = .systemBackground
    static let labelFont: UIFont = .boldSystemFont(ofSize: 20)
    static let stepperMinimumValue: Double = 1
    static let stepperMaximumValue: Double = 10000
    static let stepperStepValue: Double = 1
    static let anchor: CGFloat = 16
    static let sizeAnchor: CGFloat = 44
    static let buttonWidthAnchor: CGFloat = 120
    static let grammText = " g"
}

class DishAmountViewController: UIViewController {
    let presenter: DishAmountPresenterProtocol
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = Constants.translatesAutoresizingMaskIntoConstraints
        label.text = presenter.name
        label.font = Constants.labelFont
        label.textAlignment = .center
        return label
    }()
    
    lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = Constants.translatesAutoresizingMaskIntoConstraints
        stepper.minimumValue = Constants.stepperMinimumValue
        stepper.maximumValue = Constants.stepperMaximumValue
        stepper.stepValue = Constants.stepperStepValue
        stepper.value = presenter.grams
        return stepper
    }()
    
    lazy var gramsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = Constants.translatesAutoresizingMaskIntoConstraints
        label.text = "\(presenter.grams)" + Constants.grammText
        label.textAlignment = .center
        return label
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = Constants.translatesAutoresizingMaskIntoConstraints
        button.setTitle(Constants.save, for: .normal)
        button.backgroundColor = Constants.buttonBackgroundColor
        button.layer.cornerRadius = Constants.cornerRadius
        button.addTarget(self, action: #selector(didTapSaveButton(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        view.addSubview(stepper)
        view.addSubview(gramsLabel)
        view.addSubview(saveButton)
        view.backgroundColor = Constants.backgroundColor
        configureConstraints()
        stepper.addTarget(self, action: #selector(didChangeStepperValue(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if modalPresentationStyle == .pageSheet {
            presentingViewController?.beginAppearanceTransition(false, animated: animated)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if modalPresentationStyle == .pageSheet {
            presentingViewController?.endAppearanceTransition()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if modalPresentationStyle == .pageSheet {
            presentingViewController?.beginAppearanceTransition(true, animated: animated)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if modalPresentationStyle == .pageSheet {
            presentingViewController?.endAppearanceTransition()
        }
    }
    
    init(presenter: DishAmountPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.anchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.anchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.anchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.sizeAnchor),
            stepper.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stepper.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.anchor),
            gramsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.anchor),
            gramsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.anchor),
            gramsLabel.topAnchor.constraint(equalTo: stepper.bottomAnchor, constant: Constants.anchor),
            gramsLabel.heightAnchor.constraint(equalToConstant: Constants.sizeAnchor),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.anchor),
            saveButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidthAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: Constants.sizeAnchor)
        ])
    }
    
    @objc func didTapDone() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didChangeStepperValue(_ stepper: UIStepper) {
        presenter.grams = stepper.value
        gramsLabel.text = "\(presenter.grams)" + Constants.grammText
    }
    
    @objc func didTapSaveButton(_ sender: UIButton) {
        
        if presenter.dishMeal.mass != 0 {
            // Update the existing dish
            CoreDataStack.shared.updateDish(dishId: presenter.dishMeal.dishId, mealId: presenter.dishMeal.mealId, mass: Int64(presenter.grams))
        } else {
            CoreDataStack.shared.createDish(mealId: presenter.dishMeal.mealId, dishId: presenter.dishMeal.dishId, grams: Int64(presenter.grams))
        }
        
        dismiss(animated: true, completion: nil)
    }
}

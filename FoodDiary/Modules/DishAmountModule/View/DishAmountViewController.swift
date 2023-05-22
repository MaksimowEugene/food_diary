import UIKit
import CoreData

private struct Constants {
    static let save = "Save"
    static let backgroundColor: UIColor = .systemBackground
    static let stepperMinimumValue: Double = 1
    static let stepperMaximumValue: Double = 10000
    static let stepperStepValue: Double = 1
    static let anchor: CGFloat = 16
    static let sizeAnchor: CGFloat = 44
    static let buttonWidthAnchor: CGFloat = 120
}

class DishAmountViewController: UIViewController {
    let presenter: DishAmountPresenterProtocol
    
    lazy var titleLabel: UILabel = createLabel(withText: presenter.name)
    
    lazy var stepper: UIStepper = createStepper(minimumValue: Constants.stepperMinimumValue, maximumValue: Constants.stepperMaximumValue, stepValue: Constants.stepperStepValue, initialValue: presenter.grams)
    
    lazy var gramsLabel: UILabel = createLabel(withText: presenter.getGramsLabelText() )
    
    lazy var saveButton: UIButton = createButton(withTitle: Constants.save, target: self,
                                                 action:  #selector(didTapSaveButton(_:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        view.backgroundColor = Constants.backgroundColor
        configureConstraints()
        stepper.addTarget(self, action: #selector(didChangeStepperValue(_:)), for: .valueChanged)
    }
    
    func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(stepper)
        view.addSubview(gramsLabel)
        view.addSubview(saveButton)
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
        presenter.stepperValueChanged(stepperValue: stepper.value)
        gramsLabel.text = presenter.getGramsLabelText()
    }
    
    @objc func didTapSaveButton(_ sender: UIButton) {
        presenter.saveButtonTapped()
        dismiss(animated: true, completion: nil)
    }
}

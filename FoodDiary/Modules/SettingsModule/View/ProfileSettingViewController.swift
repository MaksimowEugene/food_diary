import UIKit
import Security

private struct Constants {
    static let navTitle = "Settings"
    static let nameLabelText = "Guest"
    static let cornerRadius: CGFloat = 100
    static let profilePhoto = UIImage.imageWithColor(color: UIColor.lightGray, size: CGSize(width: 1, height: 1))
    static let mealCell = "mealCell"
    static let imageViewSize: CGFloat = 200
    static let staticAnchor: CGFloat = 20
    static let clipsToBounds: Bool = true
    static let translatesAutoresizingMaskIntoConstraints: Bool = false
    static let labelFont = UIFont.systemFont(ofSize: 24, weight: .bold)
}

private struct KeychainKeys {
    static let name = "Name"
    static let weight = "Weight"
    static let weightGoal = "WeightGoal"
    static let age = "Age"
    static let gender = "Gender"
    static let activityLevel = "ActivityLevel"
    static let dailyCalorieNeeds = "DailyCalorieNeeds"
}

private struct InputValidationResult {
    let isValid: Bool
    let errorMessage: String?
}

enum Gender: Int {
    case male
    case female
}

enum ActivityLevel: Int {
    case Low
    case Mid
    case High
    case Int
}

class ProfileSettingsViewController: UIViewController, UIPickerViewDelegate, ProfileSettingsViewProtocol {
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isEnabled = false
        textField.enablesReturnKeyAutomatically = true
        textField.returnKeyType = .done
        return textField
    }()
    
    lazy var recommendedCaloriesLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.labelFont
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var weightTextField: UITextField = createTextField(placeholder: "Weight (kg)", borderStyle: .roundedRect, keyboardType: .numberPad)
    lazy var weightGoalTextField: UITextField = createTextField(placeholder: "Weight Goal (kg)", borderStyle: .roundedRect, keyboardType: .numberPad)
    lazy var ageTextField: UITextField = createTextField(placeholder: "Age", borderStyle: .roundedRect, keyboardType: .numberPad)
    lazy var genderSegmentedControl: UISegmentedControl = createSegmentedControl(items: ["Male", "Female"], selectedSegmentIndex: 0, isEnabled: false)
    lazy var activityLevelSegmentedControl: UISegmentedControl = createSegmentedControl(items: ["Low", "Mid", "High", "Int"],
                                                                                        selectedSegmentIndex: 0, isEnabled: false)
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(nameTextField)
        view.addSubview(weightTextField)
        view.addSubview(weightGoalTextField)
        view.addSubview(ageTextField)
        view.addSubview(genderSegmentedControl)
        view.addSubview(activityLevelSegmentedControl)
        view.addSubview(recommendedCaloriesLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.staticAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageViewSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageViewSize),
            nameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.staticAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.staticAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.staticAnchor),
            weightTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: Constants.staticAnchor),
            weightTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.staticAnchor),
            weightTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.staticAnchor),
            weightGoalTextField.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: Constants.staticAnchor),
            weightGoalTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.staticAnchor),
            weightGoalTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.staticAnchor),
            ageTextField.topAnchor.constraint(equalTo: weightGoalTextField.bottomAnchor, constant: Constants.staticAnchor),
            ageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.staticAnchor),
            ageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.staticAnchor),
            genderSegmentedControl.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: Constants.staticAnchor),
            genderSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.staticAnchor),
            genderSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.staticAnchor),
            activityLevelSegmentedControl.topAnchor.constraint(equalTo: genderSegmentedControl.bottomAnchor, constant: Constants.staticAnchor),
            activityLevelSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.staticAnchor),
            activityLevelSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.staticAnchor),
            recommendedCaloriesLabel.topAnchor.constraint(equalTo: activityLevelSegmentedControl.bottomAnchor, constant: Constants.staticAnchor),
            recommendedCaloriesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.staticAnchor),
            recommendedCaloriesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.staticAnchor),
        ])
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = Constants.profilePhoto
        imageView.translatesAutoresizingMaskIntoConstraints = Constants.translatesAutoresizingMaskIntoConstraints
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.clipsToBounds = Constants.clipsToBounds
        return imageView
    }()
    
    var router: RouterProtocol?
    var presenter: SettingsPresenterProtocol
    
    init(presenter: SettingsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.fetchMealsArray()
        if let data = UserDefaults.standard.data(forKey: "profileImage"), let image = UIImage(data: data) {
            imageView.image = image
        }
        setupViews()
        setupConstraints()
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editButton
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        weightTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        ageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        genderSegmentedControl.addTarget(self, action: #selector(segmentedControlDidChange(_:)), for: .valueChanged)
        activityLevelSegmentedControl.addTarget(self, action: #selector(segmentedControlDidChange(_:)), for: .valueChanged)
        loadSavedValues()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateRecommendedCalories()
    }

    @objc private func segmentedControlDidChange(_ segmentedControl: UISegmentedControl) {
        updateRecommendedCalories()
    }
    
    private func loadSavedValues() {
        
        if let dailyCalorieNeeds = loadDataFromKeychain(forKey: KeychainKeys.dailyCalorieNeeds) {
            recommendedCaloriesLabel.text = "Recommended Calories:\n\(dailyCalorieNeeds)"
        }
        if let username = loadDataFromKeychain(forKey: KeychainKeys.name) {
            nameTextField.text = username
        }
        if let weight = loadDataFromKeychain(forKey: KeychainKeys.weight) {
            weightTextField.text = weight
        }
        if let weightGoal = loadDataFromKeychain(forKey: KeychainKeys.weightGoal) {
            weightGoalTextField.text = weightGoal
        }
        if let age = loadDataFromKeychain(forKey: KeychainKeys.age) {
            ageTextField.text = age
        }
        if let genderIndex = loadDataFromKeychain(forKey: KeychainKeys.gender) {
            genderSegmentedControl.selectedSegmentIndex = Int(genderIndex) ?? 0
        }
        if let activityLevelIndex = loadDataFromKeychain(forKey: KeychainKeys.activityLevel) {
            activityLevelSegmentedControl.selectedSegmentIndex = Int(activityLevelIndex) ?? 0
        }
        
        updateRecommendedCalories()
    }
    
    private func updateRecommendedCalories() {
        guard let ageText = ageTextField.text,
              let weightText = weightTextField.text,
              let gender = Gender(rawValue: genderSegmentedControl.selectedSegmentIndex),
              let age = Int(ageText),
              let weight = Double(weightText)
        else { return }
        let activityLevel = activityLevelSegmentedControl.selectedSegmentIndex + 1
        let dailyCalorieNeeds = calculateDailyCalorieNeeds(age: age, weight: weight, gender: gender, activityLevel: activityLevel)
        recommendedCaloriesLabel.text = "Recommended Calories:\n\(Int(dailyCalorieNeeds))"
        saveCaloriesInput(calorieNeeds: dailyCalorieNeeds)
    }

    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in completion?() }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func imageViewTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        actionSheet.addAction(takePhotoAction)
        let choosePhotoAction = UIAlertAction(title: "Choose Photo", style: .default) { _ in
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        actionSheet.addAction(choosePhotoAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func editButtonTapped() {
        if nameTextField.isEnabled {
            guard validateInputData() else { return }
            navigationItem.rightBarButtonItem?.title = "Edit"
            saveUserInput()
            updateRecommendedCalories()
        } else {
            navigationItem.rightBarButtonItem?.title = "Finish editing"
            nameTextField.becomeFirstResponder()
        }
        toggleInputFieldsEnabled()
    }
    
    private func validateInputData() -> Bool {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(title: "Invalid Input", message: "Please enter a name.", completion: nil)
            return false
        }
        
        guard let ageText = ageTextField.text, let age = Int(ageText), age > 0 else {
            showAlert(title: "Invalid Input", message: "Please enter a valid age.", completion: nil)
            return false
        }
        
        guard let weightText = weightTextField.text, let weight = Double(weightText), weight > 0 else {
            showAlert(title: "Invalid Input", message: "Please enter a valid weight.", completion: nil)
            return false
        }
        
        return true
    }
    
    private func saveUserInput() {
        if let username = nameTextField.text {
            saveDataToKeychain(value: username, forKey: KeychainKeys.name)
        }
        if let weight = weightTextField.text {
            saveDataToKeychain(value: weight, forKey: KeychainKeys.weight)
        }
        if let weightGoal = weightGoalTextField.text {
            saveDataToKeychain(value: weightGoal, forKey: KeychainKeys.weightGoal)
        }
        if let age = ageTextField.text {
            saveDataToKeychain(value: age, forKey: KeychainKeys.age)
        }
        let gender = String(genderSegmentedControl.selectedSegmentIndex)
        saveDataToKeychain(value: gender, forKey: KeychainKeys.gender)
        
        let activityLevel = String(activityLevelSegmentedControl.selectedSegmentIndex)
        saveDataToKeychain(value: activityLevel, forKey: KeychainKeys.activityLevel)
    }

    private func saveCaloriesInput(calorieNeeds: Double) {
        saveDataToKeychain(value: String(calorieNeeds), forKey: KeychainKeys.dailyCalorieNeeds)
    }
    
    private func toggleInputFieldsEnabled() {
        nameTextField.isEnabled.toggle()
        weightTextField.isEnabled.toggle()
        weightGoalTextField.isEnabled.toggle()
        ageTextField.isEnabled.toggle()
        genderSegmentedControl.isEnabled.toggle()
        activityLevelSegmentedControl.isEnabled.toggle()
    }
    
    private func calculateDailyCalorieNeeds(age: Int, weight: Double, gender: Gender, activityLevel: Int) -> Double {
        var bmr: Double
        if gender == .male {
            bmr = 10 * weight + 6.25 * Double(age) - 5 * Double(age) + 5
        } else {
            bmr = 10 * weight + 6.25 * Double(age) - 5 * Double(age) - 161
        }
        let dailyCalorieNeeds = bmr * Double(activityLevel)
        return dailyCalorieNeeds
    }
}

extension ProfileSettingsViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            saveProfileImage(image: image)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func saveProfileImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        imageView.image = image
        UserDefaults.standard.set(imageData, forKey: "profileImage")
    }
}

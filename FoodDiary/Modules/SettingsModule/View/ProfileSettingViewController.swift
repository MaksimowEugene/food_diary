import UIKit

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

private struct UserDefaultsKeys {
    static let name = "Name"
    static let weight = "Weight"
    static let weightGoal = "WeightGoal"
}

class ProfileSettingsViewController: UIViewController, UIPickerViewDelegate, ProfileSettingsViewProtocol {
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isEnabled = false
        textField.enablesReturnKeyAutomatically = true
        textField.returnKeyType = .done
        return textField
    }()
    
    let weightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Weight (kg)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isEnabled = false
        return textField
    }()
    
    let weightGoalTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Weight Goal (kg)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isEnabled = false
        return textField
    }()
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(nameTextField)
        view.addSubview(weightTextField)
        view.addSubview(weightGoalTextField)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:  Constants.staticAnchor),
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

        
        // Load the saved values from UserDefaults
        nameTextField.text = UserDefaults.standard.string(forKey: UserDefaultsKeys.name)
        weightTextField.text = UserDefaults.standard.string(forKey: UserDefaultsKeys.weight)
        weightGoalTextField.text = UserDefaults.standard.string(forKey: UserDefaultsKeys.weightGoal)
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
            navigationItem.rightBarButtonItem?.title = "Edit"
            UserDefaults.standard.set(nameTextField.text, forKey: UserDefaultsKeys.name)
            UserDefaults.standard.set(weightTextField.text, forKey: UserDefaultsKeys.weight)
            UserDefaults.standard.set(weightGoalTextField.text, forKey: UserDefaultsKeys.weightGoal)
        } else {
            navigationItem.rightBarButtonItem?.title = "Finish editing"
        }
        nameTextField.isEnabled.toggle()
        weightTextField.isEnabled.toggle()
        weightGoalTextField.isEnabled.toggle()
    }
}

extension ProfileSettingsViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            saveProfileImage(image: image)
        }
        dismiss(animated: true, completion: nil)
    }
    private func saveProfileImage(image: UIImage) {
            guard let imageData = image.jpegData(compressionQuality: 1) else {
                return
            }
            imageView.image = image
            UserDefaults.standard.set(imageData, forKey: "profileImage")
        }
}

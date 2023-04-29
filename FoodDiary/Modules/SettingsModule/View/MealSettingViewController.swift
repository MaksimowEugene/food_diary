import UIKit

private struct Constants {
    static let navTitle = "Settings"
    static let nameLabelText = "Guest"
    static let cornerRadius: CGFloat = 10
    static let mealCell = "mealCell"
    static let staticAnchor: CGFloat = 20
    static let clipsToBounds: Bool = true
    static let translatesAutoresizingMaskIntoConstraints: Bool = false
    static let editButtonTitle = "Edit"
    static let doneButtonTitle = "Done"
    static let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
}

class MealSettingsViewController: UIViewController, MealSettingsViewProtocol, UITableViewDataSource, UITableViewDelegate {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = Constants.translatesAutoresizingMaskIntoConstraints
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = true
        tableView.isEditing.toggle()
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelectionDuringEditing = true
        return tableView
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
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        view.backgroundColor = .systemBackground
        self.navigationItem.title = Constants.navTitle
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.mealCell)
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: "Are you sure you want to delete this meal?", message: nil, preferredStyle: .alert)
            alertController.addAction(Constants.cancelAction)
            alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self.presenter.deleteQueue(row: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }))
            self.present(alertController, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alertController = UIAlertController(title: "Change Meal Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = self.presenter.mealsArray[indexPath.row]
            
        }
        alertController.addAction(Constants.cancelAction)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let text = alertController.textFields?.first?.text {
                self.presenter.handleCellClick(row: indexPath.row, text: text)
                tableView.reloadData()
            }
        }))
        present(alertController, animated: true)
    }
    
    @objc private func addButtonTapped() {
        let alertController = UIAlertController(title: "Add a meal:", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Meal name"
            textField.text = ""
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let text = alertController.textFields?.first?.text, text != "" && self.presenter.checkIfQueueExists(text: text) {
                self.presenter.createNewQueue(text: text)
                self.presenter.fetchMealsArray()
                self.tableView.reloadData()
                alertController.dismiss(animated: true)
            } else {
                if let textField = alertController.textFields?.first {
                    self.shakeTextField(textField)
                }
            }
        }))
        present(alertController, animated: true)
    }

    func shakeTextField(_ textField: UITextField) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 3
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 10, y: textField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 10, y: textField.center.y))
        textField.layer.add(animation, forKey: "position")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.mealCell, for: indexPath)
        cell.textLabel?.text = presenter.mealsArray[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        presenter.handleMealMove(sourceIndexPathRow: sourceIndexPath.row, destinationIndexPathRow: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.mealsArrayCount()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
    return false
    }

    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    @objc func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField.text != "" {
//            shakeTextField(textField)
//        }
//    }
//
//    func shakeTextField(_ textField: UITextField) {
//        let shake = CABasicAnimation(keyPath: "position")
//        shake.duration = 0.1
//        shake.repeatCount = 2
//        shake.autoreverses = true
//        let fromPoint = CGPoint(x: textField.center.x - 10, y: textField.center.y)
//        let toPoint = CGPoint(x: textField.center.x + 10, y: textField.center.y)
//        shake.fromValue = NSValue(cgPoint: fromPoint)
//        shake.toValue = NSValue(cgPoint: toPoint)
//
//        textField.layer.add(shake, forKey: "position")
//    }
    
}

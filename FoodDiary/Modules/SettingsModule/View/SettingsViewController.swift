import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate,
                                SettingsViewProtocol, UITableViewDataSource, UITableViewDelegate {
    private struct Constants {
        static let navTitle = "Settings"
        static let nameLabelText = "Guest"
        static let cornerRadius: CGFloat = 10
        static let mealCell = "mealCell"
        static let staticAnchor: CGFloat = 20
        static let clipsToBounds: Bool = true
        static let translatesAutoresizingMaskIntoConstraints: Bool = false
        static let mealSettings = "Meal Settings"
        static let profileSettings = "Profile Settings"
        static let numberOfCells = 2
    }
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = Constants.translatesAutoresizingMaskIntoConstraints
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = true
        return tableView
    }()

    init(presenter: SettingsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var router: RouterProtocol?
    var presenter: SettingsPresenterProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        self.navigationItem.title = Constants.navTitle
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.mealCell)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant:  Constants.staticAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.mealCell, for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = Constants.profileSettings
        } else {
            cell.textLabel?.text = Constants.mealSettings
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.loadSetting(setting: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numberOfCells
    }
}

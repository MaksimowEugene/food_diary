import UIKit
import CoreData

private struct Constants {
    static let dishCell = "DishCell"
    static let dishSection = "DishSection"
}

class DishesViewController: UIViewController, DishesViewProtocol {

    var titleString: String = ""
    var presenter: DishesPresenterProtocol
    
    private lazy var dataSource: DishesDataSource = {
        let dataSource = DishesDataSource(tableView)
        return dataSource
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.isUserInteractionEnabled = true
        tableView.register(NameDetailCell.self, forCellReuseIdentifier: Constants.dishCell)
        return tableView
    }()

    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No dishes to display"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.isHidden = true
        return label
    }()

    init(presenter: DishesPresenterProtocol) {
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
        navigationItem.title = titleString
    }
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(noDataLabel)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noDataLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            noDataLabel.widthAnchor.constraint(equalTo: tableView.widthAnchor, constant: -32),
            noDataLabel.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getDishesCount()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.dishes.removeAll()
        presenter.fetchDishes()
        tableView.reloadData()
        print(presenter.dishes)
        setupDataSource()
    }
    
    private func setupDataSource() {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([Constants.dishSection])
        let nameDetails = presenter.dishes.enumerated().map { (index, dish) in
            let name = dish.name ?? ""
            let koeff = presenter.masses[index] / 100
            let detail = String(format: "Cal: %.2f | Pro: %.2fg | Fat: %.2fg | Carb: %.2fg",
                                dish.cals * koeff, dish.protein * koeff, dish.fats * koeff, dish.carbohydrates * koeff)
            return NameDetailCellModel(name: name, detail: detail)
        }
        nameDetails.forEach { nameDetail in
            snapshot.appendItems([nameDetail], toSection: Constants.dishSection)
        }
        dataSource.apply(snapshot)
        noDataLabel.isHidden = !presenter.dishes.isEmpty
        tableView.backgroundView = noDataLabel

    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @objc func addTapped() {
        presenter.showDishChooser()
    }
}

extension DishesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completionHandler) in
            presenter.deleteDish(row: indexPath.row)
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([snapshot.itemIdentifiers(inSection: Constants.dishSection)[indexPath.row]])
            self.dataSource.apply(snapshot, animatingDifferences: true)
            completionHandler(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showAmount(row: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

final class DishesDataSource: UITableViewDiffableDataSource<String, NameDetailCellModel> {
    
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.dishCell,
                                                           for: indexPath) as? NameDetailCell
            else { return nil }
            cell.configure(with: item)
            return cell
        }
    }
}

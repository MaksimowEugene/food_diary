import UIKit
import CoreData

private struct Constants {
    static let placeholder = "Search for a product"
    static let cellName = "DishCell"
}

class DishChooserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    var titleString: String = ""
    var mealType: Int = 0
    var presenter: DishChooserPresenterProtocol
    
    private let searchBar: UISearchBar = createSearchBar(placeholder: Constants.placeholder)

    private let tableView: UITableView = createTableView(cellIdentifier: Constants.cellName)

    init(presenter: DishChooserPresenterProtocol) {
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
        try? presenter.fetchedResultsController.performFetch()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }

    func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
    }
    
    func setupAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func setupViews() {
        addSubviews()
        setupTableView()
        setupAddButton()
        setupSearchBar()
        view.backgroundColor = .systemBackground
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getResultsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishCell", for: indexPath)
        let dish = presenter.fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = dish.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dish = presenter.fetchedResultsController.object(at: indexPath)
        presenter.showAmount(row: indexPath.row, dish: dish)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @objc func addTapped() {
        presenter.goToNewDishCreation()
    }
}

extension DishChooserViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchBarTextChanged(searchText: searchText)
        tableView.reloadData()
    }
}

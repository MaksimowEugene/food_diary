import UIKit
import CoreData

private struct Constants {
    static let mealCell: String = "MealCell"
    static let mealSection: String = "mealSection"
    static let cornerRadius: CGFloat = 10
    static let constraintConstant: CGFloat = 20
}

class CalendarView: UIView {
    
    var presenter: DayPresenterProtocol
    
    private lazy var dataSource: MealsDataSource = {
        let dataSource = MealsDataSource(tableView)
        return dataSource
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.isUserInteractionEnabled = true
        tableView.register(NameDetailCell.self, forCellReuseIdentifier: Constants.mealCell)
        return tableView
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        return picker
    }()
    
    private let tableHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Meals"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
 
    init(presenter: DayPresenterProtocol) {
        self.presenter = presenter        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setupView() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        addSubview(datePicker)
        addSubview(tableHeaderLabel)
        addSubview(tableView)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.constraintConstant),
            datePicker.centerXAnchor.constraint(equalTo: centerXAnchor),
            tableHeaderLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: Constants.constraintConstant),
            tableHeaderLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableHeaderLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: tableHeaderLabel.bottomAnchor, constant: Constants.constraintConstant),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func reloadTable() {
        tableView.reloadData()
    }
    
    func getDate() -> Date {
        return datePicker.date
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.mealsArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.tapOnCell(indexPath: indexPath.row)
    }
    func fetchData() {
        presenter.fetchData(for: datePicker.date)
    }
    
    internal func setupDataSource() {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([Constants.mealSection])
        let nameDetails: [NameDetailCellModel] = presenter.getNamesDetails()
        for nameDetail in nameDetails {
            snapshot.appendItems([nameDetail], toSection: Constants.mealSection)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        presenter.fetchData(for: sender.date)
        superview?.endEditing(true)
    }
    
    @objc private func settingsButtonTapped() {
        presenter.tapOnGear()
    }
}

extension CalendarView: UITableViewDelegate {}

final class MealsDataSource: UITableViewDiffableDataSource<String, NameDetailCellModel> {
    
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.mealCell,
                                                           for: indexPath) as? NameDetailCell
            else { return nil }
            cell.configure(with: item)
            return cell
        }
    }
}

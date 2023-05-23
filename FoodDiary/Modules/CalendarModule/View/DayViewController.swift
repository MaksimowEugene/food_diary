import UIKit
import CoreData

private struct Constants {
    static let mealCell: String = "MealCell"
    static let mealSection: String = "mealSection"
    static let cornerRadius: CGFloat = 10
    static let gearImage: UIImage = UIImage(systemName: "gear")!
    static let constraintConstant: CGFloat = 20
    static let gearButtonStyle = UIBarButtonItem.Style.plain
    static let segmentedItems = ["Calendar", "Stats"]
    static let dailyCalorieNeeds = "DailyCalorieNeeds"
}

class DayViewController: UIViewController, DayViewProtocol  {
    
    func reloadChart() {
        (stackView.arrangedSubviews[1] as? DayStatsView)?.reloadChart(withData: presenter.nutsData)
    }
    
    func dismissDatePicker() {
        dismiss(animated: true)
    }
    
    func reloadTable() {
        (stackView.arrangedSubviews[0] as? CalendarView)?.reloadTable()
    }
    
    func setupDataSource() {
        (stackView.arrangedSubviews[0] as? CalendarView)?.setupDataSource()
    }
    
    func getDate() -> Date {
        return Date()
    }
    
    private let stackView = UIStackView()
    
    var presenter: DayPresenterProtocol
    
    init(presenter: DayPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupViews()
        addCustomViewsToStackView()
    }
    
    private func checkDailyCalorieNeeds() {
        guard loadDataFromKeychain(forKey: Constants.dailyCalorieNeeds) != nil else {
            let alertController = UIAlertController(title: "Profile configuration", message: "Please go to settings and set your info to calculate your calorie needs.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupDataSource()
        reloadTable()
        reloadChart()
        clearStackView()
        addCustomViewsToStackView()
        segmentedControl.selectedSegmentIndex = 0
        checkDailyCalorieNeeds()
    }
    
    private func clearStackView() {
        stackView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    let segmentedControl = UISegmentedControl(items: Constants.segmentedItems)
    
    private func configureNavigationBar() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        navigationItem.titleView = segmentedControl
        let settingsButton = UIBarButtonItem(image: Constants.gearImage, style: Constants.gearButtonStyle, target: self, action: #selector(settingsButtonTapped))
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.constraintConstant),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.constraintConstant),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func addCustomViewsToStackView() {
        let calendarView = CalendarView(presenter: presenter)
        stackView.addArrangedSubview(calendarView)
        calendarView.setupView()
        calendarView.fetchData()
        calendarView.setupDataSource()
        let dayStatsView = DayStatsView()
        stackView.addArrangedSubview(dayStatsView)
        stackView.arrangedSubviews[0].isHidden = false
        stackView.arrangedSubviews[1].isHidden = true
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            stackView.arrangedSubviews[0].isHidden = false
            stackView.arrangedSubviews[1].isHidden = true
            reloadTable()
        case 1:
            stackView.arrangedSubviews[0].isHidden = true
            stackView.arrangedSubviews[1].isHidden = false
            reloadChart()
        default:
            stackView.arrangedSubviews[0].isHidden = true
            stackView.arrangedSubviews[1].isHidden = true
        }
    }
    
    @objc private func settingsButtonTapped() {
        presenter.tapOnGear()
    }
}

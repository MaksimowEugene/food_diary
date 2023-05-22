import UIKit

private struct Constants {
    static let mealCell: String = "MealCell"
    static let mealSection: String = "mealSection"
    static let calendarTitle: String = "Calendar"
    static let cornerRadius: CGFloat = 10
    static let gearImage: UIImage = UIImage(systemName: "gear")!
    static let constraintConstant: CGFloat = 20
    static let gearButtonStyle = UIBarButtonItem.Style.plain
}

class DayStatsView: UIView {
    
    private var chartView: PieChartView = {
        let chartView = PieChartView()
        chartView.barColors = [.systemRed, .systemOrange, .systemTeal]
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()

    private var linearChartView: LineChartView = {
        let linearChartView = LineChartView()
        linearChartView.translatesAutoresizingMaskIntoConstraints = false
        return linearChartView
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        addSubview(chartView)
        addSubview(linearChartView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            linearChartView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.constraintConstant),
            linearChartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            linearChartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            linearChartView.heightAnchor.constraint(equalToConstant: 100),
            chartView.topAnchor.constraint(equalTo: linearChartView.bottomAnchor, constant: Constants.constraintConstant),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            chartView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func reloadChart(withData data: [CGFloat]) {
        chartView.data = [data[0], data[1], data[2]]
        chartView.setup()
        chartView.setNeedsDisplay()
        let dailyCalorieNeeds = UserDefaults.standard.value(forKey: "DailyCalorieNeeds") as? Double
        linearChartView.consumedCalories = data[3]
        linearChartView.maxCalories = dailyCalorieNeeds ?? 2500
        linearChartView.setNeedsDisplay()
    }
}

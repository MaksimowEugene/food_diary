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
    
    private var chartView: ChartView = {
        let chartView = ChartView()
        chartView.barColors = [.systemRed, .systemOrange, .systemTeal]
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
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
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.constraintConstant),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            chartView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func reloadChart(withData data: [CGFloat]) {
        chartView.data = data
        chartView.setup()
        chartView.setNeedsDisplay()
    }
}

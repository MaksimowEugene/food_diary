import UIKit

class LineChartView: UIView {
    
    var maxCalories: CGFloat = 0
    var consumedCalories: CGFloat = 0
    let chartHeight: CGFloat = 200
    let legendHeight: CGFloat = 30

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        UIColor.systemBackground.setFill()
        context.fill(rect)

        let maxValue = max(maxCalories, consumedCalories)
        let minValue: CGFloat = 0

        let chartWidth = rect.width - 20
        let chartHeight = rect.height - legendHeight

        let xScale = chartWidth / (maxValue - minValue)

        let consumedRectWidth = consumedCalories * xScale
        let consumedRectHeight = chartHeight * 0.8
        let consumedRectY = rect.height - chartHeight - legendHeight + (chartHeight - consumedRectHeight)
        let consumedRect = CGRect(x: 10, y: consumedRectY, width: consumedRectWidth, height: consumedRectHeight)

        let fillColor: UIColor = .orange
        let consumedRectPath = UIBezierPath(roundedRect: consumedRect, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 8, height: 8))
        fillColor.setFill()
        consumedRectPath.fill()

        let consumedLabelWidth = min(rect.width - 20, 150)
        let consumedLabel = UILabel(frame: CGRect(x: rect.midX - consumedLabelWidth/2, y: rect.midY - 22, width: consumedLabelWidth, height: 40))
        consumedLabel.font = UIFont.systemFont(ofSize: 22)
        consumedLabel.textColor = .white
        consumedLabel.textAlignment = .center
        consumedLabel.numberOfLines = 2
        consumedLabel.adjustsFontSizeToFitWidth = true
        consumedLabel.minimumScaleFactor = 0.5
        consumedLabel.text = "Calories\n\(consumedCalories > maxCalories ? "Calorie Overload" : "")"
        addSubview(consumedLabel)

        let remainingRectWidth = (maxCalories - consumedCalories) * xScale
        let remainingRectHeight = chartHeight * 0.8
        let remainingRectY = rect.height - chartHeight - legendHeight + (chartHeight - remainingRectHeight)
        let remainingRect = CGRect(x: consumedRect.maxX, y: remainingRectY, width: max(0, remainingRectWidth), height: remainingRectHeight)

        let remainingFillColor: UIColor = .lightGray
        var remainingRectPath: UIBezierPath
        if consumedCalories == 0 {
            remainingRectPath = UIBezierPath(roundedRect: remainingRect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8))
        } else {
            remainingRectPath = UIBezierPath(roundedRect: remainingRect, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 8, height: 8))
        }
        remainingFillColor.setFill()
        remainingRectPath.fill()

        let legendView = UIView(frame: CGRect(x: 0, y: rect.height - legendHeight + 5, width: rect.width, height: legendHeight))
        legendView.backgroundColor = .clear

        let consumedLegendItemView = UIView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        consumedLegendItemView.backgroundColor = .orange
        consumedLegendItemView.layer.cornerRadius = 4
        legendView.addSubview(consumedLegendItemView)

        let consumedLegendLabel = UILabel(frame: CGRect(x: 35, y: 0, width: 150, height: 20))
        consumedLegendLabel.font = UIFont.systemFont(ofSize: 12)
        consumedLegendLabel.textColor = .label
        consumedLegendLabel.text = "Consumed Calories"
        legendView.addSubview(consumedLegendLabel)

        let maxLegendItemView = UIView(frame: CGRect(x: consumedLegendLabel.frame.maxX + 20, y: 0, width: 20, height: 20))
        maxLegendItemView.backgroundColor = .lightGray
        maxLegendItemView.layer.cornerRadius = 4
        legendView.addSubview(maxLegendItemView)

        let maxLegendLabel = UILabel(frame: CGRect(x: maxLegendItemView.frame.maxX + 5, y: 0, width: 150, height: 20))
        maxLegendLabel.font = UIFont.systemFont(ofSize: 12)
        maxLegendLabel.textColor = .label
        maxLegendLabel.text = "Maximum Calories"
        legendView.addSubview(maxLegendLabel)

        addSubview(legendView)
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: chartHeight + legendHeight + 10)
    }

    func setupChart(withMaxCalories maxCalories: CGFloat, consumedCalories: CGFloat) {
        self.maxCalories = maxCalories
        self.consumedCalories = consumedCalories
        invalidateIntrinsicContentSize()
        setNeedsDisplay()
    }
}

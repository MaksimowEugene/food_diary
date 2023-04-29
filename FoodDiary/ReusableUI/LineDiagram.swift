import UIKit

class LineChartView: UIView {
    
    var maxCalories: [CGFloat] = [] // Array of maximum calories
    var consumedCalories: [CGFloat] = [] // Array of consumed calories
    
    override func draw(_ rect: CGRect) {
        // Calculate the maximum and minimum values for the chart
        let maxValue = max(maxCalories.max() ?? 0, consumedCalories.max() ?? 0)
        let minValue = max(maxCalories.min() ?? 0, consumedCalories.min() ?? 0)
        
        // Calculate the height and width of the chart
        let chartWidth = rect.width - 20
        let chartHeight = rect.height - 20
        
        // Calculate the x and y scale factors
        let xScale = chartWidth / CGFloat(maxCalories.count - 1)
        let yScale = chartHeight / (maxValue - minValue)
        
        // Create a UIBezierPath for the maximum calories line
        let maxCaloriesPath = UIBezierPath()
        maxCaloriesPath.move(to: CGPoint(x: 10, y: chartHeight - (maxCalories[0] - minValue) * yScale + 10))
        for i in 1..<maxCalories.count {
            let point = CGPoint(x: CGFloat(i) * xScale + 10, y: chartHeight - (maxCalories[i] - minValue) * yScale + 10)
            maxCaloriesPath.addLine(to: point)
        }
        
        // Create a CAShapeLayer for the maximum calories line
        let maxCaloriesLayer = CAShapeLayer()
        maxCaloriesLayer.path = maxCaloriesPath.cgPath
        maxCaloriesLayer.strokeColor = UIColor.red.cgColor
        maxCaloriesLayer.fillColor = UIColor.clear.cgColor
        maxCaloriesLayer.lineWidth = 2
        
        // Create a UIBezierPath for the consumed calories line
        let consumedCaloriesPath = UIBezierPath()
        consumedCaloriesPath.move(to: CGPoint(x: 10, y: chartHeight - (consumedCalories[0] - minValue) * yScale + 10))
        for i in 1..<consumedCalories.count {
            let point = CGPoint(x: CGFloat(i) * xScale + 10, y: chartHeight - (consumedCalories[i] - minValue) * yScale + 10)
            consumedCaloriesPath.addLine(to: point)
        }
        
        // Create a CAShapeLayer for the consumed calories line
        let consumedCaloriesLayer = CAShapeLayer()
        consumedCaloriesLayer.path = consumedCaloriesPath.cgPath
        consumedCaloriesLayer.strokeColor = UIColor.green.cgColor
        consumedCaloriesLayer.fillColor = UIColor.clear.cgColor
        consumedCaloriesLayer.lineWidth = 2
        
        // Add the layers to the view's layer
        self.layer.addSublayer(maxCaloriesLayer)
        self.layer.addSublayer(consumedCaloriesLayer)
    }
}

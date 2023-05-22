import UIKit

final class PieChartView: UIView {
    public var barColors: [UIColor] = [.systemRed, .systemOrange, .systemIndigo]
    public var data: [CGFloat] = [20, 30, 60]
    public var legend: [String] = ["Proteins", "Fats", "Carbohydrates"]
    
    convenience init(frame: CGRect, data: [CGFloat], barColors: [UIColor], legend: [String]) {
        self.init(frame: frame)
        self.data = data
        self.barColors = barColors
        self.legend = legend
        setup()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let maxData = data.reduce(0, { $0 + $1 })
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = min(bounds.width, bounds.height) / 2 - 20
        var startAngle = -CGFloat.pi / 2
        var endAngle = startAngle
        
        for subview in subviews {
            if let label = subview as? UILabel {
                label.removeFromSuperview()
            }
        }
        
        if maxData == 0 {
            context.setFillColor(UIColor.systemGray.cgColor)
            context.fillEllipse(in: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2))
            
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = .white
            label.text = "Nothing to display"
            label.sizeToFit()
            label.center = center
            addSubview(label)
            return
        }

        for (i, value) in data.enumerated() {
            if value > 0 {
                let fraction = value / maxData
                endAngle = startAngle + CGFloat.pi * 2 * fraction
                
                let path = UIBezierPath()
                path.move(to: center)
                path.addArc(withCenter: center,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: true)
                path.close()
                
                let colorIndex = i % barColors.count
                let color = barColors[colorIndex]
                context.setFillColor(color.cgColor)
                context.addPath(path.cgPath)
                context.fillPath()
                
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                label.text = String(format: "%.2f", value)
                label.textColor = .white
                label.sizeToFit()
                let labelAngle = startAngle + (endAngle - startAngle) / 2
                let labelRadius = radius * 0.7
                let labelX = center.x + labelRadius * cos(labelAngle)
                let labelY = center.y + labelRadius * sin(labelAngle)
                label.center = CGPoint(x: labelX, y: labelY)
                addSubview(label)
            }
            startAngle = endAngle
        }
    }

    func setup() {
        backgroundColor = .systemBackground
        draw(frame)
        let legendView = UIView()
        legendView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(legendView)
        
        var previousView: UIView?
        var heightConstraint: NSLayoutConstraint?
        
        for (i, color) in barColors.enumerated() {
            let legendItem = UIView()
            legendItem.backgroundColor = color
            legendItem.layer.cornerRadius = 4
            legendItem.translatesAutoresizingMaskIntoConstraints = false
            legendView.addSubview(legendItem)
            
            let nameLabel = UILabel()
            nameLabel.font = UIFont.systemFont(ofSize: 12)
            nameLabel.text = legend[i]
            nameLabel.sizeToFit()
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            legendView.addSubview(nameLabel)
            
            legendItem.widthAnchor.constraint(equalToConstant: 20).isActive = true
            legendItem.heightAnchor.constraint(equalToConstant: 20).isActive = true
            legendItem.leadingAnchor.constraint(equalTo: previousView?.trailingAnchor ?? legendView.leadingAnchor, constant: previousView != nil ? 25 : 10).isActive = true
            legendItem.centerYAnchor.constraint(equalTo: legendView.centerYAnchor).isActive = true
    
            nameLabel.leadingAnchor.constraint(equalTo: legendItem.trailingAnchor, constant: 5).isActive = true
            nameLabel.centerYAnchor.constraint(equalTo: legendItem.centerYAnchor).isActive = true
            
            previousView = nameLabel
    
            if let heightConstraint = heightConstraint {
                heightConstraint.constant = max(heightConstraint.constant, nameLabel.frame.height)
            } else {
                heightConstraint = legendView.heightAnchor.constraint(equalToConstant: nameLabel.frame.height + 10)
                heightConstraint?.isActive = true
            }
        }
        previousView?.trailingAnchor.constraint(equalTo: legendView.trailingAnchor, constant: -10).isActive = true
        legendView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        legendView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10).isActive = true
    }
}

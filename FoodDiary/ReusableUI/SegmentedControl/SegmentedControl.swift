import UIKit

func createSegmentedControl(items: [Any], selectedSegmentIndex: Int, isEnabled: Bool) -> UISegmentedControl {
    let segmentedControl = UISegmentedControl(items: items)
    segmentedControl.selectedSegmentIndex = selectedSegmentIndex
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    segmentedControl.isEnabled = isEnabled
    return segmentedControl
}

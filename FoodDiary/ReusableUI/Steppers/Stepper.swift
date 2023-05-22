import UIKit

func createStepper(minimumValue: Double, maximumValue: Double,
                   stepValue: Double, initialValue: Double) -> UIStepper {
    let stepper = UIStepper()
    stepper.translatesAutoresizingMaskIntoConstraints = false
    stepper.minimumValue = minimumValue
    stepper.maximumValue = maximumValue
    stepper.stepValue = stepValue
    stepper.value = initialValue
    return stepper
}

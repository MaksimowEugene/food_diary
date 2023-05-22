import UIKit

protocol DishAmountViewProtocol: AnyObject {}

protocol DishAmountPresenterProtocol: AnyObject {
    init(router: RouterProtocol, name: String, dishMeal: DishAmountModel)
    var grams: Double { get set }
    var name: String { get }
    var dishMeal: DishAmountModel { get set }
    func saveButtonTapped()
    func getGramsLabelText() -> String
    func stepperValueChanged(stepperValue: Double)
}

private struct Constants {
    static let grammText = " g"
}

class DishAmountPresenter: DishAmountPresenterProtocol {
    required init(router: RouterProtocol, name: String, dishMeal: DishAmountModel) {
        self.router = router
        self.name = name
        self.dishMeal = dishMeal
        grams = dishMeal.mass != 0 ? Double(dishMeal.mass) : 1
    }
    
    var grams: Double
    weak var view: DishAmountViewProtocol?
    var router: RouterProtocol
    var name: String
    var dishMeal: DishAmountModel
    
    func saveButtonTapped() {
        if dishMeal.mass != 0 {
            CoreDataStack.shared.updateDish(dishId: dishMeal.dishId, mealId: dishMeal.mealId, mass: Int64(grams))
        } else {
            CoreDataStack.shared.createDish(mealId: dishMeal.mealId, dishId: dishMeal.dishId, grams: Int64(grams))
        }
    }
    
    func getGramsLabelText() -> String {
        "\(grams)" + Constants.grammText
    }
    
    func stepperValueChanged(stepperValue: Double) {
        grams = stepperValue
    }
}

import UIKit

protocol DishAmountViewProtocol: AnyObject {}

protocol DishAmountPresenterProtocol: AnyObject {
    init(router: RouterProtocol, name: String, dishMeal: DishAmountModel)
    var grams: Double { get set }
    var name: String { get }
    var dishMeal: DishAmountModel { get set }
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
}

import UIKit
import CoreData

protocol NewDishViewProtocol: AnyObject {}

protocol NewDishPresenterProtocol: AnyObject {
    func addDish(newDishModel: NewDishModel)
    init( router: RouterProtocol)
}

class NewDishPresenter: NewDishPresenterProtocol {
    
    let router: RouterProtocol
   
    required init(router: RouterProtocol) {
        self.router = router
    }
    
    func addDish(newDishModel: NewDishModel) {
        let context = CoreDataStack.shared.context
        let dish = Dishes(context: context)
        dish.id = UUID()
        dish.name = newDishModel.dishName
        dish.cals = newDishModel.cals
        dish.protein = newDishModel.proteins
        dish.fats = newDishModel.fats
        dish.carbohydrates = newDishModel.carbs
        CoreDataStack.shared.saveContext()
    }
}

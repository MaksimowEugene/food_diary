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
    
    // Создаёт новое блюдо
    func addDish(newDishModel: NewDishModel) {
        CoreDataStack.shared.createNewDish(newDishModel: newDishModel)
    }
}

import UIKit
import CoreData

protocol DishChooserViewProtocol: AnyObject {}

protocol DishChooserPresenterProtocol: AnyObject {
    var meal: Meals { get }
    var fetchedResultsController: NSFetchedResultsController<Dishes> { get set }
    var dishes: [Dishes] { get set }
    var masses: [Double] { get set }
    func fetchDishes()
    func getDishesCount() -> Int
    func getDishFromDishes(index: Int) -> Dishes
    func showAmount(row: Int, dish: Dishes)
    func goToNewDishCreation()
    init( router: RouterProtocol, meal: Meals)
    func filterResults(for searchText: String)
}

class DishChooserPresenter: DishChooserPresenterProtocol {

    let router: RouterProtocol
    let meal: Meals
    var dishes: [Dishes] = []
    var masses: [Double] = []
    
    required init(router: RouterProtocol, meal: Meals) {
        self.router = router
        self.meal = meal
    }
    
    func fetchDishes() {
        (masses, dishes) = CoreDataStack.shared.fetchDishesByMeal(meal: meal, toFetch: 20)
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Dishes> = {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<Dishes> = Dishes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    func filterResults(for searchText: String) {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<Dishes> = Dishes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        if !searchText.isEmpty {
            let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
            request.predicate = predicate
        }
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController = frc
        try? fetchedResultsController.performFetch()
    }

    func showAmount(row: Int, dish: Dishes) {
        guard let mealId = meal.id, let dishId = dish.id else { return }
        let dishesMeals = DishAmountModel(mass: 0, mealId: mealId, dishId: dishId)
        router.showDishAmount(pageTitle: dish.name ?? "", dishesMeals: dishesMeals)
    }
    
    func goToNewDishCreation() {
        router.showNewDish()
    }
    
    func getDishFromDishes(index: Int) -> Dishes {
        return dishes[index]
    }
    
    func getDishesCount() -> Int {
        dishes.count
    }
}

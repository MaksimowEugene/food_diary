import UIKit

protocol DishesViewProtocol: AnyObject {}

protocol DishesPresenterProtocol: AnyObject {
    var meal: Meals { get }
    var dishes: [Dishes] { get set }
    var masses: [Double] { get set }
    func fetchDishes()
    func getDishesCount() -> Int
    func getDishFromDishes(index: Int) -> Dishes
    func showAmount(row: Int)
    func deleteDish(row: Int)
    func showDishChooser()
    init( router: RouterProtocol, meal: Meals)
}

class DishesPresenter: DishesPresenterProtocol {
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
    
    func deleteDish(row: Int) {
        guard let mealId = meal.id, let dishId = getDishFromDishes(index: row).id else { return }
        CoreDataStack.shared.deleteDishMeal(mealId: mealId, dishId: dishId)
        dishes.remove(at: row)
    }
    
    func showAmount(row: Int) {
        let dish = dishes[row]
        let mass = masses[row]
        guard let mealId = meal.id, let dishId = dish.id else { return }
        let dishesMeals = DishAmountModel(mass: mass, mealId: mealId, dishId: dishId)
        router.showDishAmount(pageTitle: dish.name ?? "", dishesMeals: dishesMeals)
    }
    
    func showDishChooser() {
        router.showDishChooser(meal: meal)
    }
    
    func getDishFromDishes(index: Int) -> Dishes {
        return dishes[index]
    }
    
    func getDishesCount() -> Int {
        dishes.count
    }
}

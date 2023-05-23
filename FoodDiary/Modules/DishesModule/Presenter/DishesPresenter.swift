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
    func setupSnapshot(snapshot: NSDiffableDataSourceSnapshot<String, NameDetailCellModel>) -> NSDiffableDataSourceSnapshot<String, NameDetailCellModel>
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
    
    // Загружает блюда
    func fetchDishes() {
        (masses, dishes) = CoreDataStack.shared.fetchDishesByMeal(meal: meal, toFetch: 20)
    }
    
    // Удаляет блюдо
    func deleteDish(row: Int) {
        guard let mealId = meal.id, let dishId = getDishFromDishes(index: row).id else { return }
        CoreDataStack.shared.deleteDishMeal(mealId: mealId, dishId: dishId)
        dishes.remove(at: row)
    }
    
    // Отображает вью выбора массы блюда
    func showAmount(row: Int) {
        let dish = dishes[row]
        let mass = masses[row]
        guard let mealId = meal.id, let dishId = dish.id else { return }
        let dishesMeals = DishAmountModel(mass: mass, mealId: mealId, dishId: dishId)
        router.showDishAmount(pageTitle: dish.name ?? "", dishesMeals: dishesMeals)
    }
    
    // Отображает вью выбора блюда
    func showDishChooser() {
        router.showDishChooser(meal: meal)
    }
    
    // Получает блюдо из массива
    func getDishFromDishes(index: Int) -> Dishes {
        dishes[index]
    }
    
    // Считает количество блюд в массиве
    func getDishesCount() -> Int {
        dishes.count
    }
    
    // Настраивает снапшот таблицы для отображения списка всех блюд приёма пищи
    func setupSnapshot(snapshot: NSDiffableDataSourceSnapshot<String, NameDetailCellModel>) -> NSDiffableDataSourceSnapshot<String, NameDetailCellModel> {
        let nameDetails = dishes.enumerated().map { (index, dish) in
            let name = dish.name ?? ""
            let koeff = masses[index] / 100
            let detail = String(format: "Cal: %.2f | Pro: %.2fg | Fat: %.2fg | Carb: %.2fg",
                                dish.cals * koeff, dish.protein * koeff, dish.fats * koeff, dish.carbohydrates * koeff)
            return NameDetailCellModel(name: name, detail: detail)
        }
        
        var snapshotOut = snapshot
        
        nameDetails.forEach { nameDetail in
            snapshotOut.appendItems([nameDetail], toSection: "DishSection")
        }
        return snapshotOut
    }
}

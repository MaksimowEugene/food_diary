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
    func getResultsCount() -> Int
    func searchBarTextChanged(searchText: String)
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
    
    lazy var fetchedResultsController = createFetchedResultsController(fetchRequest: CoreDataStack.shared.getSearchFetchRequest(),
        sortDescriptors: [CoreDataStack.shared.getSearchSortDescriptor()])

    // Отображает вью выбора массы блюда
    func showAmount(row: Int, dish: Dishes) {
        guard let mealId = meal.id, let dishId = dish.id else { return }
        let dishesMeals = DishAmountModel(mass: 0, mealId: mealId, dishId: dishId)
        router.showDishAmount(pageTitle: dish.name ?? "", dishesMeals: dishesMeals)
    }
    
    // Отображает вью создания нового блюда
    func goToNewDishCreation() {
        router.showNewDish()
    }
    
    // По данному индексу возвращает блюдо из списка
    func getDishFromDishes(index: Int) -> Dishes {
        dishes[index]
    }
    
    // Возвращает количество блюд в массиве
    func getDishesCount() -> Int {
        dishes.count
    }
    
    // Возвращает количество результатов фильтрации
    func getResultsCount() -> Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    // Обрабатывает изменение текста в поле поиска
    func searchBarTextChanged(searchText: String) {
        CoreDataStack.shared.filterResults(for: searchText, fetchedResultController: fetchedResultsController)
    }
    
    // Загружает блюда
    func fetchDishes() {
        (masses, dishes) = CoreDataStack.shared.fetchDishesByMeal(meal: meal, toFetch: 20)
    }
}

import UIKit
import CoreData

protocol DayViewProtocol: DayStatsViewProtocol, CalendarViewProtocol {}

protocol CalendarViewProtocol: AnyObject {
    func reloadTable()
    func setupDataSource()
    func dismissDatePicker()
    func getDate() -> Date
}

protocol DayStatsViewProtocol: AnyObject {
    func reloadChart()
}

protocol DayPresenterProtocol: AnyObject {
    var meals: [Meals] { get set }
    var nutsData: [CGFloat] { get set }
    var context: NSManagedObjectContext? { get set }
    var mealsArray: [String] { get set }
    init(router: RouterProtocol)
    func tapOnGear()
    func tapOnCell(indexPath: Int)
    func fetchData(for date: Date)
    func fetchQueue()
    func getNamesDetails() -> [NameDetailCellModel]
    // func checkIfUserInfoEntered()
}

class DayPresenter: DayPresenterProtocol {
    weak var view: DayViewProtocol?
    
    var meals: [Meals]
    var nutsData: [CGFloat] = [0, 0, 0, 0]
    var context: NSManagedObjectContext?
    var mealsArray: [String]
    func tapOnGear() {
        router.showSettings()
    }

    func tapOnCell(indexPath: Int) {
        let meal = meals[indexPath]
        router.showDishes(meal: meal)
    }
    
    var router: RouterProtocol
    
    required init(router: RouterProtocol) {
        self.router = router
        self.meals = []
        self.context = CoreDataStack.shared.context
        mealsArray = CoreDataStack.shared.fetchValidQueues().map { $0.mealName ?? "" }
    }
    
    internal func fetchQueue() {
        mealsArray = CoreDataStack.shared.fetchValidQueues().map { $0.mealName ?? "" }
    }
    
    internal func fetchData(for date: Date) {
        fetchQueue()
        meals = CoreDataStack.shared.fetchMealsByDateAndCreateIfNeeded(date: date)
        view?.setupDataSource()
        view?.reloadTable()
        view?.dismissDatePicker()
    }
    
    func getNamesDetails() -> [NameDetailCellModel] {
        var nameDetails: [NameDetailCellModel] = []
        nutsData = [0, 0, 0, 0]
        for (index, mealName) in mealsArray.enumerated() {
            guard let queue = CoreDataStack.shared.fetchQueue(by: mealName) else { return [] }
            let (masses, dishes) = CoreDataStack.shared.fetchDishesByMeal(meal: meals[index], toFetch: 20)
            var totalCals = 0.0
            var totalProteins = 0.0
            var totalFats = 0.0
            var totalCarbs = 0.0
            guard let name = queue.mealName else { return [] }
            var detail: String = "No dishes"
            if !dishes.isEmpty {
                for (index, dish) in dishes.enumerated() {
                    let koeff = masses[index] / 100
                    totalCals += dish.cals * koeff
                    totalProteins += dish.protein * koeff
                    totalFats += dish.fats * koeff
                    totalCarbs += dish.carbohydrates * koeff
                }
                detail = String(format: "Cal: %.2f | Pro: %.2fg | Fat: %.2fg | Carb: %.2fg",
                                totalCals, totalProteins, totalFats, totalCarbs)
                nutsData[3] += totalCals
                nutsData[0] += totalProteins
                nutsData[1] += totalFats
                nutsData[2] += totalCarbs
            }
            nameDetails.append(NameDetailCellModel(name: name, detail: detail))
        }
        return nameDetails
    }
    
    func loadProfileSettingView() {
        router.showProfileSettings()
    }
    
//    internal func checkIfUserInfoEntered() {
//        let dailyCalorieNeeds = UserDefaults.standard.double(forKey: "DailyCalorieNeeds")
//        loadProfileSettingView()
//    }
}

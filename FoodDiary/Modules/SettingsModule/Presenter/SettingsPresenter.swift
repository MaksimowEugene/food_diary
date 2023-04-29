import UIKit

protocol SettingsViewProtocol: AnyObject {}

protocol ProfileSettingsViewProtocol: SettingsViewProtocol {}

protocol MealSettingsViewProtocol: SettingsViewProtocol {}

protocol SettingsPresenterProtocol: AnyObject {
    func fetchMealsArray()
    init(router: RouterProtocol)
    var mealsArray: [String] { get set}
    func mealsArrayCount() -> Int
    func loadSetting(setting: Int)
    func checkIfQueueExists(text: String) -> Bool
    func handleCellClick(row: Int, text: String)
    func createNewQueue(text: String)
    func handleMealMove(sourceIndexPathRow: Int, destinationIndexPathRow: Int)
    func deleteQueue(row: Int)
}

private struct Constants {}

class SettingsPresenter: SettingsPresenterProtocol {
    
    weak var view: SettingsViewProtocol?
    var router: RouterProtocol
    var mealsArray: [String]
    
    required init(router: RouterProtocol) {
        self.router = router
        mealsArray = CoreDataStack.shared.fetchValidQueues().map { $0.mealName ?? "" }
    }
    
    func loadSetting(setting: Int) {
        switch setting {
        case 0:
            loadProfileSettingView()
        case 1:
            loadMealSettingView()
        default:
            break
        }
    }
    
    func checkIfQueueExists(text: String) -> Bool {
        !CoreDataStack.shared.fetchAllQueues().contains(where: {$0.mealName == text } )
    }
    
    func loadProfileSettingView() {
        router.showProfileSettings()
    }
    
    func loadMealSettingView() {
        router.showMealSettings()
    }
    
    func fetchMealsArray() {
        mealsArray = CoreDataStack.shared.fetchValidQueues().map { $0.mealName ?? "" }
    }
    
    func createNewQueue(text: String) {
        CoreDataStack.shared.createQueue(text: text)
    }
    
    func mealsArrayCount() -> Int {
        mealsArray.count
    }
    
    func handleCellClick(row: Int, text: String) {
        mealsArray[row] = text
        CoreDataStack.shared.updateQueueName(queue: Int16(row), newName: text)
    }
    
    func deleteQueue(row: Int) {
        CoreDataStack.shared.updateQueuesFromNames(names: mealsArray)
        CoreDataStack.shared.deleteQueue(queue: row)
        fetchMealsArray()
    }
    
    func handleMealMove(sourceIndexPathRow: Int, destinationIndexPathRow: Int) {
        let movedObject = mealsArray[sourceIndexPathRow]
        mealsArray.remove(at: sourceIndexPathRow)
        mealsArray.insert(movedObject, at: destinationIndexPathRow)
        CoreDataStack.shared.updateQueuesFromNames(names: mealsArray)
    }
}

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
    
    // Отвечает за выбор загружаемого окна настроек
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
    
    // Проверяет существует ли приём пищи с таким названием
    func checkIfQueueExists(text: String) -> Bool {
        !CoreDataStack.shared.fetchValidQueues().contains(where: {$0.mealName == text } )
    }
    
    // Загружает вью настроек профиля пользователя
    func loadProfileSettingView() {
        router.showProfileSettings()
    }
    
    // Загружает вью настроек приёмов пищи
    func loadMealSettingView() {
        router.showMealSettings()
    }
    
    // Загружает список приёмов пищи
    func fetchMealsArray() {
        mealsArray = CoreDataStack.shared.fetchValidQueues().map { $0.mealName ?? "" }
    }
    
    // Создаёт новый приём пищи в очереди
    func createNewQueue(text: String) {
        CoreDataStack.shared.createQueue(text: text)
    }
    
    // Определяет сколько приёмов пищи в массиве
    func mealsArrayCount() -> Int {
        mealsArray.count
    }
    
    // Обрабатывает нажатие на приём пищи в очереди
    func handleCellClick(row: Int, text: String) {
        mealsArray[row] = text
        CoreDataStack.shared.updateQueueName(queue: Int16(row), newName: text)
    }
    
    // Удаляет приём пищи
    func deleteQueue(row: Int) {
        CoreDataStack.shared.updateQueuesFromNames(names: mealsArray)
        CoreDataStack.shared.deleteQueue(queue: row)
        fetchMealsArray()
    }
    
    // Обрабатывает перемещение приёма пищи по очереди
    func handleMealMove(sourceIndexPathRow: Int, destinationIndexPathRow: Int) {
        let movedObject = mealsArray[sourceIndexPathRow]
        mealsArray.remove(at: sourceIndexPathRow)
        mealsArray.insert(movedObject, at: destinationIndexPathRow)
        CoreDataStack.shared.updateQueuesFromNames(names: mealsArray)
    }
}

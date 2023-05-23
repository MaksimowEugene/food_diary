import UIKit

protocol AssemblyProtocol {
    func createDay(router: RouterProtocol) -> UIViewController
    func createSettings(router: RouterProtocol) -> UIViewController
    func createDishes(meal: Meals, router: RouterProtocol) -> UIViewController
    func createDishAmount(router: RouterProtocol, name: String, dishMeal: DishAmountModel) -> UIViewController
    func createDishChooser(meal: Meals, router: RouterProtocol) -> UIViewController
    func createProfileSettings(router: RouterProtocol) -> UIViewController 
    func createMealSettings(router: RouterProtocol) -> UIViewController
    func createNewDish(router: RouterProtocol) -> UIViewController
}

class Assembly: AssemblyProtocol {
    
    var settingsPresenter: SettingsPresenter!
    
    // Собирает вью выбора даты
    func createDay(router: RouterProtocol) -> UIViewController {
        let presenter = DayPresenter(router: router)
        let view = DayViewController(presenter: presenter)
        presenter.view = view
        return view
    }
    
    // Собирает вью настроек
    func createSettings(router: RouterProtocol) -> UIViewController {
        settingsPresenter = SettingsPresenter(router: router)
        let view = SettingsViewController(presenter: settingsPresenter)
        settingsPresenter.view = view
        return view
    }
    
    // Собирает вью списка блюд приёма пищи
    func createDishes(meal: Meals, router: RouterProtocol) -> UIViewController {
        let presenter = DishesPresenter(router: router, meal: meal)
        let view = DishesViewController(presenter: presenter)
        return view
    }
    
    // Собирает вью выбора массы блюда
    func createDishAmount(router: RouterProtocol, name: String, dishMeal: DishAmountModel) -> UIViewController {
        let presenter = DishAmountPresenter(router: router, name: name, dishMeal: dishMeal)
        let view = DishAmountViewController(presenter: presenter)
        return view
    }
    
    // Собирает вью поиска приёма пищи
    func createDishChooser(meal: Meals, router: RouterProtocol) -> UIViewController {
        let presenter = DishChooserPresenter(router: router, meal: meal)
        let view = DishChooserViewController(presenter: presenter)
        return view
    }
    
    // Собирает вью настройки профиля
    func createProfileSettings(router: RouterProtocol) -> UIViewController {
        let view = ProfileSettingsViewController(presenter: settingsPresenter)
        settingsPresenter.view = view
        return view
    }
    
    // Собирает вью настроек приёмов пищи
    func createMealSettings(router: RouterProtocol) -> UIViewController {
        let view = MealSettingsViewController(presenter: settingsPresenter)
        settingsPresenter.view = view
        return view
    }
    
    // Собирает вью создания блюда
    func createNewDish(router: RouterProtocol) -> UIViewController {
        let presenter = NewDishPresenter(router: router)
        let view = NewDishViewController(presenter: presenter)
        return view
    }
}

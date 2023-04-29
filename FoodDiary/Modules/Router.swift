import UIKit

protocol RouterProtocol {
    var navigationController: UINavigationController? { get set }
    var assembly: AssemblyProtocol? { get set }
    
    func initialViewController()
    func showSettings()
    func showDishes(meal: Meals)
    func showDishChooser(meal: Meals)
    func showDishAmount(pageTitle: String, dishesMeals: DishAmountModel)
    func showProfileSettings()
    func showMealSettings()
    func showNewDish()
    func popToRoot()
}

class Router: RouterProtocol {
    
    var assembly: AssemblyProtocol?
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController, assembly: AssemblyProtocol) {
        self.navigationController = navigationController
        self.assembly = assembly
    }
    
    func showDishAmount(pageTitle: String, dishesMeals: DishAmountModel) {
        if let navigationController = navigationController {
            guard let dishesViewController = assembly?.createDishAmount(router: self, name: pageTitle, dishMeal: dishesMeals) else { return }
            navigationController.present(dishesViewController, animated: true)
        }
    }
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let dayVC = assembly?.createDay(router: self) else { return }
            navigationController.viewControllers = [dayVC]
        }
    }
    
    func showDishes(meal: Meals) {
        if let navigationController = navigationController {
            guard let dishesViewController = assembly?.createDishes(meal: meal, router: self) else { return }
            navigationController.pushViewController(dishesViewController, animated: true)
        }
    }
    
    func showDishChooser(meal: Meals) {
        if let navigationController = navigationController {
            guard let dishChooserViewController = assembly?.createDishChooser(meal: meal, router: self) else { return }
            navigationController.pushViewController(dishChooserViewController, animated: true)
        }
    }
    
    func showSettings() {
        if let navigationController = navigationController {
            guard let settingsViewController = assembly?.createSettings(router: self) else { return }
            navigationController.pushViewController(settingsViewController, animated: true)
        }
    }
    
    func showProfileSettings() {
        if let navigationController = navigationController {
            guard let profileSettingsViewController = assembly?.createProfileSettings(router: self) else { return }
            navigationController.pushViewController(profileSettingsViewController, animated: true)
        }
    }
    
    func showMealSettings() {
        if let navigationController = navigationController {
            guard let mealSettingsViewController = assembly?.createMealSettings(router: self) else { return }
            navigationController.pushViewController(mealSettingsViewController, animated: true)
        }
    }
    
    func showNewDish() {
        if let navigationController = navigationController {
            guard let newDishViewController = assembly?.createNewDish(router: self) else { return }
            navigationController.pushViewController(newDishViewController, animated: true)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let stack = CoreDataStack.shared
        let firstLaunch = UserDefaults.standard.bool(forKey: "firstLaunch")
        if !firstLaunch {
            stack.preloadData()
            UserDefaults.standard.set(true, forKey: "firstLaunch")
        }
        let navigationController = UINavigationController()
        let assemblyBuilder = Assembly()
        let router = Router(navigationController: navigationController, assembly: assemblyBuilder)
        router.initialViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

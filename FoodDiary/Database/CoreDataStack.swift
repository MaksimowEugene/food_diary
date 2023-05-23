import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FoodDiary")
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        return CoreDataStack.persistentContainer.newBackgroundContext()
    }()
    
    private init() {
        CoreDataStack.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? { fatalError("Unresolved error \(error), \(error.userInfo)") }
        })
    }
    
    //
    func createMeal(mealDate: Date, queue: Queue){
        guard let newMeal = NSEntityDescription.insertNewObject(forEntityName: "Meals", into: context) as? Meals else { return }
        newMeal.id = UUID()
        newMeal.date = mealDate
        newMeal.meals_queue = queue
    }
    
    //
    func createMeals(date: Date, queues: [Queue]){
        for queue in queues {
            createMeal(mealDate: date, queue: queue)
        }
        saveContext()
    }
    
    //
    func fetchMealsByDateAndCreateIfNeeded(date: Date) -> [Meals] {
        let meals: [Meals] = fetchMealsByDate(date: date)
        let allQueues = fetchValidQueues()
        if meals.count < allQueues.count {
            let mealQueues = meals.map { $0.meals_queue }
            let queuesToCreate = allQueues.filter { !mealQueues.contains($0) }
            createMeals(date: date, queues: queuesToCreate)
            return fetchMealsByDate(date: date)
        }
        return meals
    }
    
    //
    func saveContext() {
        try? context.save()
    }
    
    //
    func fetchValidQueues() -> [Queue] {
        let fetchRequest: NSFetchRequest<Queue> = Queue.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "queue > -1")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "queue", ascending: true)]
        guard let result = try? context.fetch(fetchRequest) else { return [] }
        return result
    }
    
    //
    func fetchQueue(by mealName: String) -> Queue? {
        let request: NSFetchRequest<Queue> = Queue.fetchRequest()
        request.predicate = NSPredicate(format: "mealName == %@", mealName)
        return try? context.fetch(request).first
    }
    
    //
    func getQueueByQueueValue(queueValue: Int16) -> Queue? {
        let fetchRequest: NSFetchRequest<Queue> = Queue.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "queue = %@", argumentArray: [queueValue])
        let matchingQueues = try? context.fetch(fetchRequest)
        return matchingQueues?.first
    }
    
    //
    func deleteQueue(queue: Int) {
        guard let result = getQueueByQueueValue(queueValue: Int16(queue)) else { return }
        context.delete(result)
        saveContext()
    }
     
    // Обновляет название элемента очереди по его позиции в ней
    func updateQueueName(queue: Int16, newName: String) {
        guard let queue = getQueueByQueueValue(queueValue: queue) else { return }
        queue.mealName = newName
        saveContext()
    }
    
    // Создаёт новый элемент очереди
    func createQueue(text: String) {
        let newQueue = Queue(context: context)
        newQueue.mealName = text
        let fetchRequest: NSFetchRequest<NSNumber> = NSFetchRequest(entityName: "Queue")
        fetchRequest.resultType = .countResultType
        fetchRequest.propertiesToFetch = ["queue"]
        let count = try? context.count(for: fetchRequest)
        newQueue.queue = Int16(Int(count ?? 0) + 1)
        saveContext()
    }
    
    // Создаёт новое блюдо
    func createDish(mealId: UUID, dishId: UUID, grams: Int64) {
        let fetchRequest: NSFetchRequest<DishesMeals> = DishesMeals.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mealId == %@ AND dishId == %@", mealId as CVarArg, dishId as CVarArg)
        if let existingDishesMeals = try? context.fetch(fetchRequest).last {
            existingDishesMeals.mass += grams
        } else {
            let dishesMeals = DishesMeals(context: context)
            dishesMeals.mealId = mealId
            dishesMeals.dishId = dishId
            dishesMeals.mass = grams
        }
        saveContext()
    }
    
    // Создаёт новое блюдо
    func createNewDish(newDishModel: NewDishModel) {
        let context = CoreDataStack.shared.context
        let dish = Dishes(context: context)
        dish.id = UUID()
        dish.name = newDishModel.dishName
        dish.cals = newDishModel.cals
        dish.protein = newDishModel.proteins
        dish.fats = newDishModel.fats
        dish.carbohydrates = newDishModel.carbs
        CoreDataStack.shared.saveContext()
    }
    
    // Загружает приёмы пищи для даты
    func fetchMealsByDate(date: Date) -> [Meals] {
        let request: NSFetchRequest<Meals> = Meals.fetchRequest()
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let queueSortDescriptor = NSSortDescriptor(key: "meals_queue.queue", ascending: true)
        request.sortDescriptors = [queueSortDescriptor, dateSortDescriptor]
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        let predicate = NSPredicate(format: "date >= %@ && date < %@", startDate as NSDate, endDate as NSDate)
        request.predicate = predicate
        guard let fetchedResults = try? context.fetch(request) else { return [] }
        return fetchedResults
    }
    
    // Загружает блюда приёма пищи
    func fetchDishesByMeal(meal: Meals, toFetch: Int) -> ([Double], [Dishes]) {
        fetchDishByDishMeal(dishMeal: fetchDishesMealsByMeal(meal: meal, toFetch: toFetch), toFetch: toFetch)
    }
    
    // Удаляет блюдо из приёма пищи
    func deleteDishMeal(mealId: UUID, dishId: UUID) {
        let fetchRequest: NSFetchRequest<DishesMeals> = DishesMeals.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mealId == %@ AND dishId == %@",
                                             mealId as CVarArg, dishId as CVarArg)
        let mealsDishes = try? context.fetch(fetchRequest)
        guard let mealDish = mealsDishes?.first else { return }
        context.delete(mealDish)
        saveContext()
    }
    
    // Получает блюдо приёма пищи
    func getDish(dishId: UUID, mealId: UUID) -> DishesMeals? {
        let fetchRequest: NSFetchRequest<DishesMeals> = DishesMeals.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mealId == %@ AND dishId == %@",
                                             mealId as CVarArg, dishId as CVarArg)
        let dishesMeals = try? context.fetch(fetchRequest)
        return dishesMeals?.first
    }
    
    // Обновляет массу блюда приёма пищи
    func updateDish(dishId: UUID, mealId: UUID, mass: Int64) {
        guard let dish = getDish(dishId: dishId, mealId: mealId) else { return }
        dish.mass = mass
        saveContext()
    }
    
    // Получает блюдо из списка блюд приёма пищи
    private func fetchDishByDishMeal(dishMeal: [DishesMeals], toFetch: Int) -> ([Double], [Dishes]) {
        var dishesArray: [Dishes] = []
        var masses: [Double] = []
        for found in dishMeal {
            let fetchRequest: NSFetchRequest<Dishes> = Dishes.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", found.dishId! as CVarArg)
            fetchRequest.fetchLimit = toFetch
            let dishes = try? context.fetch(fetchRequest)
            if let unwrappedDishes = dishes {
                for dish in unwrappedDishes {
                    masses.append(Double(dishMeal.first(where: { $0.dishId == dish.id })?.mass ?? 0))
                    dishesArray.append(dish)
                }
            }
        }
        return (masses, dishesArray)
    }
    
    // Обновляет очередь по входящему массиву их названий
    func updateQueuesFromNames(names: [String]) {
        let request: NSFetchRequest<Queue> = Queue.fetchRequest()
        request.predicate = NSPredicate(format: "queue > -1")
        request.sortDescriptors = [NSSortDescriptor(key: "queue", ascending: true)]
        guard let queues = try? context.fetch(request) else { return }
        for queue in queues {
            guard let name = queue.mealName, let index = names.firstIndex(of: name) else { return }
            queue.queue = Int16(index)
        }
        saveContext()
    }
    
    // Получает блюда приёма пищи по приёму пищи
    private func fetchDishesMealsByMeal(meal: Meals, toFetch: Int) -> [DishesMeals] {
        var dishesMealsArray: [DishesMeals] = []
        let fetchRequest: NSFetchRequest<DishesMeals> = DishesMeals.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mealId == %@", meal.id! as CVarArg)
        fetchRequest.fetchLimit = toFetch
        let dishesMeals = try? context.fetch(fetchRequest)
        if let unwrappedDishesMeals = dishesMeals {
            for dishMeal in unwrappedDishesMeals {
                dishesMealsArray.append(dishMeal)
            }
        }
        return dishesMealsArray
    }
    
    // Производит начальную загрузку информации в базу данных
    func preloadData() {
        guard let dishesUrl = Bundle.main.url(forResource: "dishes", withExtension: "json") else {
            return
        }
        
        let data = try! Data(contentsOf: dishesUrl)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
        let mealsArray = ["Breakfast",
                          "Lunch",
                          "Dinner",
                          "Snack"]
        
        for (index, mealName) in mealsArray.enumerated() {
            let queue = Queue(context: context)
            queue.mealName = mealName
            queue.queue = Int16(index)
        }
        
        for dishJson in json {
            let dish = Dishes(context: context)
            dish.id = UUID()
            dish.name = dishJson["name"] as? String
            dish.cals = dishJson["cals"] as? Double ?? 0
            dish.protein = dishJson["protein"] as? Double ?? 0
            dish.carbohydrates = dishJson["carbohydrates"] as? Double ?? 0
            dish.fats = dishJson["fats"] as? Double ?? 0
        }
        saveContext()
    }
    
    // Создаёт запрос для фильтра по названию блюда
    func createFetchRequest(for searchText: String?) -> NSFetchRequest<Dishes> {
        let request: NSFetchRequest<Dishes> = Dishes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        if let searchText = searchText, !searchText.isEmpty {
            let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
            request.predicate = predicate
        }
        
        return request
    }
    
    // Выполняет фильтрацию по созданному запросу для фильтра
    func filterResults(for searchText: String, fetchedResultController: NSFetchedResultsController<Dishes>) {
        fetchedResultController.fetchRequest.predicate = CoreDataStack.shared.createFetchRequest(for: searchText).predicate
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print("Error performing fetch: \(error)")
        }
    }
    
    // Создаёт NSSortDescriptor для фильтра
    func getSearchSortDescriptor() -> NSSortDescriptor {
        NSSortDescriptor(key: "name", ascending: true)
    }
    
    // Создаёт NSFetchRequest для фильтра
    func getSearchFetchRequest() -> NSFetchRequest<Dishes> {
        Dishes.fetchRequest()
    }
}

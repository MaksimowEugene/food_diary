//import Foundation
//
//struct Day {
//    var meals = [Meal]()
//    var date = Date()
//    internal init(meals: [Meal] = [Meal](), date: Date = Date()) {
//        self.meals = meals
//        self.date = date
//    }
//    mutating func add(_ meal: Meal) {
//        meals.append(meal)
//    }
//    var carbohydrates: Double {
//        return meals.reduce(0.0) { $0 + ($1.carbohydrates ?? 0) }
//    }
//    var proteins: Double {
//        return meals.reduce(0.0) { $0 + ($1.proteins ?? 0) }
//    }
//    var fats: Double {
//        return meals.reduce(0.0) { $0 + ($1.fats ?? 0)}
//    }
//    var cals: Double {
//        return meals.reduce(0.0) { $0 + ($1.cals ?? 0)}
//    }
//}

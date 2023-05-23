import Foundation

struct NewDishModel {
    let dishName: String
    var cals: Double = 0
    var proteins: Double = 0
    var fats: Double = 0
    var carbs: Double = 0
    
    init(dishName: String, cals: Double, proteins: Double, fats: Double, carbs: Double) {
        self.dishName = dishName
        self.cals = cals
        self.proteins = fats
        self.fats = fats
        self.carbs = carbs
    }
}

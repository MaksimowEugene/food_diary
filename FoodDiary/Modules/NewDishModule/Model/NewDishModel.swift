import Foundation

struct NewDishModel {
    let dishName: String
    var cals: Double = 0
    var proteins: Double = 0
    var fats: Double = 0
    var carbs: Double = 0
    
    init(dishName: String, cals: String, proteins: String, fats: String, carbs: String) {
        self.dishName = dishName
        
        guard let calsValue = Double(cals) else { return }
        guard let proteinsValue = Double(proteins) else { return }
        guard let fatsValue = Double(fats) else { return }
        guard let carbsValue = Double(carbs) else { return }

        self.cals = calsValue
        self.proteins = proteinsValue
        self.fats = fatsValue
        self.carbs = carbsValue
    }
}

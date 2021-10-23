import Foundation
import UIKit

// DataModel Operations for Ingredients
extension DataModelOperations {
    
    func addIngredient() {
        if model.focusedIngredientIndex == nil {
            pausePlayback()
            
            let newIngredientModel = IngredientModel(ingredientName: "Temp Ing", ingredientQuantity: "Temp Quant", unit: "Temp Unit", percentThroughClip: model.percentageThroughFocused)
            model.cellAttributes[model.focusedIndex].ingredientModels.append(newIngredientModel)
            
            print("Ingredients in cell \(model.focusedIndex): \(model.cellAttributes[model.focusedIndex].ingredientModels)")
            
            model.cellAttributes[model.focusedIndex].collectionViewCell!.addIngredientEvent()
        }
    }
    
} 

import Foundation
import UIKit

// DataModel Operations for Ingredients
extension DataModelOperations {
    
    func triggerEventAdd() {
        if model.focusedIngredientIndex == nil && model.percentageThroughFocused < 1 - model.configuration!.ingredientEventZoneRightSideInSeconds/model.videoClipAttributes[model.focusedIndex].clipLengthInSeconds! {
            pausePlayback()
            
            model.creationController.displayIngredientsModal(oldIngredient: nil, index: nil)
        }
    }
    
    func addIngredient() {
        model.cellAttributes[model.focusedIndex].collectionViewCell!.addIngredientEvent()
    }
    
    func deleteEvent(eventIndexInCell: Int) {
        print(model.cellAttributes[model.focusedIndex].ingredientModels)
        model.cellAttributes[model.focusedIndex].collectionViewCell!.deleteIngredientEvent(ingredientIndex: eventIndexInCell)
    }
} 

import Foundation
import UIKit

// DataModel Operations for CollectionViewCell
extension DataModelOperations {
    
    func getPercentageThroughFocused() -> CGFloat{
        return model.percentageThroughFocused
    }
    
    // MARK: - Handle Updates to Cell
    
    func configureCell(indexPath: IndexPath) {
        model.cellAttributes[indexPath.row].collectionViewCell!.configure(model: model, index: indexPath.row)
    }
    
    func tellCellToDisplayTrimHandles(index: Int){
        let dLeft = model.cellAttributes[index].trimHandleDistanceFromLeftBoundary
        let dRight = model.cellAttributes[index].trimHandleDistanceFromRightBoundary
//        model.cellAttributes[index].collectionViewCell!.displayTrimHandles(distanceFromLeftBoundary: dLeft, distanceFromRightBoundary: dRight)
    }
    
    func tellCellToHideTrimHandles(index: Int){
        model.cellAttributes[index].collectionViewCell!.hideTrimHandles()
    }
    
    func tellCellToSwitchCellBody(index: Int){
        model.cellAttributes[index].collectionViewCell!.switchCellBody()
    }
    
    func tellCellToRedrawIngredientFrames(index: Int){
        model.cellAttributes[index].collectionViewCell!.redrawIngredientEvents()
    }
    
    
    
    // MARK: - Handler Updates from Cell
    
    func updateTrimHandleDistanceFromLeftBoundary(cellIndex: Int, newDistPercent: CGFloat){
        model.cellAttributes[cellIndex].trimHandleDistanceFromLeftBoundary = newDistPercent
    }
    
    func updateTrimHandleDistanceFromRightBoundary(cellIndex: Int, newDistPercent: CGFloat){
        model.cellAttributes[cellIndex].trimHandleDistanceFromRightBoundary = newDistPercent
    }
    
    func trimHandleTouchBegan(){
        
    }
    
    func trimHandleTouchEnded(isLeft: Bool){
        if isLeft {
            if model.collectionViewOffset! < model.cellAttributes[model.focusedIndex].collectionViewLeftOfCell + model.cellAttributes[model.focusedIndex].trimHandleDistanceFromLeftBoundary * model.cellAttributes[model.focusedIndex].collectionViewFocusedWidthOfCell{
                model.collectionView!.changeOffsetFromDataModelDirection(newOffset: model.cellAttributes[model.focusedIndex].trimHandleDistanceFromLeftBoundary * model.cellAttributes[model.focusedIndex].collectionViewFocusedWidthOfCell + model.cellAttributes[model.focusedIndex].collectionViewLeftOfCell + (model.focusedIndex == 0 ? 0 : 1))
            }
        } else if !isLeft {
            if model.collectionViewOffset! > model.cellAttributes[model.focusedIndex].collectionViewRightOfCell - model.cellAttributes[model.focusedIndex].trimHandleDistanceFromRightBoundary * model.cellAttributes[model.focusedIndex].collectionViewFocusedWidthOfCell {
                model.collectionView!.changeOffsetFromDataModelDirection(newOffset: model.cellAttributes[model.focusedIndex].collectionViewRightOfCell - model.cellAttributes[model.focusedIndex].trimHandleDistanceFromRightBoundary * model.cellAttributes[model.focusedIndex].collectionViewFocusedWidthOfCell - (model.focusedIndex == getCellCount() - 1 ? 0 : 1))
            }
        }
    }
}

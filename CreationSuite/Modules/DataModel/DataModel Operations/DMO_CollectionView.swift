import Foundation
import UIKit

// DataModel Operations for CollectionView 
extension DataModelOperations {  
    
    //MARK: - Handle Requests
    
    func getLeftBoundaryOfCellObject(index: Int) -> CGFloat{
        return model.cellAttributes[index].collectionViewLeftOfCell
    }
    
    func getRightBoundaryOfCellObject(index: Int) -> CGFloat{
        return model.cellAttributes[index].collectionViewRightOfCell
    }
    
    func getLeftBoundaryOfTrimHandle(index: Int) -> CGFloat{
        return model.cellAttributes[index].trimHandleDistanceFromLeftBoundary
    }
    
    func getRightBoundaryOfTrimHandle(index: Int) -> CGFloat{
        return model.cellAttributes[index].trimHandleDistanceFromRightBoundary
    }
    
    func getRawWidthOfCellObject(index: Int) -> CGFloat{
        return model.cellAttributes[index].collectionViewRawWidthOfCell
    }
    
    func getCellIndexPath(index: Int) -> IndexPath{
        return model.cellAttributes[index].indexPath!
    }
    
    func getCellCount() -> Int{
        return model.activeClipCount
    }
    
    func getCurrentFocused() -> Int{
        return model.focusedIndex
    }
    
    func getDisplayWidthOfCell(index: Int) -> CGFloat{
        if model.cellAttributes[index].displayState == .focused {
            return model.cellAttributes[index].collectionViewFocusedWidthOfCell
        } else {
            return model.cellAttributes[index].collectionViewUnfocusedWidthOfCell
        }
    }
    
    func getDisplayHeightOfCell(index: Int) -> CGFloat{
        if index == model.focusedIndex {
            return model.configuration!.focusedCellHeight
        } else {
            return model.configuration!.baseCellHeight
        }
    }
    
    func getIsCellInitialized(index: Int) -> Bool{
        return model.cellAttributes[index].collectionViewCell == nil ? false : true
    }
    
    func getCellAtIndex(index: Int) -> UICollectionViewCell{
        return model.cellAttributes[index].collectionViewCell!
    }
    
    func checkIfWithinIngredientZone(){
        let zoneWidthRightSideInPercent = model.configuration!.ingredientEventZoneRightSideInSeconds /  model.videoClipAttributes[model.focusedIndex].clipLengthInSeconds!
        
        model.focusedIngredientIndex = model.cellAttributes[model.focusedIndex].collectionViewCell!.checkIfWithinIngredientZone(currentPercent: model.percentageThroughFocused, zoneWidthInPercent: zoneWidthRightSideInPercent)
        
    }
    
    //MARK: - Handle Updates
    
    func storeCellAndIndexPath(indexPath: IndexPath, cell: CollectionViewCell) {
        model.cellAttributes[indexPath.row].collectionViewCell = cell
        model.cellAttributes[indexPath.row].indexPath = indexPath
    }
    
    func redrawCells(resize: Bool, recenter: Bool) {
//        if resize {
            model.operations!.updateWidthOfAllCells()
//        }
        model.operations!.updateAllDisplayStates()
        model.operations!.updateEdgesOfAllCells()
        model.collectionView!.layout.invalidateLayout()
    }
    
    func cellUpdateDetected(index: Int) -> Int {
        let completion = cellUpdateExecute(index: index)
        return completion
    }
    
    private func cellUpdateExecute(index: Int) -> Int {
        
        model.focusedIndex = index
        
        for (i, _) in model.cellAttributes.enumerated(){
            guard model.cellAttributes[i].collectionViewCell != nil else {
                break
            }
            tellCellToHideTrimHandles(index: i)
        }
        
        redrawCells(resize: false, recenter: false)
        
        for (i, _) in model.cellAttributes.enumerated(){
            guard model.cellAttributes[i].collectionViewCell != nil else {
                break
            }
            tellCellToSwitchCellBody(index: i)
            tellCellToRedrawIngredientFrames(index: i)
        }
        
        tellCellToDisplayTrimHandles(index: model.focusedIndex)
        
        model.playbackModule!.player.removeAllItems()
        model.operations!.switchClipPlayback()
        model.operations!.hasReachedEnd = false
        
        model.operations!.firstOneThatIsAnError = nil //ugh
//        model.cellAttributes[model.focusedIndex].collectionViewCell!.createCellBody()
        
        return 1
    }
    
    func calcPercentageFromLeft() -> CGFloat {
        let width = model.cellAttributes[model.focusedIndex].collectionViewFocusedWidthOfCell
        let left = model.cellAttributes[model.focusedIndex].collectionViewLeftOfCell
        let leftDistCurr = model.collectionViewOffset! - left
        let percent = leftDistCurr / width
        return percent
    }
    
    func calcPercentageFromRight() -> CGFloat {
        let width = model.cellAttributes[model.focusedIndex].collectionViewFocusedWidthOfCell
        let right = model.cellAttributes[model.focusedIndex].collectionViewRightOfCell
        let rightDistCurr = right - model.collectionViewOffset!
        let percent = rightDistCurr / width
        return percent
    }
    
    func offsetDidChange(newOffset: CGFloat) {
        if !model.isPlaying {
        model.collectionViewOffset = newOffset
        model.percentageThroughFocused = calcPercentageFromLeft()
        seekModuleToTime()
        }
    }
    
    func adjustWidthUnitScale(newScaleValue: CGFloat){
        let currPercent = calcPercentageFromLeft()
        model.configuration!.widthUnitScale = newScaleValue
        redrawCells(resize: true, recenter: true)
        let newOffset = model.cellAttributes[model.focusedIndex].collectionViewLeftOfCell + model.cellAttributes[model.focusedIndex].collectionViewFocusedWidthOfCell * currPercent
        model.collectionView!.contentOffset.x = newOffset
        tellCellToDisplayTrimHandles(index: model.focusedIndex)
        offsetDidChange(newOffset: newOffset)
    }
    
    func triggerClipDelete() {
        pausePlayback()
        model.canDelete = true
        model.creationController.displayDeleteClipModal()
    }
    
    func deleteClip() {
        print("deleting clip \(model.focusedIndex)")
                
        model.cellAttributes[model.focusedIndex].isRemoved = true
        model.cellAttributes.append(model.cellAttributes[model.focusedIndex])
        model.cellAttributes.remove(at: model.focusedIndex)
        
        model.videoClipAttributes.append(model.videoClipAttributes[model.focusedIndex])
        model.videoClipAttributes.remove(at: model.focusedIndex)
        
        model.activeClipCount -= 1
        print("active clips: \(model.activeClipCount)")
        
        let targetCellIndex = model.focusedIndex >= model.activeClipCount ? model.activeClipCount - 1 : model.focusedIndex
        
        model.operations!.reassignIndices(startingAt: targetCellIndex)
        
//        model.collectionView!.deleteItems(at: [model.cellAttributes[model.activeClipCount - 1].indexPath!])
//        print("THE INDEX PATH SAYS: \(model.cellAttributes[model.activeClipCount - 1].indexPath!)")

        
        if model.activeClipCount > 0 {
            _ = model.operations!.cellUpdateDetected(index: targetCellIndex)
            model.collectionView?.jumpToLeftEndOfCell(index: targetCellIndex)

            redrawCells(resize: true, recenter: true)
            model.collectionView!.layout.invalidateLayout()
        }
        
        model.collectionView!.reloadData()
    }
}
    

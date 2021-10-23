import Foundation
import UIKit
import AVFoundation

extension CollectionView {
    // MARK: - CollectionView Interactions
    func switchCell(index: Int) -> Int {
        if dataModel.operations!.cellUpdateDetected(index: index) == 1 {
            generator.selectionChanged()
            return 1
        }
        return 0
    }
    
    // tap on a cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        dataModel.operations!.pausePlayback()
        let index = indexPath.row
        if dataModel.operations!.getCurrentFocused() != index {
            if switchCell(index: index) == 1 {
                autoScroll = true
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
                    self.contentOffset = CGPoint(x: self.dataModel.operations!.getLeftBoundaryOfTrimHandle(index: index) *  self.dataModel.operations!.getDisplayWidthOfCell(index: index) + self.dataModel.operations!.getLeftBoundaryOfCellObject(index: index), y: 0)
                }, completion: animationCompletion)
            }
        }
    }
    
    func animationCompletion(success: Bool)->Void{
        if success {
            autoScroll = false
            dataModel.operations!.offsetDidChange(newOffset: contentOffset.x)
        }
    }
    
    func changeOffsetFromDataModelDirection(newOffset: CGFloat){
        contentOffset.x = newOffset
    }
    
    func jumpToLeftEndOfCell(index: Int) {
        contentOffset.x = dataModel.operations!.getRightBoundaryOfCellObject(index: index) - dataModel.operations!.getRightBoundaryOfTrimHandle(index: index) * dataModel.operations!.getDisplayWidthOfCell(index: index)
    }
    
    func jumpToRightEndOfCell(index: Int) {
        contentOffset.x = dataModel.operations!.getLeftBoundaryOfTrimHandle(index: index) * dataModel.operations!.getDisplayWidthOfCell(index: index) + dataModel.operations!.getLeftBoundaryOfCellObject(index: index)
    }
    
    // scroll to a new cell
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dataModel.operations!.pausePlayback()
    }
    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if !dataModel.isPlaying {
            if !jumping && !autoScroll {
                // pass left trim handle
                if contentOffset.x < dataModel.operations!.getLeftBoundaryOfTrimHandle(index: dataModel.operations!.getCurrentFocused()) * dataModel.operations!.getDisplayWidthOfCell(index:  dataModel.operations!.getCurrentFocused()) + dataModel.operations!.getLeftBoundaryOfCellObject(index: dataModel.operations!.getCurrentFocused()) && dataModel.operations!.getCurrentFocused() != 0 {
                    jumping = true
                    let newIndex = dataModel.operations!.getCurrentFocused() - 1
                    if switchCell(index: newIndex) == 1 {
                        jumpToLeftEndOfCell(index: dataModel.operations!.getCurrentFocused())
                    }
                    jumping = false
                    
                    // pass right trim handle
                } else if contentOffset.x > dataModel.operations!.getRightBoundaryOfCellObject(index: dataModel.operations!.getCurrentFocused()) - dataModel.operations!.getRightBoundaryOfTrimHandle(index: dataModel.operations!.getCurrentFocused()) * dataModel.operations!.getDisplayWidthOfCell(index:  dataModel.operations!.getCurrentFocused()) && dataModel.operations!.getCurrentFocused() != dataModel.operations!.getCellCount() - 1 {
                    jumping = true
                    let newIndex = dataModel.operations!.getCurrentFocused() + 1
                    if switchCell(index: newIndex) == 1 {
                        jumpToRightEndOfCell(index: dataModel.operations!.getCurrentFocused())
                    }
                    jumping = false
                    
                    
                    
                    // beginning case, hits left trim handle
                } else if contentOffset.x < dataModel.operations!.getLeftBoundaryOfTrimHandle(index: dataModel.operations!.getCurrentFocused()) * dataModel.operations!.getDisplayWidthOfCell(index:  dataModel.operations!.getCurrentFocused()) + dataModel.operations!.getLeftBoundaryOfCellObject(index: dataModel.operations!.getCurrentFocused()) && dataModel.operations!.getCurrentFocused() == 0 {
                    contentOffset.x = dataModel.operations!.getLeftBoundaryOfTrimHandle(index: dataModel.operations!.getCurrentFocused()) * dataModel.operations!.getDisplayWidthOfCell(index:  dataModel.operations!.getCurrentFocused()) + dataModel.operations!.getLeftBoundaryOfCellObject(index: dataModel.operations!.getCurrentFocused())
                    
                    // end case, hits right trim handle
                } else if contentOffset.x > dataModel.operations!.getRightBoundaryOfCellObject(index: dataModel.operations!.getCurrentFocused()) - dataModel.operations!.getRightBoundaryOfTrimHandle(index: dataModel.operations!.getCurrentFocused()) * dataModel.operations!.getDisplayWidthOfCell(index:  dataModel.operations!.getCurrentFocused()) && dataModel.operations!.getCurrentFocused() == dataModel.operations!.getCellCount() - 1 {
                    contentOffset.x = dataModel.operations!.getRightBoundaryOfCellObject(index: dataModel.operations!.getCurrentFocused()) - dataModel.operations!.getRightBoundaryOfTrimHandle(index: dataModel.operations!.getCurrentFocused()) * dataModel.operations!.getDisplayWidthOfCell(index:  dataModel.operations!.getCurrentFocused())
                }
                dataModel.operations!.checkIfWithinIngredientZone()
                dataModel.operations!.offsetDidChange(newOffset: contentOffset.x)
                print("Ingredient in focus:", dataModel.focusedIngredientIndex)
            }
//        }
    }
    //
    //    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    //    }
    //
    //    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset:
    //                                    UnsafeMutablePointer<CGPoint>) {
    //    }
}


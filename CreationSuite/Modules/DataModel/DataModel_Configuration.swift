import Foundation
import UIKit
import AVFoundation
import AWSS3StoragePlugin
import AWSCognitoAuthPlugin


// configuration
class DataModelConfiguration {
    
    let model: DataModel
    
    init(dataModel: DataModel){ 
        model = dataModel
    }
    
    enum unitToSecondCoversion: CGFloat {
        case short = 16 // 16 width units per second, will elongate the video
        
        case normal = 12 // 12 width units per second
        
        case long = 1 // 5 wifth units per second, will shorten the video
    }
    
    func determineConversionRate(length: CGFloat) -> CGFloat? {
        switch length {
        
        // 5 - 30 seconds
        case _ where length < 10:
            return unitToSecondCoversion.short.rawValue
            
        // 10 - 30 seconds
        case _ where length >= 10 && length < 30:
            return unitToSecondCoversion.normal.rawValue
            
        // >30 seconds
        case _ where length >= 30:
            return unitToSecondCoversion.long.rawValue
            
        // less than 5
        default:
            return nil
        }
    }
    
    let widthUnit: CGFloat = UIScreen.main.bounds.width/100
    var widthUnitScale: CGFloat = 1.4
    
    let inset: CGFloat = UIScreen.main.bounds.width/2
    let interItemSpacing: CGFloat = 6
    let baseCellHeight: CGFloat = 80
    let focusedCellHeight: CGFloat = 96
    
    let scrubBarThumbnailUnfocusedWidth: Int = 46
    let scrubBarThumbnailFocusedWidth: Int = 54
    
//    let minimumClipDurationInSeconds = 5
    
    let ingredientEventZoneRightSideInSeconds: CGFloat = 1.0
    
    func configureCellAttributes(cells: [CellModel], index: Int) -> CellModel {
        let focusedWidth = calcFocusedWidthOfCell(cellIndex: index)
        let unfocusedWidth = calcUnfocusedWidthOfCell(cellIndex: index)
        let newCellModel = CellModel(collectionViewCell: nil,
                                     indexPath: nil,
                                     collectionViewRawWidthOfCell: calcRawWidthOfCell(cellIndex: index),
                                     collectionViewUnfocusedWidthOfCell: unfocusedWidth,
                                     collectionViewFocusedWidthOfCell: focusedWidth,
                                     displayState: CellModel.CollectionViewDisplayWidthOfCell.unfocused,
                                     collectionViewLeftOfCell: calcLeftOfCell(cellsArr: cells, cellIndex: index),
                                     collectionViewRightOfCell: calcRightOfCell(cellsArr: cells, cellIndex: index, focused: focusedWidth, unfocused: unfocusedWidth),
                                     trimHandleDistanceFromLeftBoundary: 0,
                                     trimHandleDistanceFromRightBoundary: 0,
                                     isRemoved: false
        )
        return newCellModel
    }
    
    func getWidthAdjustedForThumbnail (rawWidth: CGFloat, focused: Bool) -> CGFloat {
        let intWidth = Int(rawWidth)
        let r: Int
        if focused {
            r = intWidth % scrubBarThumbnailFocusedWidth
        } else {
            r = intWidth % scrubBarThumbnailUnfocusedWidth
        }
        var newWidth = CGFloat(intWidth - r)
        if newWidth == 0 {
            newWidth = focused ? CGFloat(scrubBarThumbnailFocusedWidth) : CGFloat(scrubBarThumbnailUnfocusedWidth)
        }
        return newWidth
    }
    
    func calcRawWidthOfCell(cellIndex: Int) -> CGFloat {
        let length = model.videoClipAttributes[cellIndex].clipLengthInSeconds
        let rawWidth = CGFloat(length! * widthUnit * widthUnitScale)
        return rawWidth
    }
    
    func calcUnfocusedWidthOfCell(cellIndex: Int) -> CGFloat {
//        let length = model.videoClipAttributes[cellIndex].clipLengthInSeconds
//        let rawWidth = length! * widthUnit * widthUnitScale * determineConversionRate(length: length!)!
//        let adjustedWidth = getWidthAdjustedForThumbnail(rawWidth: rawWidth, focused: false)
        let length = model.videoClipAttributes[cellIndex].clipLengthInSeconds
        let rawWidth = length! * widthUnit * widthUnitScale * determineConversionRate(length: length!)!
        let adjustedWidth = getWidthAdjustedForThumbnail(rawWidth: rawWidth, focused: true)
        
        let numFocusedSegs = adjustedWidth / CGFloat(scrubBarThumbnailFocusedWidth)
        let newWidth = (numFocusedSegs - 1) * CGFloat(scrubBarThumbnailUnfocusedWidth)
        return newWidth
    }
    
    func calcFocusedWidthOfCell(cellIndex: Int) -> CGFloat {
        let length = model.videoClipAttributes[cellIndex].clipLengthInSeconds
        let rawWidth = length! * widthUnit * widthUnitScale * determineConversionRate(length: length!)!
        let adjustedWidth = getWidthAdjustedForThumbnail(rawWidth: rawWidth, focused: true)
        return adjustedWidth
    }
    
    func calcRightOfCell(cellsArr: [CellModel], cellIndex: Int, focused: CGFloat, unfocused: CGFloat) -> CGFloat {
        var total: CGFloat = 0
        if cellIndex > 0 && cellsArr.count > 0 {
            total += cellsArr[cellIndex - 1].collectionViewRightOfCell
            total += interItemSpacing
        }
        total += cellIndex == model.focusedIndex ? focused : unfocused
        return total
    }
    
    func calcLeftOfCell(cellsArr: [CellModel], cellIndex: Int) -> CGFloat {
        var total: CGFloat = 0
        if cellIndex > 0  && cellsArr.count > 0 {
            total += cellsArr[cellIndex - 1].collectionViewRightOfCell
            total += interItemSpacing
        }
        return total
    }
}


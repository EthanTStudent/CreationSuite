import Foundation
import UIKit

class IngredientEvent: UIView { 
    
    let ingredientIndexWithinCell: Int
    let cell: CollectionViewCell
    
    let percentThroughCell: CGFloat
    
    var focusedDimension: CGFloat = 25
    var unfocusedDimension: CGFloat = 18
    var focusedFrame: CGRect
    var unfocusedFrame: CGRect
    
    var ingredientIsFocused: Bool = false {
        didSet {
          if ingredientIsFocused == true {
            self.backgroundColor = .red
          } else {
            self.backgroundColor = .cyan
          }
        }
    }

    init(percent: CGFloat, parentModule: CollectionViewCell, index: Int){
        ingredientIndexWithinCell = index
        cell = parentModule
        percentThroughCell = percent
        
        focusedFrame = CGRect(x: cell.dataModel!.cellAttributes[cell.cellIndex!].collectionViewFocusedWidthOfCell * percent - (focusedDimension/2), y: -focusedDimension / 2, width: focusedDimension, height: focusedDimension)
        unfocusedFrame = CGRect(x: cell.dataModel!.cellAttributes[cell.cellIndex!].collectionViewUnfocusedWidthOfCell * percent - (unfocusedDimension/2), y: -unfocusedDimension / 2, width: unfocusedDimension, height: unfocusedDimension)
        
        super.init(frame: focusedFrame)
        
        let textLabel = UILabel()
        textLabel.text = "\(index)"
        textLabel.textColor = .white
        
        self.frame = frame
    }
    
    func changeFrame(focused: Bool){
        if focused {
            frame = focusedFrame
        } else {
            frame = unfocusedFrame
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

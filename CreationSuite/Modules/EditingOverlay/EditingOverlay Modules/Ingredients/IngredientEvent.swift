import Foundation
import UIKit

class IngredientEvent: UIView { 
    
    var ingredientIndexWithinCell: Int
    let cell: CollectionViewCell
    
    var percentThroughCell: CGFloat 
    
    let desiredLineWidth: CGFloat = 1
    
    enum IconState {
        case unfocusedCell, focusedCell, focusedIcon, movingIcon
    }
    
    let movingIconPath = UIBezierPath(
        arcCenter: CGPoint(x: 0 ,y: -10),
        radius: CGFloat( 25 ),
        startAngle: CGFloat(0),
         endAngle:CGFloat(Double.pi * 2),
        clockwise: true).cgPath
    
    let focusedIconPath = UIBezierPath(
        arcCenter: CGPoint(x: 0 ,y: 0),
        radius: CGFloat( 25 ),
        startAngle: CGFloat(0),
         endAngle:CGFloat(Double.pi * 2),
        clockwise: true).cgPath
    
    let focusedCellPath = UIBezierPath(
        arcCenter: CGPoint(x: 0 ,y: 0),
        radius: CGFloat( 16 ),
        startAngle: CGFloat(0),
         endAngle:CGFloat(Double.pi * 2),
        clockwise: true).cgPath
    
    var currentState: IconState = .unfocusedCell {
        didSet {
            guard focusedFrame != nil && unfocusedFrame != nil else { return }
            switch currentState {
            
            case .movingIcon:
                let animation = CABasicAnimation(keyPath: "path")
                animation.toValue = movingIconPath
                animation.duration = 0.15
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                animation.fillMode = CAMediaTimingFillMode.both
                animation.repeatCount = 1 // Infinite repeat
                animation.autoreverses = false
                animation.isRemovedOnCompletion = false
                
                icon.path = focusedIconPath
                
                icon.removeAllAnimations()
                icon.add(animation, forKey: animation.keyPath)
                currentStateJustPrevious = .movingIcon
                
            case .focusedIcon:
                if currentStateJustPrevious == .focusedCell || currentStateJustPrevious == .movingIcon {
                    let animation = CABasicAnimation(keyPath: "path")
                    animation.toValue = focusedIconPath
                    animation.duration = 0.15
                    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                    animation.fillMode = CAMediaTimingFillMode.both
                    animation.repeatCount = 1 // Infinite repeat
                    animation.autoreverses = false
                    animation.isRemovedOnCompletion = false
                    
                    icon.path = currentStateJustPrevious == .focusedCell ? focusedCellPath : movingIconPath
                    
                    icon.removeAllAnimations()
                    icon.add(animation, forKey: animation.keyPath)
                    currentStateJustPrevious = .focusedIcon
                } else if currentStateJustPrevious == nil {
                    icon.path = focusedIconPath
                }
                currentStateJustPrevious = .focusedIcon
                
                
            case .focusedCell:
                frame = focusedFrame!

                if currentStateJustPrevious == .focusedIcon {
                    let animation = CABasicAnimation(keyPath: "path")
                    animation.toValue = focusedCellPath
                    animation.duration = 0.15
                    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                    animation.fillMode = CAMediaTimingFillMode.both
                    animation.repeatCount = 1 // Infinite repeat
                    animation.autoreverses = false
                    animation.isRemovedOnCompletion = false
                    
                    icon.path = focusedIconPath
                    icon.removeAllAnimations()
                    icon.add(animation, forKey: animation.keyPath)
                } else {
                    icon.path = focusedCellPath
                }
                currentStateJustPrevious = .focusedCell
               
            case .unfocusedCell:
                frame = unfocusedFrame!
                currentStateJustPrevious = .unfocusedCell
                
                icon.path = UIBezierPath(
                    arcCenter: CGPoint(x: 0 ,y: 0),
                    radius: CGFloat( 10 ),
                    startAngle: CGFloat(0),
                     endAngle:CGFloat(Double.pi * 2),
                    clockwise: true).cgPath

                icon.removeAllAnimations()
            }
            
        }
    }
    
    func redrawFrames(){
        focusedFrame = CGRect(x: percentThroughCell * focusedX, y: 0, width: 25, height: 25)
        unfocusedFrame = CGRect(x: percentThroughCell * unfocusedX, y: 0, width: 25, height: 25)
        
        self.frame = focusedFrame!
    }
    
    var currentStateJustPrevious: IconState?
    
    let focusedX: CGFloat
    let unfocusedX: CGFloat
    var focusedFrame: CGRect?
    var unfocusedFrame: CGRect?
    
    var unfocusedDimension: CGFloat = 18
    
    var icon = IngredientIcon()
    
    var ingredientIsFocused: Bool = false

    init(percent: CGFloat, parentModule: CollectionViewCell, index: Int){
        ingredientIndexWithinCell = index
        cell = parentModule
        percentThroughCell = percent
            
        focusedX = cell.dataModel!.cellAttributes[cell.cellIndex!].collectionViewFocusedWidthOfCell
        unfocusedX = cell.dataModel!.cellAttributes[cell.cellIndex!].collectionViewUnfocusedWidthOfCell
        focusedFrame = CGRect(x: percent * focusedX, y: 0, width: 25, height: 25)
        unfocusedFrame = CGRect(x: percent * unfocusedX, y: 0, width: 25, height: 25)
                
        super.init(frame: focusedFrame!)

        backgroundColor = .clear
        
        let textLabel = UILabel()
        textLabel.text = "\(index)"
        textLabel.textColor = .white
                
        self.layer.addSublayer(icon)
    }
    
    @objc func setMovingIcon(_ sender: UILongPressGestureRecognizer){
        guard currentState == .focusedIcon else { return }
        if(sender.state == .began)
        {
            currentState = .movingIcon
        }
        else if(sender.state == .changed)
        {

        }
        else if(sender.state == .ended)
        {
            print("RELEASED")
            currentState = .unfocusedCell
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class IngredientIcon: CAShapeLayer {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(){
            // your desired value
               
            super.init()
        
           let circlePath = UIBezierPath(
                   arcCenter: CGPoint(x: 0, y: 0),
                   radius: CGFloat(0),
                   startAngle: CGFloat(0),
                    endAngle:CGFloat(Double.pi * 2),
                   clockwise: true)
       
            path = circlePath.cgPath
        
//            shadowPath = circlePath.cgPath

               
            fillColor = UIColor.green.cgColor
            strokeColor = UIColor.red.cgColor
            lineWidth = 2
        }
   }




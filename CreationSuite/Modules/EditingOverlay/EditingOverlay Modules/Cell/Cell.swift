import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let identifier = "CollectionViewCell"
        
    var dataModel: DataModel?
    var cellIndex: Int?
    let operations = CellOperations()
    
    var focusedCellBody: CellBody?
    var unfocusedCellBody: CellBody?
    
    var leftTrimHandle: TrimHandle?
    var rightTrimHandle: TrimHandle?
    private var initialX: CGFloat = 0
    
    var ingredientEventsWithinCell: [IngredientEvent] = []
    
    let ingredientEventDimension: CGFloat = 40
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leftTrimHandle = TrimHandle(frame: CGRect(x: 0, y: -20, width: 20, height: 130), isLeft: true)
        let panGestureRecognizerLeft = UIPanGestureRecognizer(target: self, action: #selector(didPanLeftHorizontally(_:)))
        leftTrimHandle!.addGestureRecognizer(panGestureRecognizerLeft)
        leftTrimHandle!.isHidden = true
        
        rightTrimHandle = TrimHandle(frame: CGRect(x: 0, y: -20, width: 20, height: 130), isLeft: false)
        let panGestureRecognizerRight = UIPanGestureRecognizer(target: self, action: #selector(didPanRightHorizontally(_:)))
        rightTrimHandle!.addGestureRecognizer(panGestureRecognizerRight)
        rightTrimHandle!.isHidden = true
                
        addSubview(leftTrimHandle!)
        addSubview(rightTrimHandle!)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(model: DataModel, index: Int){
        dataModel = model
        cellIndex = index
        backgroundColor = .clear
        if focusedCellBody == nil || unfocusedCellBody == nil {
            focusedCellBody = dataModel!.cellAttributes[cellIndex!].focusedCellBody
            unfocusedCellBody = dataModel!.cellAttributes[cellIndex!].unfocusedCellBody
            
            contentView.addSubview(focusedCellBody!)
            contentView.addSubview(unfocusedCellBody!)
            contentView.layer.masksToBounds = true
            
            focusedCellBody!.isHidden = true
            focusedCellBody!.isHidden = true
        }
    }
    
    func displayTrimHandles(distanceFromLeftBoundary: CGFloat, distanceFromRightBoundary: CGFloat){
        guard leftTrimHandle != nil && rightTrimHandle != nil else {
            return
        }
        leftTrimHandle!.center.x = dataModel!.operations!.getDisplayWidthOfCell(index: cellIndex!) * distanceFromLeftBoundary
        rightTrimHandle!.center.x = dataModel!.operations!.getDisplayWidthOfCell(index: cellIndex!) - dataModel!.operations!.getDisplayWidthOfCell(index: cellIndex!) * distanceFromRightBoundary
        leftTrimHandle!.isHidden = false
        rightTrimHandle!.isHidden = false
    }
    
    func hideTrimHandles(){
        guard leftTrimHandle != nil && rightTrimHandle != nil else {
            return
        }
        leftTrimHandle!.isHidden = true
        rightTrimHandle!.isHidden = true
    }
    
    func switchCellBody(){
        guard focusedCellBody != nil && unfocusedCellBody != nil else {
            return
        }
        if cellIndex == dataModel!.operations!.getCurrentFocused() {
            focusedCellBody!.isHidden = false
            unfocusedCellBody!.isHidden = true
            contentView.layer.cornerRadius = 10
        } else {
            unfocusedCellBody!.isHidden = false
            focusedCellBody!.isHidden = true
            contentView.layer.cornerRadius = 0

        }
    }
    
    func addIngredientEvent(){
        let newEvent = IngredientEvent(percent: dataModel!.operations!.getPercentageThroughFocused(), parentModule: self, index: ingredientEventsWithinCell.count)
        ingredientEventsWithinCell.append(newEvent)
        self.addSubview(newEvent)
        newEvent.ingredientIsFocused = true
    }
    
    func redrawIngredientEvents(){
        let isFocused = cellIndex == dataModel!.focusedIndex ? true : false
        for event in ingredientEventsWithinCell{
            event.changeFrame(focused: isFocused)
            if !isFocused {
                event.ingredientIsFocused = false
            }
        }
    }
    
    //you cant add another ingredient while it's within x number of seconds after another event
    func checkIfWithinIngredientZone(currentPercent: CGFloat, zoneWidthInPercent: CGFloat) -> Int? {
            var ingredientInFocus: Int? = nil
            for (index, ingredient) in ingredientEventsWithinCell.enumerated() {
            if currentPercent > ingredient.percentThroughCell && currentPercent < ingredient.percentThroughCell + zoneWidthInPercent {
                //check to see if the ingredient found is the one already selected, if so,
                //give it priority
                if index == dataModel!.focusedIngredientIndex {
                    return index
                }
                ingredientInFocus = index
            } else {
                if ingredient.ingredientIsFocused {
                    ingredient.ingredientIsFocused = false
                }
            }
        }
        //if a new ingredient is found to be in proximity, set that to true
        if ingredientInFocus != nil {
            ingredientEventsWithinCell[ingredientInFocus!].ingredientIsFocused = true
        }
        return ingredientInFocus
    }
    
    // MARK: - Trim Handle Interactions

    @objc private func didPanLeftHorizontally(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:

            initialX = leftTrimHandle!.center.x
            dataModel!.operations!.trimHandleTouchBegan()
            leftTrimHandle!.handle!.fillColor = leftTrimHandle!.activeColor
        case .changed:
            let translation = sender.translation(in: contentView)
            if initialX + translation.x > 0 && initialX + translation.x < rightTrimHandle!.center.x
            {
                leftTrimHandle!.center.x = initialX + translation.x
            }
        case .ended:
            if leftTrimHandle!.center.x < 10 {
                leftTrimHandle!.center.x = 0
            }
            leftTrimHandle!.handle!.fillColor = leftTrimHandle!.inactiveColor
            let newDistPercent = leftTrimHandle!.center.x / dataModel!.operations!.getDisplayWidthOfCell(index: cellIndex!)
            dataModel!.operations!.updateTrimHandleDistanceFromLeftBoundary(cellIndex: cellIndex!, newDistPercent: newDistPercent)
            dataModel!.operations!.trimHandleTouchEnded(isLeft: true)
        default:
            break
        }
    }
    
    @objc private func didPanRightHorizontally(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            initialX = rightTrimHandle!.center.x
            dataModel!.operations!.trimHandleTouchBegan()
            rightTrimHandle!.handle!.fillColor = rightTrimHandle!.activeColor
        case .changed:
            let translation = sender.translation(in: contentView)
            if initialX + translation.x < dataModel!.operations!.getDisplayWidthOfCell(index: cellIndex!) && initialX + translation.x > leftTrimHandle!.center.x
            {
                rightTrimHandle!.center.x = initialX + translation.x
                
            }
        case .ended:
            if rightTrimHandle!.center.x > dataModel!.operations!.getDisplayWidthOfCell(index: cellIndex!) - 10
            {
                rightTrimHandle!.center.x = dataModel!.operations!.getDisplayWidthOfCell(index: cellIndex!)
            }
            let newDistPercent = 1 - rightTrimHandle!.center.x / dataModel!.operations!.getDisplayWidthOfCell(index: cellIndex!)
            rightTrimHandle!.handle!.fillColor = rightTrimHandle!.inactiveColor
            dataModel!.operations!.updateTrimHandleDistanceFromRightBoundary(cellIndex: cellIndex!, newDistPercent: newDistPercent)
            dataModel!.operations!.trimHandleTouchEnded(isLeft: false)
        default:
            break
        }
    }
}

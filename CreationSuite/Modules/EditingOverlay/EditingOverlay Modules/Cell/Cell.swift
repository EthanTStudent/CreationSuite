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
    
    var ingredientBeingMoved: Int? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leftTrimHandle = TrimHandle(frame: CGRect(x: 0, y: -20, width: 20, height: 130), isLeft: true)
        let panGestureRecognizerLeft = UIPanGestureRecognizer(target: self, action: #selector(didPanLeftTrimHandleHorizontally(_:)))
        leftTrimHandle!.addGestureRecognizer(panGestureRecognizerLeft)
        leftTrimHandle!.isHidden = true
        
        rightTrimHandle = TrimHandle(frame: CGRect(x: 0, y: -20, width: 20, height: 130), isLeft: false)
        let panGestureRecognizerRight = UIPanGestureRecognizer(target: self, action: #selector(didPanRightTrimHandleHorizontally(_:)))
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
    
    func createLongPressGr(index: Int) -> CustomLongPressGesture {
        let longPressGR = CustomLongPressGesture(target: self, action: #selector(didLongPressIngredientIcon))
        longPressGR.eventIndex = index
        longPressGR.delegate = self
        
        return longPressGR
    }
    
    func createTapGr(index: Int) -> CustomTapGesture {
        let tapGR = CustomTapGesture(target: self, action: #selector(didTapIngredientIcon))
        tapGR.eventIndex = index
        tapGR.delegate = self
        tapGR.cell = cellIndex
        
        return tapGR
    }
    
    func createPanGr(index: Int) -> CustomPanGesture {
        let panGR = CustomPanGesture(target: self, action: #selector(didPanIngredientIconHorizontally))
        panGR.eventIndex = index
        panGR.delegate = self
        
        return panGR
    }
    
    // MARK: - Ingredient Event Interactions
    
    func addIngredientEvent(){
        let newIngredientModel = IngredientModel(ingredientName: "", ingredientQuantity: 0 , unit: "", percentThroughClip: 0)
        dataModel!.cellAttributes[cellIndex!].ingredientModels.append(newIngredientModel)
        print(dataModel!.cellAttributes[cellIndex!].ingredientModels)
        
        let index = ingredientEventsWithinCell.count
        let newEvent = IngredientEvent(percent: dataModel!.operations!.getPercentageThroughFocused(), parentModule: self, index: index)
        ingredientEventsWithinCell.append(newEvent)

        newEvent.addGestureRecognizer(createLongPressGr(index: index))
        newEvent.addGestureRecognizer(createPanGr(index: index))
        newEvent.addGestureRecognizer(createTapGr(index: index))
        
        newEvent.currentState = .focusedIcon
        
        self.addSubview(newEvent)
    }
    
    func deleteIngredientEvent(ingredientIndex: Int){
        print("TRYING TO REMOVE INGREDIENT NUMBER: \(ingredientIndex)")
        ingredientEventsWithinCell[ingredientIndex].removeFromSuperview()
        
        for (index, event) in ingredientEventsWithinCell.enumerated() {
            event.ingredientIndexWithinCell = index
            event.gestureRecognizers!.removeAll()
            
            event.addGestureRecognizer(createLongPressGr(index: index))
            event.addGestureRecognizer(createPanGr(index: index))
            event.addGestureRecognizer(createTapGr(index: index))
        }
        
    }
    
    class CustomLongPressGesture: UILongPressGestureRecognizer {
        var eventIndex: Int?
    }
    
    class CustomPanGesture: UIPanGestureRecognizer {
        var eventIndex: Int?
    }
    
    class CustomTapGesture: UITapGestureRecognizer {
        var cell: Int?
        var eventIndex: Int?
    }
    
    func redrawIngredientEvents(){
        let isFocused = cellIndex == dataModel!.focusedIndex ? true : false
        for event in ingredientEventsWithinCell{
            event.currentState = isFocused ? .focusedCell : .unfocusedCell
        }
    }
    
    //you cant add another ingredient while it's within x number of seconds after another event
    func checkIfWithinIngredientZone(currentPercent: CGFloat, zoneWidthInPercent: CGFloat) -> Int? {
        var ingredientInFocus: Int? = nil
        for (index, ingredient) in ingredientEventsWithinCell.enumerated() {
            if currentPercent > ingredient.percentThroughCell - zoneWidthInPercent && currentPercent < ingredient.percentThroughCell + zoneWidthInPercent {
                //check to see if the ingredient found is the one already selected, if so,
                //give it priority
                if index == dataModel!.focusedIngredientIndex {
                    return index
                }
                if dataModel!.operations!.firstOneThatIsAnError == nil {
                    dataModel!.operations!.firstOneThatIsAnError = index
                } else {
                    ingredientInFocus = index
                }
            } else {
                if ingredient.currentState == .focusedIcon {
                    ingredient.currentState = .focusedCell
                }
            }
        }
        //if a new ingredient is found to be in proximity, set that to true
        if ingredientInFocus != nil {
            ingredientEventsWithinCell[ingredientInFocus!].currentState = .focusedIcon
        }
        return ingredientInFocus
    }
    
    func checkForIngredientZonesDuringPan(targetPercent: CGFloat, zoneWidthInPercent: CGFloat, currIndex: Int) -> Bool {
        for (index, ingredient) in ingredientEventsWithinCell.enumerated() {
            if targetPercent > ingredient.percentThroughCell - zoneWidthInPercent && targetPercent < ingredient.percentThroughCell + zoneWidthInPercent && currIndex != index
            {
                return false
            }
        }
        return true
    }
    
    @objc private func didTapIngredientIcon(_ sender: CustomTapGesture) {
        if dataModel!.cellAttributes[sender.cell!].collectionViewCell!.ingredientEventsWithinCell[sender.eventIndex!].currentState == .focusedIcon {
            dataModel!.creationController.displayIngredientsModal(oldIngredient: dataModel!.cellAttributes[sender.cell!].ingredientModels[sender.eventIndex!], index: sender.eventIndex!)
        } else {
            dataModel!.operations!.jumpToIngredient(cell: sender.cell!, ingredient: sender.eventIndex!)
        }
    }
    
    @objc private func didLongPressIngredientIcon(_ sender: CustomLongPressGesture) {
        if ingredientEventsWithinCell[sender.eventIndex!].currentState == .focusedIcon || ingredientEventsWithinCell[sender.eventIndex!].currentState == .movingIcon {
            switch sender.state {
            case .began:
                print("beginning")
                ingredientEventsWithinCell[sender.eventIndex!].currentState = .movingIcon
                ingredientBeingMoved = sender.eventIndex!
                dataModel!.overlayElementPanning = true
                self.ingredientEventsWithinCell[sender.eventIndex!].layer.shadowOffset = CGSize(width: 3, height: 3)
                UIView.animate(withDuration: 0.15, animations: {
                    self.ingredientEventsWithinCell[sender.eventIndex!].layer.shadowOpacity = 0.3
                })
                
            case .ended:
                print("ending")
                ingredientEventsWithinCell[sender.eventIndex!].currentState = .focusedIcon
                dataModel!.overlayElementPanning = false
                ingredientBeingMoved = nil
                self.ingredientEventsWithinCell[sender.eventIndex!].currentState = .focusedIcon
                UIView.animate(withDuration: 0.15, animations: {
                    self.ingredientEventsWithinCell[sender.eventIndex!].layer.shadowOpacity = 0
                })
            default:
                break
            }
        } else {
            return
        }
    }
    
    @objc private func didPanIngredientIconHorizontally(_ sender: CustomPanGesture) {
//        print("made it here")
        guard self.ingredientBeingMoved == sender.eventIndex! else { return }
//        print("made it there")
        switch sender.state {
        case .began:
            initialX = self.ingredientEventsWithinCell[sender.eventIndex!].center.x
        case .changed:
            let translation = sender.translation(in: contentView)
            if initialX + translation.x < dataModel!.operations!.getDisplayWidthOfCell(index: cellIndex!) - dataModel!.operations!.getDisplayWidthOfCell(index: cellIndex!) * (dataModel!.configuration!.ingredientEventZoneRightSideInSeconds / dataModel!.videoClipAttributes[cellIndex!].clipLengthInSeconds!) && initialX + translation.x > 0 && checkForIngredientZonesDuringPan(targetPercent: (initialX + translation.x) / dataModel!.operations!.getDisplayWidthOfCell(index: cellIndex!) , zoneWidthInPercent: (dataModel!.configuration!.ingredientEventZoneRightSideInSeconds / dataModel!.videoClipAttributes[cellIndex!].clipLengthInSeconds!), currIndex: sender.eventIndex!)
            {
                self.ingredientEventsWithinCell[sender.eventIndex!].center.x = initialX + translation.x
                self.ingredientEventsWithinCell[sender.eventIndex!].percentThroughCell = self.ingredientEventsWithinCell[sender.eventIndex!].center.x / dataModel!.operations!.getDisplayWidthOfCell(index: cellIndex!)
                self.ingredientEventsWithinCell[sender.eventIndex!].redrawFrames()
                
                dataModel!.operations!.trackTimeToOverlayElement(percent: self.ingredientEventsWithinCell[sender.eventIndex!].percentThroughCell)
            }
        default:
            break
        }
    }
    
    
    // MARK: - Trim Handle Interactions
    
    @objc private func didPanLeftTrimHandleHorizontally(_ sender: UIPanGestureRecognizer) {
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
    
    @objc private func didPanRightTrimHandleHorizontally(_ sender: UIPanGestureRecognizer) {
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


extension CollectionViewCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(
      _ gestureRecognizer: UIGestureRecognizer,
      shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
      return true
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        gestureRecognizer.
//        return true
//    }
}


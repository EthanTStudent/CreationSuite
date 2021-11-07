

import Foundation
import AVFoundation
import AVKit
import Amplify
import AWSS3StoragePlugin
import AWSCognitoAuthPlugin

import Combine

class DataModelOperations: NSObject {
    
    let model: DataModel
    var currNum = 0
    
    var hasReachedEnd: Bool = false

    init(dataModel: DataModel){
        model = dataModel
    }

    //ugh, this is a crap way to deal with this ...
    var firstOneThatIsAnError: Int? = nil
    
    func initializeCellArray(videoClipsArr: [VideoClipModel], cells: [CellModel]) -> [CellModel] {
        var newCellArray: [CellModel] = []
        for (index, _) in videoClipsArr.enumerated() {
            let newCellModel = model.configuration!.configureCellAttributes(cells: cells, index: index)
            newCellArray.append(newCellModel)
        }
        return newCellArray
    }
    
    func initializeVideoClipModels(AWSSources: [String]) {
        for (index, source) in AWSSources.enumerated() {
            var newClipModel: VideoClipModel?
            let downloadToFileName = FileManager.default.urls(for: .documentDirectory,
                                                              in: .userDomainMask)[0]
                .appendingPathComponent("_\(index).mov")
            newClipModel = VideoClipModel(videoClip: nil, AWSURL: source, localURL: downloadToFileName, clipLengthInSeconds: nil)
            print("this first one should be 0:", self.model.videoClipAttributes.count)
            self.model.videoClipAttributes.append(newClipModel!)
                self.readAWStoLocalURL(AWSURL: source, index: index, local: downloadToFileName)
        }
    }
    
    //AWS to local URL
    func readAWStoLocalURL(AWSURL: String, index: Int, local: URL) -> Void {
        
        Amplify.Storage.downloadFile(
            key: AWSURL,
            local: local,
            progressListener: { progress in
                print("Progress: \(progress)")
            }, resultListener: { event in
                switch event {
                case let .success(data):
                    print("Completed: \(data)")
                    let newVideoClip = AVAsset(url: local)
                    let duration = CGFloat(CMTimeGetSeconds(newVideoClip.duration))
                    self.model.videoClipAttributes[index].videoClip = newVideoClip
                    self.model.videoClipAttributes[index].clipLengthInSeconds = duration
                    self.currNum += 1
                    if self.currNum ==  self.model.videoClipAttributes.count {
                        print("got there!!!...")
                        self.model.continueInitialization()
                        return
                    }
                    print("nope")
                case let .failure(storageError):
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                }
            }
        )
    }
    
    func createAllCellBodies(){
        for (index, _) in model.cellAttributes.enumerated(){
            if model.cellAttributes[index].focusedCellBody == nil {
                model.cellAttributes[index].focusedCellBody = CellBody(fCellWidth: model.cellAttributes[index].collectionViewFocusedWidthOfCell, ufCellWidth: model.cellAttributes[index].collectionViewUnfocusedWidthOfCell, fCellHeight: model.configuration!.focusedCellHeight, ufCellHeight: model.configuration!.baseCellHeight, fThumbnailWidth: CGFloat(model.configuration!.scrubBarThumbnailFocusedWidth), ufThumbnailWidth: CGFloat(model.configuration!.scrubBarThumbnailUnfocusedWidth), focused: true, asset: model.videoClipAttributes[index].videoClip!, frame: CGRect(x: 0, y: 0, width: model.cellAttributes[index].collectionViewFocusedWidthOfCell, height: model.configuration!.focusedCellHeight))
            }
            if model.cellAttributes[index].unfocusedCellBody == nil {
                model.cellAttributes[index].unfocusedCellBody = CellBody(fCellWidth: model.cellAttributes[index].collectionViewFocusedWidthOfCell, ufCellWidth: model.cellAttributes[index].collectionViewUnfocusedWidthOfCell, fCellHeight: model.configuration!.focusedCellHeight, ufCellHeight: model.configuration!.baseCellHeight, fThumbnailWidth: CGFloat(model.configuration!.scrubBarThumbnailFocusedWidth), ufThumbnailWidth: CGFloat(model.configuration!.scrubBarThumbnailUnfocusedWidth), focused: false, asset: model.videoClipAttributes[index].videoClip!, frame: CGRect(x: 0, y: 0, width: model.cellAttributes[index].collectionViewUnfocusedWidthOfCell, height: model.configuration!.baseCellHeight))
            }
        }
    }
    
    func updateAllDisplayStates(){
        for (index, _) in model.cellAttributes.enumerated(){
            model.cellAttributes[index].displayState = index == model.focusedIndex ? .focused : .unfocused
        }
    }
    
    func updateEdgesOfAllCells(){
        for (index, _) in model.cellAttributes.enumerated(){
            model.cellAttributes[index].collectionViewLeftOfCell = model.configuration!.calcLeftOfCell(cellsArr: model.cellAttributes, cellIndex: index)
            model.cellAttributes[index].collectionViewRightOfCell = model.configuration!.calcRightOfCell(cellsArr: model.cellAttributes, cellIndex: index, focused:  model.cellAttributes[index].collectionViewFocusedWidthOfCell, unfocused: model.cellAttributes[index].collectionViewUnfocusedWidthOfCell)
        }
    }
    
    func updateWidthOfAllCells(){
        for (index, _) in model.cellAttributes.enumerated(){
            model.cellAttributes[index].collectionViewRawWidthOfCell = model.configuration!.calcRawWidthOfCell(cellIndex: index)
            model.cellAttributes[index].collectionViewUnfocusedWidthOfCell = model.configuration!.calcUnfocusedWidthOfCell(cellIndex: index)
            model.cellAttributes[index].collectionViewFocusedWidthOfCell = model.configuration!.calcFocusedWidthOfCell(cellIndex: index)
        }
    }
    
    func overlayElementIsPlayhead() {
        model.collectionView!.isScrollEnabled = false
        model.creationController.editingOverlay!.playhead.isHidden = true
    }
    
    func overlayElementIsNoLongerPlayhead() {
        model.collectionView!.isScrollEnabled = true
        model.creationController.editingOverlay!.playhead.isHidden = false
        let secondsThrough = CGFloat(model.playbackModule!.player.currentTime().seconds)
        let percentThrough = secondsThrough / model.videoClipAttributes[model.focusedIndex].clipLengthInSeconds!
        model.collectionView!.contentOffset.x = model.operations!.getLeftBoundaryOfCellObject(index: model.focusedIndex) + model.operations!.getDisplayWidthOfCell(index: model.focusedIndex) * percentThrough
    }
    
    func trackTimeToOverlayElement(percent: CGFloat) {
        model.playbackModule!.player.seek(to: CMTime(value: CMTimeValue(model.videoClipAttributes[model.focusedIndex].clipLengthInSeconds! * percent * 600), timescale: 600), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
    
    func jumpToIngredient(cell: Int, ingredient: Int) {
        if cell == model.focusedIndex || cell != model.focusedIndex && model.operations!.cellUpdateDetected(index: cell) == 1 {
            model.collectionView!.autoScroll = true
            if cell == model.focusedIndex {
                for event in model.cellAttributes[model.focusedIndex].collectionViewCell!.ingredientEventsWithinCell {
                    event.currentState = .focusedCell
                }
                model.cellAttributes[model.focusedIndex].collectionViewCell!.ingredientEventsWithinCell[ingredient].currentState = .focusedIcon
            }
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
                self.model.collectionView!.contentOffset = CGPoint(x: self.getLeftBoundaryOfCellObject(index: cell) + self.getDisplayWidthOfCell(index: cell) * self.model.cellAttributes[cell].collectionViewCell!.ingredientEventsWithinCell[ingredient].percentThroughCell, y: 0)
            }, completion: self.model.collectionView!.animationCompletion)
        }
    }
    
    func reassignIndices(startingAt: Int) {
        for i in startingAt..<model.cellAttributes.count {
            model.cellAttributes[i].indexPath!.row = i
        }
    }
    
    func getUnremovedIndexFromAgnosticInt(agnosticIndex: Int) -> Int {
        var index = -1
        var count = 0
        while count != agnosticIndex {
            if !model.cellAttributes[index].isRemoved {
                count += 1
            }
            index += 1
        }
        return index
    }
}


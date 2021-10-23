

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
    
}


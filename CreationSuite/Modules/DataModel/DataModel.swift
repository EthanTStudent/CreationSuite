import Foundation
import UIKit
import AVFoundation
import AWSS3StoragePlugin
import AWSCognitoAuthPlugin


class DataModel: NSObject {
    
    let creationController: CreationSuiteController
    
    var configuration: DataModelConfiguration?
    var operations: DataModelOperations?
    
    var collectionView: CollectionView?
    var playbackModule: PlaybackModule?
    
    var videoClipAttributes: [VideoClipModel] = []
    var cellAttributes: [CellModel] = []
    
    var focusedIndex: Int = 0
    var collectionViewOffset: CGFloat?
    var percentageThroughFocused: CGFloat = 0
    
    var isPlaying: Bool = false
    
    var focusedIngredientIndex: Int? = nil
    
    enum playbackMethod {
        case none, looping, autoContinue
    }
    
    var currPlaybackMethod: playbackMethod = .none
    
    var overlayElementPanning: Bool = false {
        didSet {
            if overlayElementPanning == true {
                operations!.overlayElementIsPlayhead()
            } else {
                operations!.overlayElementIsNoLongerPlayhead()
            }
        }
    }
    
    let tempURLS: [String] = ["60f79e12ba03b900151ed251_6169ba44d173f80016b16037_6169ba44d173f80016b16036_6169ba44d173f80016b16035_0_video_clip_id.mov"
                              
                              
                              ,"60f79e12ba03b900151ed251_0e9bfacf_0_video_segment.mov", "60f79e12ba03b900151ed251_45cf625b_3_video_segment.mov"]
    
    init(controller: CreationSuiteController) {
        creationController = controller
        super.init()
        configuration = DataModelConfiguration(dataModel: self)
        operations = DataModelOperations(dataModel: self)
        
        operations!.initializeVideoClipModels(AWSSources: tempURLS)
        focusedIndex = 0 // whichever one you want to start out
    }
    
    func continueInitialization() {
        DispatchQueue.main.async {
            self.cellAttributes = self.operations!.initializeCellArray(videoClipsArr: self.videoClipAttributes, cells: self.cellAttributes)
            
            // create thumbnails for every video
            self.operations!.createAllCellBodies()
            
            self.creationController.videosLoaded()
        }
    }
}

struct VideoClipModel {
    var videoClip: AVAsset?
    let AWSURL: String
    let localURL: URL?
    var clipLengthInSeconds: CGFloat?
}

struct CellModel {
    var collectionViewCell: CollectionViewCell?
    var indexPath: IndexPath?
    
    var collectionViewRawWidthOfCell: CGFloat
    var collectionViewUnfocusedWidthOfCell: CGFloat
    var collectionViewFocusedWidthOfCell: CGFloat
    
    enum CollectionViewDisplayWidthOfCell {
        case focused, unfocused
    }
    var displayState = CollectionViewDisplayWidthOfCell.unfocused
    
    var collectionViewLeftOfCell: CGFloat
    var collectionViewRightOfCell: CGFloat
    
    var trimHandleDistanceFromLeftBoundary: CGFloat
    var trimHandleDistanceFromRightBoundary: CGFloat
    
    var focusedCellBody: CellBody?
    var unfocusedCellBody: CellBody?
    
    var ingredientModels: [IngredientModel] = []
    
    var isRemoved: Bool
}

struct IngredientModel {
    var ingredientName: String
    var ingredientQuantity: CGFloat
    var unit: String
    
    var percentThroughClip: CGFloat
}


import Foundation
import UIKit

class EditingOverlayOperations: NSObject {
    let parentModule: EditingOverlay
    
    init(module: EditingOverlay) {
        parentModule = module
    }
    
    func tellPlayPause() {
        parentModule.model.operations!.switchIsPlaying()
    }
    
    func tellSwitchPlaybackMethod() {
        parentModule.model.operations!.switchPlaybackMethod()
    }

}

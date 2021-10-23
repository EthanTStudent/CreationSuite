import Foundation
import UIKit

class EditingOverlayManager: NSObject {
    let parentModule: EditingOverlay
    
    init(module: EditingOverlay) {
        parentModule = module
    }
}

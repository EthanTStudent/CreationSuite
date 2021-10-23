//import Foundation
//import UIKit
//
//class RecordingManager: NSObject {
//    
//    @objc func toggleRecordingDispatch(_ node: NSNumber, targetRecordingState: String) {
//      DispatchQueue.main.async {
//        let component = self.bridge.uiManager.view(
//          forReactTag: node
//        ) as! GemModel
//        component.toggleRecordingManager(targetRecordingState: targetRecordingState)
//        print("SWIFT: recieved target recording state: \(targetRecordingState)")
//      }
//    }
//    
//    @objc func switchVideoModeDispatch(_ node: NSNumber, videoMode: String) {
//      DispatchQueue.main.async {
//        let component = self.bridge.uiManager.view(
//          forReactTag: node
//        ) as! GemModel
//        component.switchVideoModeManager(videoMode: videoMode)
//      }
//    }
//
//    
//    @objc func continueWithSaveDispatch(_ node: NSNumber, videoUploadKey: String) {
//      DispatchQueue.main.async {
//        let component = self.bridge.uiManager.view(
//          forReactTag: node
//        ) as! GemModel
//        component.continueWithSaveManager(videoUploadKey: videoUploadKey)
//      }
//    }
//    
//    @objc func continueWithoutSaveDispatch(_ node: NSNumber) {
//      DispatchQueue.main.async {
//        let component = self.bridge.uiManager.view(
//          forReactTag: node
//        ) as! GemModel
//        component.continueWithoutSaveManager()
//      }
//    }
//    
//    @objc func endSessionDispatch(_ node: NSNumber) {
//      DispatchQueue.main.async {
//        let component = self.bridge.uiManager.view(
//          forReactTag: node
//        ) as! GemModel
//        component.endSessionManager()
//      }
//    }
//}

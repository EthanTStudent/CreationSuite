//import Foundation
//import UIKit
//
//// manager
//extension CameraAndSession {
//    @objc func getRecordingPermissionsDispatch(_ node: NSNumber) {
//      DispatchQueue.main.async {
//        let component = self.bridge.uiManager.view(
//          forReactTag: node
//        ) as! GemModel
//        component.getRecordingPermissionsManager()
//      }
//    }
//
//    @objc func requestCameraAccessDispatch(_ node: NSNumber) {
//      DispatchQueue.main.async {
//        let component = self.bridge.uiManager.view(
//          forReactTag: node
//        ) as! GemModel
//        component.requestCameraAccessManager()
//      }
//    }
//
//    @objc func requestMicrophoneAccessDispatch(_ node: NSNumber) {
//      DispatchQueue.main.async {
//        let component = self.bridge.uiManager.view(
//          forReactTag: node
//        ) as! GemModel
//        component.requestMicrophoneAccessManager()
//      }
//    }
//
//    @objc func getConfigurationStatusDispatch(_ node: NSNumber) {
//      DispatchQueue.main.async {
//        let component = self.bridge.uiManager.view(
//          forReactTag: node
//        ) as! GemModel
//        component.getConfigurationStatusManager()
//      }
//    }
//
//    @objc func getSessionStatusDispatch(_ node: NSNumber) {
//      DispatchQueue.main.async {
//        let component = self.bridge.uiManager.view(
//          forReactTag: node
//        ) as! GemModel
//        component.getSessionStatusManager()
//      }
//    }
//
//    @objc func configureGemDispatch(_ node: NSNumber) {
//      DispatchQueue.main.async {
//        let component = self.bridge.uiManager.view(
//          forReactTag: node
//        ) as! GemModel
//        component.configureGemManager()
//      }
//    }
//
//    @objc func startSessionDispatch(_ node: NSNumber) {
//      DispatchQueue.main.async {
//        let component = self.bridge.uiManager.view(
//          forReactTag: node
//        ) as! GemModel
//        component.startSessionManager()
//      }
//    }
//}

//import Foundation
//import UIKit
//import AVFoundation
//
//// operations
//extension CameraAndSession {
//
//    public func getConfigurationStatus(completion: @escaping (_ status: String) -> Void) {
//      if self.activeVideoDeviceInput != nil && self.activeAudioDeviceInput != nil{
//        completion("CONFIGURED")
//        }
//      completion("NOT_CONFIGURED")
//    }
//
//    public func requestCameraAccess(access: @escaping (_ cameraAccess: String) -> Void) {
//      sessionQueue.suspend()
//      AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
//        if granted {
//          access("TRUE")
//        } else if !granted {
//          access("FALSE")
//          self.setupResult = .notAuthorized
//        }
//        self.sessionQueue.resume()
//      })
//    }
//
//    public func requestMicrophoneAccess(access: @escaping (_ micAccess: String) -> Void) {
//      sessionQueue.suspend()
//      AVCaptureDevice.requestAccess(for: .audio, completionHandler: { granted in
//        if granted {
//          access("TRUE")
//        } else if !granted {
//          access("FALSE")
//          self.setupResult = .notAuthorized
//        }
//        self.sessionQueue.resume()
//      })
//    }
//
//    public func getRecordingPermissions(permissions: (_ camera: String, _ microphone: String) -> Void) {
//      var cameraPermission: String = ""
//      var microphonePermission: String = ""
//
//      switch AVCaptureDevice.authorizationStatus(for: .video) {
//      case .authorized:
//        cameraPermission = "TRUE"
//      default:
//        cameraPermission = "FALSE"
//    }
//      switch AVCaptureDevice.authorizationStatus(for: .audio) {
//      case .authorized:
//        microphonePermission = "TRUE"
//      default:
//        microphonePermission = "FALSE"
//    }
//      permissions(cameraPermission, microphonePermission)
//    }
//
//    public func getSessionStatus(completion: @escaping (_ status: String) -> Void) {
//      if self.isSessionRunning == self.session.isRunning {
//        completion("ACTIVE")
//        }
//      completion("NOT_ACTIVE")
//    }
//
//}

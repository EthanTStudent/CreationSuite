//import Foundation
//import UIKit
//import AVFoundation
//import Combine
//
//class RecordingModule: UIView {
//    
//    let session: AVCaptureSession
//    let cameraAndSessionConfig: CameraAndSession
//    let recordingOperations: RecordingOperations
//    let recordingManager: RecordingManager
//    
//    init(controller: CreationSuiteController){
//        cameraAndSessionConfig = CameraAndSession(module: self)
//        recordingOperations = RecordingOperations(module: self, session: session)
//        recordingManager = RecordingManager(module: self)
//        
//        let recordingView = RecordingView(session: session, frame: frame)
//        self.addSubview(recordingView)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:)")
//    }
//}
//
//class RecordingView: UIView {
//  
//  override class var layerClass: AnyClass {
//    AVCaptureVideoPreviewLayer.self
//  }
//  var videoPreviewLayer: AVCaptureVideoPreviewLayer {
//    return layer as! AVCaptureVideoPreviewLayer
//  }
//      
//  init(session: AVCaptureSession, frame: CGRect){
//    super.init(frame: frame)
//    backgroundColor = .black
//    videoPreviewLayer.cornerRadius = 10
//    videoPreviewLayer.connection?.videoOrientation = .portrait
//    videoPreviewLayer.session = session
//  }
//  
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//}

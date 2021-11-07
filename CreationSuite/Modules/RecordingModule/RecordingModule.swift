    import Foundation
    import UIKit
    import AVFoundation
    import Combine

    class RecordingModule: UIView {
        
    let model: DataModel

    let session = AVCaptureSession()
    var cameraAndSessionConfig: CameraAndSession?
    //    let recordingOperations: RecordingOperations
    //    let recordingManager: RecordingManager

    init(dataModel: DataModel, frame: CGRect){
        model = dataModel
        super.init(frame: frame)
        backgroundColor = .black
        videoPreviewLayer.cornerRadius = 10
        videoPreviewLayer.connection?.videoOrientation = .portrait
        videoPreviewLayer.session = session

        cameraAndSessionConfig = CameraAndSession(module: self, camSession: self.session)
        
        cameraAndSessionConfig!.configure{_,_ in }
        //        recordingOperations = RecordingOperations(module: self, session: session)
        //        recordingManager = RecordingManager(module: self)
    }

    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
        
    var videoPreviewLayer: AVCaptureVideoPreviewLayer { return layer as! AVCaptureVideoPreviewLayer }
        
    required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
}

//import Foundation
//import UIKit
//import AVFoundation
//
//// configuration
//class CameraAndSession: NSObject {
//    
//    let parentModule: RecordingModule
//    
//    init(module: RecordingModule) {
//        parentModule = module
//    }
//    
//    var activeVideoDeviceInput: AVCaptureDeviceInput? = nil
//    var activeAudioDeviceInput: AVCaptureDeviceInput? = nil
//    
//    var isConfigured = false
//    
//    var currentURL: URL? = nil
//    var session = AVCaptureSession()
//    
//    var isSessionRunning = false
//    var setupResult: SessionSetupResult = .success
//    
//    let sessionQueue = DispatchQueue(label: "session queue")
//    
//    @objc dynamic var videoDeviceInput: AVCaptureDeviceInput!
//    @objc dynamic var audioDeviceInput: AVCaptureDeviceInput!
//    
//    private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera], mediaType: .video, position: .unspecified)
//    
//    private let photoOutput = AVCapturePhotoOutput()
//    
//    private var keyValueObservations = [NSKeyValueObservation]()
//    
//    public var connection: AVCaptureConnection? = nil
//    
//    public func configure(completion: @escaping (_ success: String, _ error: String?) -> Void) {
//        sessionQueue.async {
//            if self.setupResult != .success {
//                return
//            }
//            print("Configruing session \(self.session)")
//            
//            self.session.beginConfiguration()
//            print("attempting to configure")
//            
//            self.session.sessionPreset = .hd1280x720
//            
//            do {
//                var defaultVideoDevice: AVCaptureDevice?
//                if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
//                    defaultVideoDevice = frontCameraDevice
//                } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
//                    defaultVideoDevice = backCameraDevice
//                }
//                
//                guard let videoDevice = defaultVideoDevice else {
//                    print("Default video device is unavailable.")
//                    completion("ERROR", "Default video device is unavailable.")
//                    self.setupResult = .configurationFailed
//                    self.session.commitConfiguration()
//                    return
//                }
//                
//                let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
//                self.activeVideoDeviceInput = self.videoDeviceInput
//                
//                if self.session.canAddInput(videoDeviceInput) {
//                    self.session.addInput(videoDeviceInput)
//                    self.videoDeviceInput = videoDeviceInput
//                    
//                } else {
//                    completion("ERROR", "Couldn't add video device input to the session.")
//                    print("Couldn't add video device input to the session.")
//                    
//                    self.setupResult = .configurationFailed
//                    self.session.commitConfiguration()
//                    return
//                }
//            } catch {
//                completion("ERROR", "Couldn't create video device input.")
//                print("Couldn't create video device input.")
//                self.setupResult = .configurationFailed
//                self.session.commitConfiguration()
//                return
//            }
//            
//            do {
//                let audioDevice = AVCaptureDevice.default(for: .audio)
//                let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice!)
//                self.activeAudioDeviceInput = self.audioDeviceInput
//                
//                
//                if self.session.canAddInput(audioDeviceInput) {
//                    self.session.addInput(audioDeviceInput)
//                } else {
//                    completion("ERROR", "Could not add audio device input to the session")
//                    return
//                }
//            } catch {
//                completion("ERROR", "Could not create audio device input.")
//                return
//            }
//            
//            completion("SUCCESS", nil)
//            self.isConfigured = true
//            self.session.commitConfiguration()
//        }
//    }
//    
//    /// - Tag: Stop capture session
//    
//    public func stop(completion: ((String, String?) -> (Void))? = nil) {
//        sessionQueue.async {
//            if self.isSessionRunning {
//                if self.setupResult == .success {
//                    self.session.stopRunning()
//                    self.isSessionRunning = self.session.isRunning
//                    
//                    if completion != nil {
//                        if !self.session.isRunning {
//                            let endSessionSuccess: String = "SUCCESS"
//                            let endSessionError: String? = nil
//                            DispatchQueue.main.async {
//                                completion!(endSessionSuccess, endSessionError)
//                            }
//                        } else {
//                            let endSessionSuccess: String = "ERROR"
//                            let endSessionError: String? = "failed to end session"
//                            DispatchQueue.main.async {
//                                completion!(endSessionSuccess, endSessionError)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    /// - Tag: Start capture session
//    
//    public func start(completion: @escaping (_ success: String, _ error: String?) -> Void) {
//        //        We use our capture session queue to ensure our UI runs smoothly on the main thread.
//        sessionQueue.async {
//            if !self.isSessionRunning && self.isConfigured {
//                switch self.setupResult {
//                case .success:
//                    self.session.startRunning()
//                    self.isSessionRunning = self.session.isRunning
//                    completion("SUCCESS", nil)
//                    
//                case .configurationFailed, .notAuthorized:
//                    completion("ERROR", "Application not authorized to use camera")
//                }
//            }
//        }
//    }
//}
//
//
//
//extension CameraAndSession {
//    enum SessionSetupResult {
//        case success
//        case notAuthorized
//        case configurationFailed
//    }
//}
//
//extension AVCaptureDevice.DiscoverySession {
//    var uniqueDevicePositionsCount: Int {
//        
//        var uniqueDevicePositions = [AVCaptureDevice.Position]()
//        
//        for device in devices where !uniqueDevicePositions.contains(device.position) {
//            uniqueDevicePositions.append(device.position)
//        }
//        
//        return uniqueDevicePositions.count
//    }
//}
//

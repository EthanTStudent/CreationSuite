//import Foundation
//import UIKit
//import AVFoundation
//
//class RecordingOperations: NSObject {
//
//    public func toggleRecording(targetRecordingState: String, completion: (_ toggleSuccess: String?, _ toggleError: String?, _ videoClipURI: String?) -> Void) {
//
//      if targetRecordingState == "RECORDING" {
//        if self.session.canAddOutput(self.output) {
//          session.beginConfiguration()
//          session.addOutput(self.output)
//          self.session.commitConfiguration()
//        } else {
//          completion("ERROR", "can't_add_output", "test3383883")
//          return
//        }
//        connection = output.connection(with: .video)
//        connection!.videoOrientation = AVCaptureVideoOrientation.portrait
//        let availableVideoCodecTypes = output.availableVideoCodecTypes
//        if availableVideoCodecTypes.contains(.hevc){
//          output.setOutputSettings([AVVideoCodecKey: AVVideoCodecType.hevc], for: connection!)}
//
//        let outputFileName = NSUUID().uuidString
//        let outputFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mov")!)
//        let videoClipURI: URL = URL(fileURLWithPath: outputFilePath)
//        output.startRecording(to: videoClipURI, recordingDelegate: self)
//        completion("SUCCESS", nil, "test553535")
//      }
//      else if targetRecordingState == "NOT_RECORDING" {
//        print("successfully stopped recording")
//        let completionURI: String = output.outputFileURL!.absoluteString
//        output.stopRecording()
//        print("uri:", completionURI)
//        completion("SUCCESS", nil, completionURI)
//      }
//    }
//
//    public func cleanupFileAtURL(outputURL: URL, completion: (_ success: String, _ error: String?) -> Void) {
//      print("cleanup checkpoint 2")
//
//      let path = outputURL.path
//      if FileManager.default.fileExists(atPath: path) {
//        do {
//          try FileManager.default.removeItem(atPath: path)
//          if !FileManager.default.fileExists(atPath: path) {
//            completion("SUCCESS", nil)
//            print("cleanup checkpoint 3")
//
//          }
//        } catch {
//          print("Could not remove file at url: \(outputURL)")
//          completion("ERROR", "failed_to_cleanup_file")
//        }
//      } else {
//        completion("ERROR", "failed_to_cleanup_file")
//      }
//    }
//
//    /// - Tag: DidStartRecording
//    public func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
//      print("later check: output recording?", output.isRecording)
//    }
//
//    /// - Tag: DidFinishRecording
//    public func fileOutput(_ output: AVCaptureFileOutput,
//                           didFinishRecordingTo outputFileURL: URL,
//                           from connections: [AVCaptureConnection],
//                           error: Error?) {
//      if error != nil {
////        GemModel().notifyReactOfRecordingInterruption(recordingInterruptedError: String(describing: error!))
//        self.session.removeOutput(output)
//        self.cleanupFileAtURL(outputURL: outputFileURL) { success, error in
//          if success == "SUCCESS" {
//            print("cleanup successful")
//          }
//        }
//        output.isRecording ? output.stopRecording() : nil
//        print("THERE WAS AN ERROR!")
//      } else {
//        self.currentAsset = AVAsset(url: outputFileURL)
//        self.currentAsset!.loadValuesAsynchronously(forKeys: ["tracks"], completionHandler: {
//          var error: NSError? = nil
//          switch self.currentAsset!.statusOfValue(forKey: "tracks", error: &error) {
//          case .loaded:
//            DispatchQueue.main.async {
//              self.currentURL = outputFileURL
//              self.session.removeOutput(output)
//            }
//          case .failed:
//            print(error!)
//            self.session.removeOutput(output)
//            self.cleanupFileAtURL(outputURL: outputFileURL) { success, error in
//              if success == "SUCCESS" {
//                print("cleanup successful")
//              }
//            }
//          default:
//            self.session.removeOutput(output)
//            self.cleanupFileAtURL(outputURL: outputFileURL) { success, error in
//              if success == "SUCCESS" {
//                print("cleanup successful")
//              }
//            }
//            break;
//          }
//        })
//      }
//    }
//
//    public func handleVideoUpload(videoUploadKey: String, completion: @escaping (_ success: String, _ error: String?) -> Void) {
//
//      let moviekey = videoUploadKey
//      let keyComponents = videoUploadKey.components(separatedBy: "_")
//      let picturekey = "\(keyComponents[0])_\(keyComponents[1])_thumbnail_image.jpeg"
//
//      let thumbnailData = getThumbnail(asset: self.currentAsset!)
//      guard thumbnailData != nil else {
//        completion("ERROR", "no thumbnail returned")
//        return
//      }
//      let thumbnailPromise = Promise<String>(on: .global()) { fulfill, reject in
//        thumbnailUpload(Data: thumbnailData!, key: picturekey, completion: {(success, error) in
//          fulfill(error ?? success)
//        })
//      }
//      let videoPromise = Promise<String>(on: .global()) { fulfill, reject in
//        videoUpload(URL: self.currentURL!, key: moviekey, completion: {(success, error) in
//          fulfill(error ?? success)
//        })
//      }
//      all(thumbnailPromise, videoPromise).then { thumbnailVerdict, videoVerdict in
//        if thumbnailVerdict == "SUCCESS" && videoVerdict == "SUCCESS" {
//          completion("SUCCESS", nil)
//          print("video upload: \(videoVerdict), thumbnail upload: \(thumbnailVerdict)")
//        } else {
//          completion("ERROR", "video upload: \(videoVerdict), thumbnail upload: \(thumbnailVerdict)")
//          print("ERROR", "video upload: \(videoVerdict), thumbnail upload: \(thumbnailVerdict)")
//
//        }
//      }
//    }
//
//
//    public func cleanupAssetAtContinue(completion: @escaping (_ success: String, _ error: String?) -> Void) {
//      self.cleanupFileAtURL(outputURL: self.currentURL!, completion: {(success, error) in
//        completion(success,error)
//      })
//      self.currentAsset = nil
//      self.currentURL = nil
//    }
//
//    //  public func handleMergeVideos(urlsArray: NSArray){
//    //    var URLArray = [URL]()
//    //    for url in urlsArray {
//    //      var tempUrl: URL
//    //      tempUrl = URL(fileURLWithPath: url as! String)
//    //      URLArray.append(tempUrl)
//    //    }
//    //    if URLArray.count == urlsArray.count {
//    //      mergeVideos(URLArray: URLArray)
//    //    }
//    //  }
//}

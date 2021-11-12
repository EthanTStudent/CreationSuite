//
//  CellBody.swift
//  CreationSuite
//
//  Created by Ethan Treiman on 10/19/21.
//

import Foundation
import AVFoundation
import UIKit

class CellBody: UIImageView {
            
    var focusedCellWidth: CGFloat?
    var unfocusedCellWidth: CGFloat?
    var focusedCellHeight: CGFloat?
    var unfocusedCellHeight: CGFloat?
    var focusedThumbnailWidth: CGFloat?
    var unfocusedThumbnailWidth: CGFloat?
    
    init(fCellWidth: CGFloat, ufCellWidth: CGFloat, fCellHeight: CGFloat, ufCellHeight: CGFloat, fThumbnailWidth: CGFloat, ufThumbnailWidth: CGFloat, focused: Bool, asset: AVAsset, frame: CGRect){
        
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        self.contentMode = .scaleAspectFit
        focusedCellWidth = fCellWidth
        unfocusedCellWidth = ufCellWidth
        focusedCellHeight = fCellHeight
        unfocusedCellHeight = ufCellHeight
        
        focusedThumbnailWidth = fThumbnailWidth
        unfocusedThumbnailWidth = ufThumbnailWidth
        
        let frameArray: [Int] = configureThumbnailArray(focused: focused, asset: asset)
        let dataArray: [Data?]? = getThumbnails(asset: asset, frameArray: frameArray)
        
        var imagesArray = [ImageToCombine]()
        for datum in dataArray! {
            imagesArray.append(ImageToCombine(data: datum!))
        }
        
        self.image = combine(images: imagesArray, focused: focused)
    }
    
    // MARK: - Configure Thumbnail Image Array
    
    func calcTargetThumbnailNum(focused: Bool) -> Int {
        var targetNum = 0
        if focused {
            targetNum = Int(focusedCellWidth! / CGFloat(focusedThumbnailWidth!))
        } else {
            targetNum = Int(unfocusedCellWidth! / CGFloat(unfocusedThumbnailWidth!))
        }
        if targetNum == 0
        {
            targetNum = 1;
        }
        return targetNum
    }
    
    func configureThumbnailArray(focused: Bool, asset: AVAsset) -> [Int] {
        let targetNum = calcTargetThumbnailNum(focused: focused)
        
        let assetDurationInSeconds = CMTimeGetSeconds(asset.duration)
        let assetDuriationIn24FPS: Int = Int(assetDurationInSeconds * 24)
        let framesPerThumbnail = Int(assetDuriationIn24FPS / targetNum)
        
        // make initial time assignments in seconds
        var thumbnailFrames = [Int]()
        var currentFrame: Int = 0

        for _ in 0..<targetNum {
            let newNum = currentFrame
            thumbnailFrames.append(newNum)
            currentFrame += framesPerThumbnail
        }

        //make later adjustments
        if thumbnailFrames.count > 1 {
            thumbnailFrames[0] = thumbnailFrames[1] > 15 ? 10 : 0
        }
///        thumbnailFrames[thumbnailFrames.count - 1] = assetDuriationIn24FPS - 10
        
        return thumbnailFrames
    }
    
    public func getThumbnails(asset: AVAsset, frameArray: [Int]) -> [Data?]? {
      do {
          var data = [Data?]()
          let imgGenerator = AVAssetImageGenerator(asset: asset)
          imgGenerator.appliesPreferredTrackTransform = true
        imgGenerator.requestedTimeToleranceBefore = .zero
        imgGenerator.requestedTimeToleranceAfter = .zero
        for frame in frameArray {
            
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: Int64(frame) * 30, timescale: 24 * 30), actualTime: nil)
            
//            something to try eventually
///            DispatchQueue.global(qos: .background).async {
///                imageGenerator.generateCGImagesAsynchronously(forTimes: localValue, completionHandler: ({ (startTime, generatedImage, endTime, result, error) in
///                    //Save image to file or perform any task
///                }))
///            }
            
            let thumbnail = UIImage(cgImage: cgImage)
            data.append(thumbnail.jpegData(compressionQuality: 1) ?? nil)
        }
          return data
      } catch let error {
          print("*** Error generating thumbnail: \(error.localizedDescription)")
          return nil
      }
    }
    
    // MARK: - Combine Operation
    
    struct ImageToCombine {
        var image = UIImage()
        
        var size: CGSize {
            get {
                return CGSize(width: image.size.width, height: image.size.height)
            }
        }
        
        var widthAndHeightRatio: CGFloat {
            get {
                return image.size.width/image.size.height
            }
        }
        
        init (data: Data) {
            self.image = UIImage(data: data)!
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func combine(images: [ImageToCombine], focused: Bool) -> UIImage {
        
        var fullWidth: CGFloat = 0
        let segmentWidth = focused ? CGFloat(focusedThumbnailWidth!) : CGFloat(unfocusedThumbnailWidth!)
        let segmentHeight = focused ? CGFloat(focusedCellHeight!) : CGFloat(unfocusedCellHeight!)
        fullWidth = CGFloat(segmentWidth) * CGFloat(images.count)
        
        let boundForBetter = CGRect(x: 0, y: 0, width: fullWidth, height: segmentHeight)
        
        UIGraphicsBeginImageContext(boundForBetter.size)
        let context = UIGraphicsGetCurrentContext()
        
        for (index, _) in images.enumerated() {
            
            var imageX:CGFloat = 0
            for _ in 0..<index {
                imageX += segmentWidth
            }
            let rect = CGRect(x: imageX, y: 0, width: segmentWidth, height: segmentHeight)
            context!.draw(images[index].image.cgImage!, in: rect)
            
        }
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let resultImageimage = UIImage(cgImage: imageResize(imageObj: combinedImage!, sizeChange:CGSize(width: fullWidth, height: segmentHeight)).cgImage!, scale: 1.0, orientation: .downMirrored)
        
        return resultImageimage
    }
    
    func imageResize(imageObj:UIImage, sizeChange:CGSize)-> UIImage {
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext() // !!!
        return scaledImage!
    }
}

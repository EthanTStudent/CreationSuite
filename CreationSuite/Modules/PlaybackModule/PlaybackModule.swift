import Foundation
import UIKit
import AVFoundation

class PlaybackModule: UIView {
    
    var creationController: CreationSuiteController?
    var model: DataModel?
    
    public var currentAsset: AVAsset? {
        didSet {
            if self.currentAsset != nil {
                self.setUpPlayerItem(asset: self.currentAsset!)
            } else {
                self.pausePlayer()
            }
        }
    }
    
    var player: AVQueuePlayer
    
    init(controller: CreationSuiteController, dataModel: DataModel, frame: CGRect) {
        player = AVQueuePlayer()
        super.init(frame: frame)
        player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 24), queue: DispatchQueue.main, using: {  (progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)
//            print(seconds)
            let percentage = CGFloat(seconds) / self.model!.videoClipAttributes[self.model!.focusedIndex].clipLengthInSeconds!
            self.model!.operations!.playerTimeHasUpdated(percent: percentage)
        })
        creationController = controller
        model = dataModel
        backgroundColor = .purple
        
        model!.playbackModule = self
        
        playerLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name:
        NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    var playerLayer = AVPlayerLayer()

    
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    private var playerItemContext = 0
    private var playerItem: AVPlayerItem?
    
    func setUpPlayerItem(asset: AVAsset) {
        self.playerItem = AVPlayerItem(asset: asset)
//        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
        
        
//        DispatchQueue.main.async {
            self.playerLayer.player = self.player
            self.playerLayer.masksToBounds = true
            self.playerLayer.cornerRadius = 30
//            self.playerLooper = AVPlayerLooper(player: self.player, templateItem: self.playerItem!)
            self.player.insert(self.playerItem!, after: nil)
//        }
    }
    
    func pausePlayer() {
        self.player.pause()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
    }
    
    @objc func videoDidEnd(notification: NSNotification) {
        print("notifying")
        model!.operations!.reachedEndOfClip()
    }
    
}

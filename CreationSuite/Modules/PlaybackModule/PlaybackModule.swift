import Foundation
import UIKit
import AVFoundation

class PlaybackModule: UIView {
    
    var model: DataModel?
    var playerLayer = AVPlayerLayer()
    var player: AVQueuePlayer

    public var currentAsset: AVAsset? {
        didSet {
            if self.currentAsset != nil {
                self.setUpPlayerItem(asset: self.currentAsset!)
            } else {
                self.pausePlayer()
            }
        }
    }
    
    init(dataModel: DataModel, frame: CGRect) {
        model = dataModel
        player = AVQueuePlayer()
        
        super.init(frame: frame)

        player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 24), queue: DispatchQueue.main, using: {  (progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)
//            print(seconds)
            let percentage = CGFloat(seconds) / self.model!.videoClipAttributes[self.model!.focusedIndex].clipLengthInSeconds!
            self.model!.operations!.playerTimeHasUpdated(percent: percentage)
        })
                        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name:
        NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        model!.playbackModule = self
        
        backgroundColor = .purple
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if frame != .zero {
            playerLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            self.layer.addSublayer(playerLayer)
        }
    }
    
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    private var playerItemContext = 0
    private var playerItem: AVPlayerItem?
    
    func setUpPlayerItem(asset: AVAsset) {
        self.playerItem = AVPlayerItem(asset: asset)
        self.playerLayer.player = self.player
        self.playerLayer.masksToBounds = true
        self.playerLayer.cornerRadius = 30
        self.playerLayer.backgroundColor = CGColor(red: 0, green: 100, blue: 100, alpha: 1)
        self.player.insert(self.playerItem!, after: nil)
    }
    
    func pausePlayer() {
        self.player.pause()
    }
    
    deinit {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
    }
    
    @objc func videoDidEnd(notification: NSNotification) {
        print("notifying")
        model!.operations!.reachedEndOfClip()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

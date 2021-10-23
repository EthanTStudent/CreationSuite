import Foundation
import UIKit

class CreationSuiteController: UIView {
    
    var dataModel: DataModel?
//    let recordingModule: RecordingModule
    var editingOverlay: EditingOverlay?
    var playbackModule: PlaybackModule?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemTeal
        dataModel = DataModel(controller: self)
//        recordingModule = RecordingModule(controller: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func videosLoaded() {
        DispatchQueue.main.async {
            self.playbackModule = PlaybackModule(controller: self, dataModel: self.dataModel!, frame: UIScreen.main.bounds)
            self.addSubview(self.playbackModule!)
            self.editingOverlay = EditingOverlay(controller: self, dataModel: self.dataModel!, frame: self.frame)
            self.addSubview(self.editingOverlay!)
        }
    }
}

import Foundation
import UIKit

class CreationSuiteController: UIView {
    
    var dataModel: DataModel?
//    let recordingModule: RecordingModule
    var editingOverlay: EditingOverlay?
    var playbackModule: PlaybackModule?
    var recordingModule: RecordingModule?
    
    let recordingButtonRadius = CGFloat(30);
    
    var recordingButton: RecordButton?
    
    var modeSwitch: ModeSwitch?
    
    var isRecording: Bool = false {
        didSet {
            if isRecording {
                editLabel.isHidden = true
                recordLabel.isHidden = true
                modeSwitch!.isHidden = true
            } else {
                editLabel.isHidden = false
                recordLabel.isHidden = false
                modeSwitch!.isHidden = false
            }
        }
    }
    
    enum Mode {
        case record, edit
    }
    
    var currMode: Mode? = nil {
        didSet {
            if currMode == .edit {
                self.playbackModule!.isHidden = false
                self.editingOverlay!.isHidden = false
                
                self.recordingModule!.isHidden = true
                self.recordingButton!.isHidden = true
                
                self.editLabel.textColor = .systemGreen
                self.recordLabel.textColor = .white
                                
            } else {
                self.playbackModule!.isHidden = true
                self.editingOverlay!.isHidden = true
                
                self.recordingModule!.isHidden = false
                self.recordingButton!.isHidden = false
                
                self.recordLabel.textColor = .systemGreen
                self.editLabel.textColor = .white
                
            }
        }
    }
    
    let editLabel = UILabel()
    
    let recordLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemTeal
        dataModel = DataModel(controller: self)
        modeSwitch = ModeSwitch(controller: self, frame: .zero, onRecord: true)
        modeSwitch!.translatesAutoresizingMaskIntoConstraints = false
        
        editLabel.text = "Edit"
        editLabel.frame = .zero
        editLabel.translatesAutoresizingMaskIntoConstraints = false
        
        recordLabel.text = "Record"
        recordLabel.frame = .zero
        recordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        recordingButton = RecordButton(frame: .zero, radius: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sendSwitchRequest(onRecord: Bool) {
        if currMode == .record && onRecord == false || currMode == .edit && onRecord == true {
            switchMode()
        }
    }
    
    func switchMode() {
        currMode = currMode == .record ? .edit : .record
    }
    
    func videosLoaded() {
        DispatchQueue.main.async {
            
//            self.modeButton = UIButton()
//            self.modeButton!.backgroundColor = .red
//            self.modeButton!.addTarget(self, action: #selector(self.switchMode), for: .touchUpInside)
//            self.modeButton!.translatesAutoresizingMaskIntoConstraints = false

            self.editingOverlay = EditingOverlay(controller: self, dataModel: self.dataModel!, frame: self.frame)
            self.addSubview(self.editingOverlay!)
            
            self.playbackModule = PlaybackModule(dataModel: self.dataModel!, frame: .zero)
            self.playbackModule!.translatesAutoresizingMaskIntoConstraints = false
            
            self.recordingModule = RecordingModule(dataModel: self.dataModel!, frame: .zero)
            self.recordingModule!.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(self.playbackModule!)
            self.addSubview(self.recordingModule!)
            
            self.addSubview(self.modeSwitch!)
            
            self.addSubview(self.editLabel)
            self.addSubview(self.recordLabel)
            
            self.addSubview(self.recordingButton!)
            self.recordingButton!.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                self.playbackModule!.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
                self.playbackModule!.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
                self.playbackModule!.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3),
                self.playbackModule!.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
                self.playbackModule!.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10),
                
                self.recordingModule!.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
                self.recordingModule!.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
                self.recordingModule!.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3),
                self.recordingModule!.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
                self.recordingModule!.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10),
                
                self.modeSwitch!.leftAnchor.constraint(equalTo: self.rightAnchor, constant: -140),
                self.modeSwitch!.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -80),
                self.modeSwitch!.topAnchor.constraint(equalTo: self.topAnchor, constant: 80),
                self.modeSwitch!.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 105),

                self.editLabel.rightAnchor.constraint(equalTo: self.modeSwitch!.leftAnchor, constant: -5),
                self.editLabel.leftAnchor.constraint(equalTo: self.modeSwitch!.leftAnchor, constant: -self.editLabel.intrinsicContentSize.width - 5),
                self.editLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 80),
                self.editLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 105),
                
                self.recordLabel.rightAnchor.constraint(equalTo: self.modeSwitch!.rightAnchor, constant: self.recordLabel.intrinsicContentSize.width + 5),
                self.recordLabel.leftAnchor.constraint(equalTo: self.modeSwitch!.rightAnchor, constant: 5),
                self.recordLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 80),
                self.recordLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 105),
                
                self.recordingButton!.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -150 - self.recordingButtonRadius*2),
                self.recordingButton!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -150),
                self.recordingButton!.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: -self.recordingButtonRadius),
                self.recordingButton!.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: self.recordingButtonRadius),
                self.recordingButton!.widthAnchor.constraint(equalToConstant: 50),
                self.recordingButton!.heightAnchor.constraint(equalToConstant: 50)
            ])
        
            self.currMode = .record
            self.recordingButton!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.switchButtonState)))
            
        }
    }
    
    @objc private func switchButtonState(_ sender: UITapGestureRecognizer) {
        print("before state: \(recordingButton!.currentState)")
        isRecording = !isRecording ? true : false
        recordingButton!.currentState = recordingButton!.currentState == .record ? .stop : .record
        print("after state: \(recordingButton!.currentState)")
    }
    
    func displayIngredientsModal(oldIngredient: IngredientModel?, index: Int?) {
        let popup = IngredientModal(frame: frame, dataModel: dataModel!, oldIngredient: oldIngredient, index: index) 
        addSubview(popup)
    }
    
    func displayDeleteClipModal() {
        let popup = DeleteClipModal(frame: frame, dataModel: dataModel!)
        addSubview(popup)
    }
}

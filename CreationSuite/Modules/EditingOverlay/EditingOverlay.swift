import Foundation
import UIKit

class EditingOverlay: UIView {
    
    let verticalPosition: CGFloat = 750
    
    let creationController: CreationSuiteController
    let model: DataModel
    let carousel: CollectionView
    let playhead: PlayheadIndicator
    
    var mySlider: UISlider
    
    var operations: EditingOverlayOperations?
    var manager: EditingOverlayManager?
    
    var playPauseButton: UIButton
    var playbackMethodButton: UIButton
    
    var addIngredientButton: UIButton
    
    init(controller: CreationSuiteController, dataModel: DataModel, frame: CGRect){
        creationController = controller
        model = dataModel
        carousel = CollectionView(model: dataModel, yCenter: verticalPosition)
        playhead = PlayheadIndicator(frame: frame, yCenter: verticalPosition)
        mySlider = UISlider(frame:CGRect(x: 10, y: 60, width: 300, height: 50))
        playPauseButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        playbackMethodButton = UIButton(frame: CGRect(x: 100, y: 170, width: 100, height: 50))
        addIngredientButton = UIButton(frame: CGRect(x: 100, y: 256, width: 150, height: 40))


        //buttons =
        
        print("initi")
        super.init(frame: frame)         
        operations = EditingOverlayOperations(module: self)
        manager = EditingOverlayManager(module: self)
    }
    
    required init(coder: NSCoder) {
        fatalError("failed")
    }
    
    override func layoutSubviews() {
        self.addSubview(carousel)
        self.addSubview(playhead)
        self.addSubview(playPauseButton)
        self.addSubview(playbackMethodButton)
        self.addSubview(addIngredientButton)

        playPauseButton.backgroundColor = .green
        playPauseButton.setTitle("Play", for: .normal)
        playPauseButton.addTarget(self, action: #selector(playPauseButtonAction), for: .touchUpInside)
        
        playbackMethodButton.backgroundColor = .black
        playbackMethodButton.setTitle("None", for: .normal)
        playbackMethodButton.addTarget(self, action: #selector(playbackMethodButtonAction), for: .touchUpInside)
        
        addIngredientButton.backgroundColor = .systemOrange
        addIngredientButton.setTitle("Add Ingredient", for: .normal)
        addIngredientButton.addTarget(self, action: #selector(addIngredientButtonAction), for: .touchUpInside)
      
//        self.addSubview(mySlider)
//        mySlider.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
//        mySlider.minimumValue = 0.3
//        mySlider.maximumValue = 2.5
//        mySlider.isContinuous = true
//        mySlider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
        
//        UIView.animate(withDuration: 1) {
//            self.mySlider.setValue(80.0, animated: true)
//        }
    }
    
    @objc func playPauseButtonAction(sender: UIButton!) {
      print("Button tapped")
        model.operations!.switchIsPlaying()
    }
    
    @objc func playbackMethodButtonAction(sender: UIButton!) {
      print("Button tapped")
        model.operations!.switchPlaybackMethod()
    }
    
    @objc func addIngredientButtonAction(sender: UIButton!) {
      print("Button tapped")
        model.operations!.addIngredient() 
    }
    
    @objc func sliderValueDidChange(_ sender: UISlider!)
      {
        model.operations!.adjustWidthUnitScale(newScaleValue: CGFloat(sender.value))
      }
}

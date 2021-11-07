import Foundation
import UIKit

class RecordButtonShape: CAShapeLayer {
    
    let squarePath = UIBezierPath()

    let circlePath = UIBezierPath()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(radius: CGFloat){
        
        super.init()
        circlePath.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: -CGFloat(Double.pi), endAngle: -CGFloat(Double.pi/2), clockwise: true)
        circlePath.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: -CGFloat(Double.pi/2), endAngle: 0, clockwise: true)
        circlePath.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi/2), clockwise: true)
        circlePath.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi), clockwise: true)
        circlePath.close()
        
        let center = CGFloat(radius)
        let startX = center - radius / 2
        let startY = center - radius / 2
        squarePath.move(to: CGPoint(x: startX, y: startY))
        squarePath.addLine(to: squarePath.currentPoint)
        squarePath.addLine(to: CGPoint(x: startX + radius, y: startY))
        squarePath.addLine(to: squarePath.currentPoint)
        squarePath.addLine(to: CGPoint(x: startX + radius, y: startY + radius))
        squarePath.addLine(to: squarePath.currentPoint)
        squarePath.addLine(to: CGPoint(x: startX, y: startY + radius))
        squarePath.addLine(to: squarePath.currentPoint)
        squarePath.close()

        path = circlePath.cgPath
        
        fillColor = UIColor.red.cgColor
        strokeColor = UIColor.black.cgColor
        lineWidth = 2
    }
}

class RecordButton: UIView {
    
    let button: RecordButtonShape
    
    init(frame: CGRect, radius: CGFloat) {
        button = RecordButtonShape(radius: radius)
        super.init(frame: frame)
        layer.addSublayer(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum ButtonState {
        case record, stop
    }
    
    var currentStateJustPrevious: ButtonState?
    
    var currentState: ButtonState = .record {
        didSet {
            switch currentState {
            
            case .record:
                let animation = CABasicAnimation(keyPath: "path")
                animation.toValue = button.squarePath
                animation.duration = 0.15
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                animation.fillMode = CAMediaTimingFillMode.both
                animation.repeatCount = 1 // Infinite repeat
                animation.autoreverses = false
                animation.isRemovedOnCompletion = false
                
                button.path = button.circlePath.cgPath
                
                button.removeAllAnimations()
                button.add(animation, forKey: animation.keyPath)
                currentStateJustPrevious = .record
                
            case .stop:
                let animation = CABasicAnimation(keyPath: "path")
                animation.toValue = button.circlePath
                animation.duration = 0.15
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                animation.fillMode = CAMediaTimingFillMode.both
                animation.repeatCount = 1 // Infinite repeat
                animation.autoreverses = false
                animation.isRemovedOnCompletion = false
                
                button.path = button.squarePath.cgPath
                
                button.removeAllAnimations()
                button.add(animation, forKey: animation.keyPath)
                currentStateJustPrevious = .stop
            }
        }
    }
}

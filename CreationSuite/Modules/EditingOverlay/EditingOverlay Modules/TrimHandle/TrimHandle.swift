import Foundation
import UIKit

class TrimHandle: UIView {
    var handle: CAShapeLayer?

    init(frame: CGRect, isLeft: Bool) {
        super.init(frame: frame)
        handle = self.createTrimHandleLayer(isLeft: isLeft)
//        self.layer.addSublayer(handle!)
//        backgroundColor = .white
    }
    
    let activeColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
    let inactiveColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func createTrimHandleLayer(isLeft: Bool) -> CAShapeLayer {
        let rectWidth = CGFloat(20)
        let rectHeight = CGFloat(130)

        let rect = CGRect(x: 0, y: 0, width: rectWidth, height: rectHeight)
        let path: CGPath = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(6)).cgPath
        
        let trimHandleShapeLayer = CAShapeLayer()
        trimHandleShapeLayer.path = path
        trimHandleShapeLayer.fillColor = inactiveColor

        return trimHandleShapeLayer
    }
}

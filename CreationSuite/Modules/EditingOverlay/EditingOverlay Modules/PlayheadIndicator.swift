//
//  PlayheadIndicator.swift
//  Station Screen Test
//
//  Created by Ethan Treiman on 10/7/21.
//

import UIKit

class PlayheadIndicator: UIView {
    
    let rectWidth = CGFloat(2)
    let rectHeight = CGFloat(140)
    
    init(frame: CGRect, yCenter: CGFloat) {
        super.init(frame: frame)
        self.frame = CGRect(x: UIScreen.main.bounds.width / 2, y: yCenter - (rectHeight / 2), width: rectWidth, height: rectHeight)
        let playheadIndicator = self.createPlayheadIndicatorLayer()
        self.layer.addSublayer(playheadIndicator)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func createPlayheadIndicatorLayer() -> CAShapeLayer {

        let xf:CGFloat = (self.frame.width  - rectWidth)  / 2
        let yf:CGFloat = (self.frame.height - rectHeight) / 2

        
        let rect = CGRect(x: xf, y: yf, width: rectWidth, height: rectHeight)
        let path: CGPath = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(6)).cgPath
        
        let playheadIndicatorShapeLayer = CAShapeLayer()
        playheadIndicatorShapeLayer.path = path
        playheadIndicatorShapeLayer.fillColor = CGColor(red: 255, green: 255, blue: 0, alpha: 1.0)

        return playheadIndicatorShapeLayer
    }
}

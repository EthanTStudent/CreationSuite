//
//  IngredientsModal.swift
//  CreationSuite
//
//  Created by Ethan Treiman on 10/29/21.
//

import Foundation
import UIKit

class DeleteClipModal: UIView {
    
    let model: DataModel
    
    // MARK: - Buttons
    
    fileprivate let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(closeModalWithoutDeleteClip), for: .touchUpInside)
        return button
    }()
    
    fileprivate let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(closeModalWithDeleteClip), for: .touchUpInside)
        return button
    }()
    
    fileprivate let container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .yellow
        v.layer.cornerRadius = 24
        return v
    }()
    
    // MARK: - Operations
    
    @objc fileprivate func closeModalWithDeleteClip() {
        model.operations!.deleteClip()
        animateOut()
    }
    
    @objc fileprivate func closeModalWithoutDeleteClip() {
        animateOut()
    }
    
    
    @objc fileprivate func animateOut() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.alpha = 0
        }) { (complete) in
            if complete {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc fileprivate func animateIn() {
        self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        self.alpha = 1
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, dataModel: DataModel) {
        model = dataModel
        super.init(frame: frame)

        self.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        self.frame = UIScreen.main.bounds
        self.addSubview(container)

        container.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45).isActive = true
        
        container.addSubview(cancelButton)
        cancelButton.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 50).isActive = true
        
        container.addSubview(deleteButton)
        deleteButton.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        deleteButton.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true

        animateIn()
    }
}

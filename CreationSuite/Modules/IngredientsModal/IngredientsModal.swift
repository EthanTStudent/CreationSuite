//
//  IngredientsModal.swift
//  CreationSuite
//
//  Created by Ethan Treiman on 10/29/21.
//

import Foundation
import UIKit

class IngredientModal: UIView {
    
    let model: DataModel
    
    var isEditingIngredient: Bool = false
    var currentIngredientIndex: Int?
    
    // MARK: - Buttons
        
    fileprivate let addButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(closeModalWithIngredient), for: .touchUpInside)
        return button
    }()
    
    fileprivate let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(closeModalWithoutIngredient), for: .touchUpInside)
        return button
    }()
    
    fileprivate let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete", for: .normal)
        button.addTarget(self, action: #selector(closeModalDeleteIngredient), for: .touchUpInside)
        return button
    }()
    
    fileprivate let container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .purple
        v.layer.cornerRadius = 24
        return v
    }()
    
    
    // MARK: - Text Fields
    
    func createIngredientField() -> UITextField {
        let ingredient =  UITextField(frame: .zero)
        ingredient.translatesAutoresizingMaskIntoConstraints = false
        ingredient.placeholder = "Enter Ingredient"
        ingredient.font = UIFont.systemFont(ofSize: 15)
        ingredient.borderStyle = UITextField.BorderStyle.roundedRect
        ingredient.autocorrectionType = UITextAutocorrectionType.no
        ingredient.keyboardType = UIKeyboardType.default
        ingredient.returnKeyType = UIReturnKeyType.done
        ingredient.clearButtonMode = UITextField.ViewMode.whileEditing
        ingredient.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return ingredient
    }
    
    func createUnitField() -> UITextField {
        let unit =  UITextField(frame: .zero)
        unit.translatesAutoresizingMaskIntoConstraints = false
        unit.placeholder = "Enter Unit"
        unit.font = UIFont.systemFont(ofSize: 15)
        unit.borderStyle = UITextField.BorderStyle.roundedRect
        unit.autocorrectionType = UITextAutocorrectionType.no
        unit.keyboardType = UIKeyboardType.default
        unit.returnKeyType = UIReturnKeyType.done
        unit.clearButtonMode = UITextField.ViewMode.whileEditing
        unit.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return unit
    }
    
    func createQuantityField() -> UITextField {
        let quantity =  UITextField(frame: .zero)
        quantity.translatesAutoresizingMaskIntoConstraints = false
        quantity.placeholder = "Enter Quantity"
        quantity.font = UIFont.systemFont(ofSize: 15)
        quantity.borderStyle = UITextField.BorderStyle.roundedRect
        quantity.autocorrectionType = UITextAutocorrectionType.no
        quantity.keyboardType = UIKeyboardType.default
        quantity.returnKeyType = UIReturnKeyType.done
        quantity.clearButtonMode = UITextField.ViewMode.whileEditing
        quantity.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return quantity
    }
    
    
    // MARK: - Operations
    
    @objc fileprivate func closeModalWithIngredient() {
        model.operations!.addIngredient()
        animateOut()
    }
    
    @objc fileprivate func closeModalWithoutIngredient() {
        animateOut()
    }
    
    @objc fileprivate func closeModalDeleteIngredient() {
        model.operations!.deleteEvent(eventIndexInCell: currentIngredientIndex!)
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
    
    init(frame: CGRect, dataModel: DataModel, oldIngredient: IngredientModel?, index: Int?) {
        model = dataModel
        super.init(frame: frame)
        
        if oldIngredient != nil {
            isEditingIngredient = true
            currentIngredientIndex = index
        }

        self.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        self.frame = UIScreen.main.bounds
        self.addSubview(container)

        container.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45).isActive = true

        //                container.addSubview(stack)
        //                stack.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        //                stack.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        //                stack.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true

        container.addSubview(addButton)
        addButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        addButton.centerYAnchor.constraint(equalTo: container.bottomAnchor, constant: -20).isActive = true
        
        container.addSubview(cancelButton)
        addButton.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        addButton.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 50).isActive = true
        
        container.addSubview(deleteButton)
        addButton.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        addButton.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        let ingredientInputField = createIngredientField()
        let unitInputField = createUnitField()
        let quantityInputField = createQuantityField()
        
        container.addSubview(ingredientInputField)
        ingredientInputField.delegate = self
        ingredientInputField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        ingredientInputField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        ingredientInputField.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        ingredientInputField.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        container.addSubview(unitInputField)
        unitInputField.delegate = self
        unitInputField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        unitInputField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        unitInputField.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        unitInputField.topAnchor.constraint(equalTo: ingredientInputField.bottomAnchor, constant: 10).isActive = true
        
        container.addSubview(quantityInputField)
        quantityInputField.delegate = self
        quantityInputField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        quantityInputField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        quantityInputField.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        quantityInputField.topAnchor.constraint(equalTo: unitInputField.bottomAnchor, constant: 10).isActive = true

        addButton.isHidden = isEditingIngredient ? true : false
        deleteButton.isHidden = isEditingIngredient ? false : true
        cancelButton.isHidden = isEditingIngredient ? true : false
        
        animateIn()
    }
}

extension IngredientModal: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        print("TextField should begin editing method called")
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called")
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        print("TextField should snd editing method called")
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        print("TextField did end editing method called")
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        print("While entering the characters this method gets called")
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
        print("TextField should clear method called")
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
        // may be useful: textField.resignFirstResponder()
        return true
    }
}

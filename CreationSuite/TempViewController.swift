//
//  TempViewController.swift
//  CreationSuite
//
//  Created by Ethan Treiman on 10/17/21.
//

import Foundation
import UIKit

class TempViewController: UIViewController {
    
    let mainView = CreationSuiteController(frame: UIScreen.main.bounds) 
    
    override func viewDidLoad() {
        view.addSubview(mainView)
        view.backgroundColor = .red
    }
}

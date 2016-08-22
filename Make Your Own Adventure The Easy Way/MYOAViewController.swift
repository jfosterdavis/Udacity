//
//  MYOAViewController.swift
//  Make Your Own Adventure The Easy Way
//
//  Created by Jacob Foster Davis on 8/21/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

class MYOAViewController: UIViewController {

    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start Over", style: .Plain, target: self, action: "startOver")
    }
    
    func startOver(){
        if let navigationController = self.navigationController {
            navigationController.popToRootViewControllerAnimated(true)
        }
    }
}
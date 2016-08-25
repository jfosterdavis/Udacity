//
//  UIImagePickerController+SupportedOrientations.swift
//  MemeMe
//
//  Created by Jacob Foster Davis on 8/25/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit
//got this code from
//http://stackoverflow.com/questions/33058691/use-uiimagepickercontroller-in-landscape-mode-in-swift-2-0

extension UIImagePickerController
{
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [.Landscape, .Portrait]
    }
}

//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Jacob Foster Davis on 8/24/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //hide the tab bar to see more of the meme
        self.tabBarController?.tabBar.hidden = true
        
        //set the image
        self.imageView!.image = meme.memedImage
    }
    
    override func viewWillDisappear(animated:Bool){
        super.viewWillDisappear(animated)
        
        //show the tab bar
        self.tabBarController?.tabBar.hidden = false
    }
    
}
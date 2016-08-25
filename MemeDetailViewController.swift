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
    //indexPath is a way for the detailViewController to know where this meme belongs in the shared model
    var indexPath: NSIndexPath!
    
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
    
    //Allows user to send the current meme to the meme editor
    @IBAction func sendThisMemeToMemeEditorViewController(){
        let editorController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        //set the editors meme and index for the shared model
        editorController.memeToEdit = self.meme
        editorController.indexPath = self.indexPath
        //tell the editor that this will be an editing session
        editorController.isEditMode = true
        print("about to send a meme to the editor for meme at indexPath: ",indexPath.row)
        //present modally
        self.presentViewController(editorController, animated: true, completion: nil)
    }
    
}
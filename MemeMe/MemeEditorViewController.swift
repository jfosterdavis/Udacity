////
////  MemeEditorViewController.swift
////  MemeMe
////
////  Created by Jacob Foster Davis on 8/24/16.
////  Copyright © 2016 Zero Mu, LLC. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//
////The MemeEditorViewController has the same functionality as the MemViewController, except that 
////  saving overwrites the current meme
////  the current meme is loaded into the Controller upon loading
//
////This subclassing attempt didn't work, so this file serves no purpose other than to remember what I tried to do once.  Will integrate these features into the MemeViewController
//class MemeEditorViewController: MemeViewController {
//    
//    var memeToEdit: Meme!
//    //indexPath tells the editor where this meme belongs in the shared model
//    var indexPath: NSIndexPath!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//    }
//    
//    override func viewWillAppear(animated: Bool){
//        super.viewWillAppear(animated)
//        
//        //load the memeToEdit.  memeToEdit shoud have been set when this view controller was instantiated.
//        self.topTextField.text = memeToEdit.topText as String
//        self.bottomTextField.text = memeToEdit.bottomText as String
//        self.imagePickerView.image = memeToEdit.image
//    }
//    
//    override func save(useThisImage: UIImage?=nil) {
//        //get the appDelegate
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        //get a count of the currentnumber of memes.  This should not change by the end of this function
//        print("MemeEditorViewController save() was called.  There are ", String(appDelegate.sharedMemes.count), " shared Memes")
//        //initialize the image we will save as the meme
//        var memedImage: UIImage
//        
//        //check to see if useThisImage was given by caller
//        if let unwrappedImage = useThisImage {
//            //you already have an image so no need to generate again
//            memedImage = unwrappedImage
//        } else {
//            //create the meme from text and image
//            memedImage = generateMemedImage()
//        }
//        
//        //create a Meme object
//        let meme = Meme( topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: memedImage)
//        
//        //set this object's meme
//        currentMeme = meme
//        
//        //now save this meme to the shared memes in the AppDelegate
//        appDelegate.sharedMemes.append(meme)
//        
//        print("End of MemeEditorViewController save(). There are ", String(appDelegate.sharedMemes.count), " shared Memes")
//        
//    }
//    
//}
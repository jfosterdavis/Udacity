//
//  ViewController.swift
//  ImagePickerExperiment
//
//  Created by Jacob Foster Davis on 6/20/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("imagePickerController was called")
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            print("an image was passed to ViewController")
            imagePickerView.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        print("imagePickerControllerDidCancel was called")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        //specify that this will look in the photolibrary
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        //specify that the picture will come from the camera
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
}


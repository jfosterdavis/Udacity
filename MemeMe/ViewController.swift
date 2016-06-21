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
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    @IBOutlet weak var theTopBar: UIToolbar!
    @IBOutlet weak var theNavBar: UIToolbar!
    
    var theMeme: Meme!
    
    //Delegate Objects
    let textFieldDelegate = MemeTextFieldDelegate()
    
    //set the text field attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -4.0,
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //set the delegates
        self.topTextField.delegate = textFieldDelegate
        self.bottomTextField.delegate = textFieldDelegate
        
        //set the text field attributes
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        resetTextFields()
        
        //center text
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        //set up buttons
        setButtonsEnabled(false)
        
        

    }
    
    func resetTextFields(){
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        //subscribe to keyboard notifications
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as!NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //user did pick an image
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("imagePickerController was called")
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            print("an image was passed to ViewController")
            imagePickerView.image = image
            //ensure the buttons are enabled
            setButtonsEnabled(true)
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    //user canceled the pick operation
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        print("user canceled the image picking")
        //ensure the buttons are still grayed out, if the image is blank
        if imagePickerView.image == nil{
            setButtonsEnabled(false)
            
        }
        
        
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
    

    @IBAction func saveAndSend(sender: AnyObject) {
        save()
        
        let controller = UIActivityViewController(activityItems: [theMeme.memedImage], applicationActivities: nil)
        //set this controller to save the image if user doesn't press cancel
        controller.completionWithItemsHandler = {
            (activityType: String?, completed: Bool, returnedItems: [AnyObject]?, error: NSError?) ->Void in
            
                // only save the image ifthe user didn't press cancel.
                if (completed){
                    UIImageWriteToSavedPhotosAlbum(self.theMeme.memedImage, nil, nil, nil);
                } else {
                    //user pressed cancel
                }
            }
        
        self.presentViewController(controller, animated: true, completion: nil)
        
        //now send the meme
    }

    
    func save() {
        //create the meme from text and image
        let memedImage = generateMemedImage()
        
        let meme = Meme( topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: memedImage)
        
        theMeme = meme
        
        //print(meme)
        
    }
    
    @IBAction func cancel(sender: AnyObject){
        //clear the image and text
        imagePickerView.image = nil
        
        //reset text
        resetTextFields()
        
        //reset buttons
        setButtonsEnabled(false)
    }
    
    @IBAction func saveToPhotosAlbum(sender: AnyObject) {
        save()
        
        UIImageWriteToSavedPhotosAlbum(theMeme.memedImage, nil, nil, nil);
    }
    
    struct Meme {
        var topText: NSString
        var bottomText: NSString
        var image: UIImage
        var memedImage: UIImage
    }
    
    func generateMemedImage() -> UIImage {
        //hide toolbars navbars
        setBarsVisible(true)
        
        //render the image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //show toolbars navbars
        setBarsVisible(false)
        return memedImage
    }
    
    func setButtonsEnabled(state: Bool){
        self.saveButton.enabled = state
        self.shareButton.enabled = state
    }
    
    func setBarsVisible(state: Bool){
        self.theNavBar.hidden = state
        self.theTopBar.hidden = state
    }
    
}


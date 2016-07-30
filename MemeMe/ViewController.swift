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
    
    

    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var navBar: UIToolbar!
    
    
    var currentMeme: Meme!
    //this comment added to commit
    //Delegate Objects
    let textFieldDelegate = MemeTextFieldDelegate()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //set the delegates
        self.topTextField.delegate = textFieldDelegate
        self.bottomTextField.delegate = textFieldDelegate
        
        //set up the text fields
        resetTextFields()
        
        //center text
        //I was told this is redundant in my last Udacity Review, but I can't figure out how to set the alignment using the .defaultTextAttributes
        //topTextField.textAlignment = NSTextAlignment.Center
        //bottomTextField.textAlignment = NSTextAlignment.Center
        
        //set up buttons
        setButtonsEnabled(false)
        
    }
    
    func resetTextFields(){
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        //set the text field attributes
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -4.0,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
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
        //check that the view is not already moved up for the keyboard.  if it isn't, then move the view
        if view.frame.origin.y == 0 {
            
            //check that the first responder is below the keyboard
            if let firstResponder = getFirstResponder() {
                if firstResponder.frame.origin.y >  getKeyboardHeight(notification) {
                    view.frame.origin.y = -(getKeyboardHeight(notification))
                }
            }
         
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getFirstResponder() -> UIView? {
        //this code adapted from http://stackoverflow.com/questions/12173802/trying-to-find-which-text-field-is-active-ios
        for view in self.view.subviews {
            if view.isFirstResponder() {
                return view
            }
        }
        //there is no first responder, return nil
        return nil
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
        
        pickAnImageFrom(sender, source: UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        pickAnImageFrom(sender, source: UIImagePickerControllerSourceType.Camera)
        
    }
    
    func pickAnImageFrom(sender: AnyObject, source: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        //specify that the picture will come from the camera
        pickerController.sourceType = source
        presentViewController(pickerController, animated: true, completion: nil)
    }

    @IBAction func saveAndSend(sender: AnyObject) {
        
        //generate the meme image
        let memedImage = generateMemedImage()
        
        //define instance of ActivityViewController and pass the memedImage as activity item
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        //set this controller to save the image if user doesn't press cancel
        controller.completionWithItemsHandler = {
            (activityType: String?, completed: Bool, returnedItems: [AnyObject]?, error: NSError?) ->Void in
            
                // only save the image if the user didn't press cancel.
                if completed {
                    //run the in-app save method
                    self.save()
                    
                    //UIImageWriteToSavedPhotosAlbum(self.currentMeme.memedImage, nil, nil, nil);
                } else {
                    //user pressed cancel
                    //do nothing because we assume the user knew that pressing cancel wouldn't save
                }
            }
        //present the Acvitity View Controller
        presentViewController(controller, animated: true, completion: nil)
        
        //now send the meme
    }

    
    func save(useThisImage: UIImage?=nil) {
        //initialize the image we will save as the meme
        var memedImage: UIImage
        
        //check to see if useThisImage was given by caller
        if let unwrappedImage = useThisImage {
            //you already have an image so no need to generate again
            memedImage = unwrappedImage
        } else {
            //create the meme from text and image
            memedImage = generateMemedImage()
        }
        
        
        let meme = Meme( topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: memedImage)
        
        currentMeme = meme
        
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
        
        UIImageWriteToSavedPhotosAlbum(currentMeme.memedImage, nil, nil, nil);
    }
    
    
    func generateMemedImage() -> UIImage {
        //hide toolbars navbars
        setBarsVisible(true)
        
        //render the image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //show toolbars navbars
        setBarsVisible(false)
        return memedImage
    }
    
    func setButtonsEnabled(state: Bool){
        saveButton.enabled = state
        shareButton.enabled = state
    }
    
    func setBarsVisible(state: Bool){
        navBar.hidden = state
        topBar.hidden = state
    }
    
}


//
//  MemeViewController.swift
//  MemeMe 2.0
//
//  Created by Jacob Foster Davis on 8/22/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //The image displayed
    @IBOutlet weak var imagePickerView: UIImageView!
    
    //buttons and bars
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var navBar: UIToolbar!
    
    //Text fields for user input
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!

    //The Meme object used within this class
    var currentMeme: Meme!
    
    //Delegate Objects
    let textFieldDelegate = MemeTextFieldDelegate()
    
    //objects needed for editing features
    var isEditSession: Bool = false //unless specified, will not edit a current meme
    var memeToEdit: Meme? //if this is an edit session, a meme should have been passed
    var indexPath: NSIndexPath? //if this is an edit session, should have been given an indexPath from the shared model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //set the delegates
        self.topTextField.delegate = textFieldDelegate
        self.bottomTextField.delegate = textFieldDelegate
        
        //set up the text fields
        resetTextFields()
        
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
        
        //if this is an edit session, then load up the view
        if isEditSession{
            if let unwrappedMemeToEdit = memeToEdit{
                //load the Meme
                self.topTextField.text = unwrappedMemeToEdit.topText as String
                self.bottomTextField.text = unwrappedMemeToEdit.bottomText as String
                self.imagePickerView.image = unwrappedMemeToEdit.image
            } else{
                print("Trying to edit but the meme isn't there")
            }
        }
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
        
        print("save() was called")
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
        
        //now save this meme to the shared memes in the AppDelegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.sharedMemes.append(meme)
        
        print("End of save(). There are ", String(appDelegate.sharedMemes.count), " shared Memes")
        
    }
    
    @IBAction func cancel(sender: AnyObject){
        //clear the image and text
        imagePickerView.image = nil
        
        //reset text
        resetTextFields()
        
        //reset buttons
        setButtonsEnabled(false)
        
        //dismiss to return to previous view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveToPhotosAlbum(sender: AnyObject) {
        save()
        
        //don't actually save this to the photos album for MemeMe2.0
        //UIImageWriteToSavedPhotosAlbum(currentMeme.memedImage, nil, nil, nil);
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


//
//  MemeTextFieldDelegates.swift
//  MemeMe
//
//  Created by Jacob Foster Davis on 6/21/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    private let MaxChars: Int = 50

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //textField.text is an unwrapped optional.
        if let text = textField.text {
            //This will only grab the text that contains the new user input. If the user deleted a character, it will simply not contain the last character that was entered.
            let newText = (text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            //if the text is too long, don't add.  Otherwise, return true to add the text
            if newText.characters.count > MaxChars {
                return false
            }
            else {
                return true
            }
            //textField.text = penniesToDollars(String(arr))
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if let text = textField.text {
            if text == "TOP" || text == "BOTTOM"{
                textField.text = ""
            
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
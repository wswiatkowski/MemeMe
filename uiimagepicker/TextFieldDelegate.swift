//
//  File.swift
//  uiimagepicker
//
//  Created by Świa on 26.05.2016.
//  Copyright © 2016 Cipis. All rights reserved.
//

import Foundation
import UIKit

class textFieldBottom : NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text! == "BOTTOM" {
            textField.text! = ""
        }else{
            textField.text! = textField.text!
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var newNum : NSString
        
        newNum = textField.text!
        newNum = newNum.stringByReplacingCharactersInRange(range, withString: string)
        return true
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}

class textFieldTop : NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text! == "TOP" {
            textField.text! = ""
        }else{
            textField.text! = textField.text!
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var newNum : NSString
        newNum = textField.text!
        newNum = newNum.stringByReplacingCharactersInRange(range, withString: string)
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
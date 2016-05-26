//
//  ViewController.swift
//  uiimagepicker
//
//  Created by Świa on 20.05.2016.
//  Copyright © 2016 Cipis. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var upperTextField: UITextField!
    @IBOutlet weak var lowerTextField: UITextField!
    @IBOutlet weak var lowerToolbar: UIToolbar!
    @IBOutlet weak var topToolbar: UIToolbar!
    
    struct Meme {
        
        let topText : String
        let bottomText : String
        let originalImage : UIImage
        let memedImage : UIImage
        
        
        init (topText: String, bottomText: String, originalImage : UIImage, memedImage: UIImage){
            self.topText = topText
            self.bottomText = bottomText
            self.originalImage = originalImage
            self.memedImage = memedImage
        }
    }
    
    var savedMeme : Meme!
    
    //Delegates
    let bottomTextFieldDelegate = textFieldBottom()
    let upperTextFieldDelegate = textFieldTop()
    
    //Text Attrs
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : 5.0
    ]
    
    @IBAction func pickAnImageFromAlbum (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareAction(sender: UIBarButtonItem) {
        
        func generateMemedImage() -> UIImage{
            
            self.topToolbar.hidden = true
            self.lowerToolbar.hidden = true

            
            UIGraphicsBeginImageContext(self.view.frame.size)
            self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
            let memedImage : UIImage =
                UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            self.topToolbar.hidden = false
            self.lowerToolbar.hidden = false
            
            return memedImage
        }
        
        let contextMemedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [contextMemedImage], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            print("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
            func save () {
                self.savedMeme = Meme (topText: self.upperTextField.text!, bottomText: self.lowerTextField.text!, originalImage: self.imageView.image!, memedImage: contextMemedImage)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }

    
    override func viewDidLoad() {
        upperTextField.delegate = bottomTextFieldDelegate
        upperTextField.text = "Top Text"
        upperTextField.textAlignment = NSTextAlignment(rawValue: 3)!
        upperTextField.defaultTextAttributes = memeTextAttributes
        
        lowerTextField.delegate = upperTextFieldDelegate
        lowerTextField.text = "Down Text"
        lowerTextField.textAlignment = NSTextAlignment(rawValue: 3)!
        lowerTextField.defaultTextAttributes = memeTextAttributes
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.unsubscribeFromKeyboardNotifications()
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        imageView.image = image
        dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as!NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification){
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification){
        self.view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)

    }
}


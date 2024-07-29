//
//  UITextField+Extension.swift
//  Asset_Task
//
// Created by Anasurya on 7/25/24.
//

import UIKit

@IBDesignable 
class CornerTextField: UITextField {

   @IBInspectable var placeHolderColor: UIColor? {
       get {
           return placeHolderColor
       }
       set {
           self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
       }
   }
   @IBInspectable var cornerRadius: CGFloat {
       get {
           return layer.cornerRadius
       }
       set {
           self.clipsToBounds = true
           layer.cornerRadius = newValue
       }
   }
   @IBInspectable
   var borderWidth: CGFloat {
       get {
           return layer.borderWidth
       }
       set {
           layer.borderWidth = newValue
       }
       
   }
   
   @IBInspectable
   var borderColor: UIColor? {
       get {
           if let color = layer.borderColor {
               return UIColor(cgColor: color)
           }
           return nil
       }
       set {
           if let color = newValue {
               layer.borderColor = color.cgColor
           } else {
               layer.borderColor = nil
           }
       }
   }
   
}

@IBDesignable class CardView: UIView{

   @IBInspectable var cornerRadius: CGFloat{
       get{
           return layer.cornerRadius
       }
       set{
           self.clipsToBounds = true
           layer.cornerRadius = newValue
       }
   }
   @IBInspectable
   var borderWidth: CGFloat {
       get {
           return layer.borderWidth
       }
       set {
           layer.borderWidth = newValue
       }
       
   }
   
   @IBInspectable
   var borderColor: UIColor? {
       get {
           if let color = layer.borderColor {
               return UIColor(cgColor: color)
           }
           return nil
       }
       set {
           if let color = newValue {
               layer.borderColor = color.cgColor
           } else {
               layer.borderColor = nil
           }
       }
   }
   
}

extension UITextField {
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone {
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}

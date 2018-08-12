//
//  RDAlertViewController.swift
//  Ridevert
//
//  Created by savaram, Ramakrishna on 24/07/2018.
//  Copyright © 2018 savaram, Ramakrishna. All rights reserved.
//

import UIKit

protocol AlertViewControllerDelegate {
    func SubmitAlertViewResult(textValue : String)
}

class RDAlertViewController {

    static let sharedInstance = RDAlertViewController()
    
    private init(){}
    
    var delegate : AlertViewControllerDelegate?
    
    func SubmitAlertView(viewController : UIViewController,title : String, message : String,isCancelBtn:Bool){
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        // Submit button
        let submitAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            self.delegate?.SubmitAlertViewResult(textValue: "")
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Resend", style: .destructive, handler: { (action) -> Void in
            self.delegate?.SubmitAlertViewResult(textValue: "Resend")
        })
        
        
        /*    // Add 1 textField and cutomize it
         alert.addTextField { (textField: UITextField) in
         textField.keyboardAppearance = .dark
         textField.keyboardType = .default
         textField.autocorrectionType = .default
         textField.placeholder = "enter any text value"
         textField.clearButtonMode = .whileEditing
         
         }
         */
        // Add action buttons and present the Alert
        alert.addAction(submitAction)
        if isCancelBtn {
            alert.addAction(cancel)
            
        }
        
        viewController.present(alert, animated: true, completion: nil)
        
}

}

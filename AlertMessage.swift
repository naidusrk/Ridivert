//
//  AlertMessage.swift
//  Ridevert
//
//  Created by savaram, Ramakrishna on 26/08/2018.
//  Copyright © 2018 savaram, Ramakrishna. All rights reserved.
//

import UIKit

class AlertMessage {

    
    
    internal static var alertMessageController:UIAlertController!
    
    internal static func disPlayAlertMessage(titleMessage:String, alertMsg:String){
        
        AlertMessage.alertMessageController = UIAlertController(title: titleMessage, message:
            alertMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        AlertMessage.alertMessageController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        if let controller = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController {
            controller.present(AlertMessage.alertMessageController, animated: true, completion: nil)
        }
        else{
            UIApplication.shared.delegate?.window!!.rootViewController?.present(AlertMessage.alertMessageController, animated: true, completion: nil)
        }
        
        return
        
    }
}

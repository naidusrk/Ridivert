//
//  RDTextFieldValidation.swift
//  Ridevert
//
//  Created by savaram, Ramakrishna on 24/07/2018.
//  Copyright © 2018 savaram, Ramakrishna. All rights reserved.
//



import UIKit



class RDTextFieldValidation: NSObject {
    static let sharedInstance : RDTextFieldValidation = {
        let instance = RDTextFieldValidation()
        return instance
    }()
    
    // MARK: - Initialization Method
    override init() {
        super.init()
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func validatePhone(phoneNumber: String) -> Bool {
        let emailRegEx = "^[0-9 ]+$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: phoneNumber)
    }
    
    //validate Password
    func isValidPassword(password: String) -> Bool{
        if(password.count<6 || password.count>16){
            return false
        }else{
            return true
        }
    }
    func isValidAuthCode(password: String) -> Bool{
        if(password.count != 3 || password.count != 4){
            return false
        }else{
            return true
        }
    }
    func isValidRedeemCode(password: String) -> Bool{
        if(password.count >= 4 && password.count <= 15){
            return true
        }else{
            return false
        }
    }
    func isValidCVV(password: String) -> Bool{
        if(password.count>4 || password.count>15){
            return false
        }else{
            return true
        }
    }
    
    func isValidName(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z ]+$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func isValidTranscationId(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func isValidDealId(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "^[a-z0-9\\!@#$%^&*()_+-=<>\\s]+$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidZipCode(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx =  "^[0-9 ]+$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let check = emailTest.evaluate(with: testStr)
        return check
    }
    
    func arrangeUSFormat(strPhone : String)-> String
    {
        var strUpdated = strPhone
        if strPhone.count == 10 {
            // strUpdated.insert("(", at: strUpdated.startIndex)
            strUpdated.insert("-", at: strUpdated.index(strUpdated.startIndex, offsetBy: 3))
            strUpdated.insert("-", at: strUpdated.index(strUpdated.startIndex, offsetBy: 7))
        }
        return strUpdated
    }
    
    //To check text field or String is blank or not
    func isEmptyString(value: String) ->Bool{
        let trimmed = value.trimmingCharacters(in: CharacterSet.whitespaces)
        let check = trimmed.isEmpty
        return check
    }
    
    //    func isAlphanumeric(password: String) ->Bool{
    //        return !password.isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    //    }
}

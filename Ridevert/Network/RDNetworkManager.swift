//
//  RDNetworkManager.swift
//  Ridevert
//
//  Created by savaram, Ramakrishna on 24/07/2018.
//  Copyright © 2018 savaram, Ramakrishna. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias completionHandlerBlock = (_ responce: Any?,_ error: Any?) -> Void
var isQueryString:Bool! = false
let appDelegate = UIApplication.shared.delegate as! AppDelegate
class RDNetworkManager: NSObject {
    static let sharedInstance : RDNetworkManager = {
        let instance = RDNetworkManager()
        return instance
    }()
    
    // MARK: - Initialization Method
    override init() {
        super.init()
    }
    
    func downloadImage(url:String,completion: @escaping completionHandlerBlock){
        
        // The image to dowload
        let remoteImageURL = URL(string: url)!
        // Use Alamofire to download the image
        Alamofire.request(remoteImageURL,
                          encoding:JSONEncoding.default).responseData { (response) in
                            if response.error == nil {
                                print(response.result)
                                // Show the downloaded image:
                                if let data = response.data {
                                    let img  = UIImage(data: data)
                                    completion(img,nil)
                                }
                            }
        }
        
    }
    func getRequest(url:String,methodName:HTTPMethod, parameters: [String:Any],headers: HTTPHeaders,completion: @escaping completionHandlerBlock){
        Alamofire.request(
            URL(string: url)!,
            method:methodName,
            headers:headers
            )
            .validate(statusCode: 200..<500)
            .responseJSON { (responseData) -> Void in
                if let json = responseData.result.value  {
                    completion(json, nil)
                }
                else if let error = responseData.result.error as Error? {
                    completion(nil, error.localizedDescription)
                }
        }
    }
    
    func postRequest(url:String,methodName:HTTPMethod, parameters: [String:Any],headers: HTTPHeaders,completion: @escaping completionHandlerBlock){
        
        if isQueryString {
            isQueryString = false
            Alamofire.request(
                URL(string: url)!,
                method:methodName ,
                parameters:parameters,
                encoding:URLEncoding.queryString,
                headers:headers
                )
                .validate(statusCode: 200..<500)
                .responseJSON { (responseData) -> Void in
                    if let json = responseData.result.value  {
                        completion(json, nil)
                    }
                    else if let error = responseData.result.error as Error? {
                        completion(nil, error.localizedDescription)
                    }
            }
        }else{
            Alamofire.request(
                URL(string: url)!,
                method:methodName ,
                parameters:parameters,
                encoding:JSONEncoding.default,
                headers:headers
                )
                .validate(statusCode: 200..<500)
                .responseJSON { (responseData) -> Void in
                    if let json = responseData.result.value  {
                        completion(json, nil)
                    }
                    else if let error = responseData.result.error as Error? {
                        completion(nil, error.localizedDescription)
                    }
            }
        }
    }
    
    
    //MARK: - Sign In
    func getLogin(params: [String:Any],completion:@escaping (_ : Any?,_ : Any?)->Void)   {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kSignIn_Method
        debugPrint(loginUrl)
        isQueryString = true
        self.postRequest(url: loginUrl,methodName: .post, parameters: params, headers:[:]) { (response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    //MARK: - Sign Up
    func getSignUp(params: [String:Any],viaSocial:Bool,completion: @escaping (_ : Any?,_ : Any?)->Void)   {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kSignUp_Method
        //let finalParams = ["userDomain" : params]
        debugPrint(loginUrl)
        //debugPrint("signup:",finalParams)
        self.postRequest(url: loginUrl, methodName: .post,parameters: params, headers: [:]) { (response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    //MARK: - Activation Link
    func getResendLink(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        
        let user = params["email"] as? String ?? ""
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kResendLink_Method+user
        debugPrint(loginUrl)
        self.getRequest(url: loginUrl,methodName: .get, parameters: params, headers: [:]) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    //MARK: - Forgot Password
    func getForgotPassword(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        
        //        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        //        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        //
        let user = params["email"] as? String ?? ""
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kForgotPassword_Method + user
        debugPrint(loginUrl)
        self.getRequest(url: loginUrl,methodName: .get, parameters: params, headers: [:]) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: -  DealDetails
    func getDealDetails(methodName: String,params: [String:Any],completion:@escaping (_ : Any?,_ : Any?)->Void)   {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kRecommendedDeals_Method
        debugPrint(loginUrl)
        debugPrint(params)
        isQueryString = true
        self.postRequest(url: loginUrl,methodName: .get, parameters: params, headers: [:]) { (response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: -  RecommendedDeals
    func getRecommendedDeals(params: [String:Any],completion:@escaping (_ : Any?,_ : Any?)->Void)   {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kRecommendedDeals_Method
        debugPrint(loginUrl)
        debugPrint(params)
        isQueryString = true
        self.postRequest(url: loginUrl,methodName: .get, parameters: params, headers: [:]) { (response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    //MARK: -  WhatsNewDeals
    func getWhatsNewDeals(params: [String:Any],completion:@escaping (_ : Any?,_ : Any?)->Void)   {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kWhatsNewDeals_Method
        debugPrint(loginUrl)
        isQueryString = true
        self.postRequest(url: loginUrl,methodName: .get, parameters: params, headers: [:]) { (response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    //MARK: -  TrendingDeals
    func getTrendingDeals(params: [String:Any],completion:@escaping (_ : Any?,_ : Any?)->Void)   {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kTrendingDeals_Method
        debugPrint(loginUrl)
        isQueryString = true
        self.postRequest(url: loginUrl,methodName: .get, parameters: params, headers: [:]) { (response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    //MARK: -  MostViewedDeals
    func getMostViewedDeals(params: [String:Any],completion:@escaping (_ : Any?,_ : Any?)->Void)   {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kMostViewedDeals_Method
        debugPrint(loginUrl)
        isQueryString = true
        self.postRequest(url: loginUrl,methodName: .get, parameters: params, headers: [:]) { (response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    //MARK: -  RecentlyViewedDeals
    func getRecentlyViewedDeals(params: [String:Any],completion:@escaping (_ : Any?,_ : Any?)->Void)   {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kRecentlyViewedDeals_Method
        debugPrint(loginUrl)
        isQueryString = true
        self.postRequest(url: loginUrl,methodName: .get, parameters: params, headers: [:]) { (response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - Meta Data
    func getMetaData(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)   {
        
        if UserDefaults.standard.object(forKey: "UserData") == nil {
            return
        }
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let user = dicUser!["email"] as? String ?? ""
        let dic = ["email":user]
        isQueryString = true
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kMetaData_Method
        debugPrint(loginUrl)
        self.postRequest(url: loginUrl, methodName: .get,parameters: dic, headers: [:]) { (response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    //MARK: - Change Password
    func getChangePassword(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kChangePassword_Method
        let user = params["email"] as? String ?? ""
        let password = params["password"] as? String ?? ""
        let str = user +  ":" + password
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        self.postRequest(url: loginUrl, methodName: .post,parameters: params, headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - Profile
    func getProfile(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let user = dicUser!["email"] as? String ?? ""
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.KMyProfile_Method + user
        self.getRequest(url: loginUrl,methodName: .get, parameters: params, headers: [:]) { (response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    func getUpdateProfile(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let user = dicUser!["email"] as? String ?? ""
        let password = dicUser!["password"] as? String ?? ""
        
        let str = user +  ":" + password
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.KUpdateProfile_Method
        self.postRequest(url: loginUrl,methodName: .post, parameters: params, headers: headerData) { (response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - UpdateBilling
    func getUpdateBillingPage(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kUpdateBillingPage_Method
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let user = dicUser!["email"] as? String ?? ""
        let password = dicUser!["password"] as? String ?? ""
        let str = user +  ":" + password
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        self.postRequest(url: loginUrl, methodName: .post,parameters: params, headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - UpdateShipping
    func getUpdateShippingPage(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kUpdateShippingPage_Method
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let user = dicUser!["email"] as? String ?? ""
        let password = dicUser!["password"] as? String ?? ""
        
        let str = user +  ":" + password
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        self.postRequest(url: loginUrl, methodName: .post,parameters: params, headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    
    //MARK: - My Returns
    func getMyReturns(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let user = dicUser!["email"] as? String ?? ""
        let password = dicUser!["password"] as? String ?? ""
        
        let str = user +  ":" + password
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kMyReturns_Method + user
        
        self.getRequest(url: loginUrl, methodName: .get,parameters: params, headers:headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - Check Return Status
    func getCheckReturnStatus(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kCheckReturn_Status_Method
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let user = dicUser!["email"] as? String ?? ""
        let password = dicUser!["password"] as? String ?? ""
        let str = user +  ":" + password
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        self.getRequest(url: loginUrl, methodName: .get,parameters: [:], headers:headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - Intiate Return
    func getIntiateReturn(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kIntiateReturn_Method
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let user = dicUser!["email"] as? String ?? ""
        let password = dicUser!["password"] as? String ?? ""
        let str = user +  ":" + password
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        self.getRequest(url: loginUrl, methodName: .post,parameters: params, headers:headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    //MARK: - Card_BuyNow
    func getCardBuyNow(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kCard_BuyNow_Method
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let user = dicUser!["email"] as? String ?? ""
        let password = dicUser!["password"] as? String ?? ""
        
        let str = user +  ":" + password
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        self.postRequest(url: loginUrl, methodName: .post,parameters: params, headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - PayPal buyNow
    func getPayPalbuyNow(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kPayPal_BuyNow
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let user = dicUser!["email"] as? String ?? ""
        let password = dicUser!["password"] as? String ?? ""
        
        let str = user +  ":" + password
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        self.postRequest(url: loginUrl, methodName: .post,parameters: params, headers:headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - PayPal Join Now
    func getPayPalJoinNow(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kPayPal_JoinNow
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let user = dicUser!["email"] as? String ?? ""
        let password = dicUser!["password"] as? String ?? ""
        
        let str = user +  ":" + password
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        self.postRequest(url: loginUrl, methodName: .post,parameters: params, headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    //MARK: - VerifyAddress
    func getVerifyAddressPage(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kVerifyAddressPage_Method
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let user = dicUser!["email"] as? String ?? ""
        let password = dicUser!["password"] as? String ?? ""
        
        let str = user +  ":" + password
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        self.postRequest(url: loginUrl, methodName: .post,parameters: params, headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error.debugDescription)
            }
        }
    }
    //MARK: - CalculateShiping
    func getCalculateShiping(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kCalculateShiping
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let user = dicUser!["email"] as? String ?? ""
        let password = dicUser!["password"] as? String ?? ""
        
        let str = user +  ":" + password
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        self.postRequest(url: loginUrl, methodName: .post,parameters: params, headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - Review All
    func getReview(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        
        let dealId = params["dealId"] as? String ?? ""
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kReview_Method + dealId
        self.getRequest(url: loginUrl, methodName: .get,parameters: [:], headers: [:]) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - Verify Review
    func getVerifyReview(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kReview_Verify_Method
        isQueryString = true
        self.postRequest(url: loginUrl, methodName: .get,parameters: params, headers: [:]) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    //MARK: - Update device for Notification
    func getDeviceUpdate(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kSave_Device
        self.postRequest(url: loginUrl, methodName: .post,parameters: params, headers: [:]) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    //MARK: - PostReview
    func getPostReview(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kPostReview_Method
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let user = dicUser!["email"] as? String ?? ""
        let password = dicUser!["password"] as? String ?? ""
        let str = user +  ":" + password
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        self.postRequest(url: loginUrl, methodName: .post,parameters: params, headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - WatchList
    func getMyWatchList(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)   {
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let strTitle = dicUser!["email"] as? String ?? ""
        let strPassword = dicUser!["password"] as? String ?? ""
        
        let str = strTitle +  ":" + strPassword
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kGetWatch_Method + strTitle
        
        self.getRequest(url: loginUrl,methodName: .get,parameters: params,headers: headerData ) { (response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    //MARK: - AddWatch
    func getAddWatch(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let strTitle = dicUser!["email"] as? String ?? ""
        let strPassword = dicUser!["password"] as? String ?? ""
        
        let str = strTitle +  ":" + strPassword
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kAddWatch_Method
        
        self.postRequest(url: loginUrl, methodName: .post,parameters: params, headers:headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - RemoveWatch
    func getRemoveWatch(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        
        let dealId = params["watchListId"] as? String ?? ""
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let strTitle = dicUser!["email"] as? String ?? ""
        let strPassword = dicUser!["password"] as? String ?? ""
        
        let str = strTitle +  ":" + strPassword
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kRemoveWatch_Method + dealId
        
        self.getRequest(url: loginUrl, methodName: .get,parameters: [:], headers:headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    
    //MARK: - Purchase History Service
    func getPurchaseHistoryService(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let strTitle = dicUser!["email"] as? String ?? ""
        let strPassword = dicUser!["password"] as? String ?? ""
        
        let str = strTitle +  ":" + strPassword
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kPaymentHistory_Method + strTitle + "/" + "1" + "/" + "Service"
        
        self.getRequest(url: loginUrl, methodName: .get,parameters: params, headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - Purchase History Product
    func getPurchaseHistoryProduct(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let strTitle = dicUser!["email"] as? String ?? ""
        let strPassword = dicUser!["password"] as? String ?? ""
        
        let str = strTitle +  ":" + strPassword
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kPaymentHistory_Method + strTitle + "/" + "1" + "/" + "Product"
        
        self.getRequest(url: loginUrl, methodName: .get,parameters: params, headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    
    //MARK: - CancelPurchase
    func getCancelPurchase(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        
        isQueryString = true
        
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kCancelPurchase_Method
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let strTitle = dicUser!["email"] as? String ?? ""
        let strPassword = dicUser!["password"] as? String ?? ""
        
        let str = strTitle +  ":" + strPassword
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        self.getRequest(url: loginUrl, methodName: .get,parameters: params, headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    
    
    //MARK: - EmailBody
    func getEmailBody(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.KEmailBody
        self.getRequest(url: loginUrl, methodName: .post,parameters: params, headers: [:]) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    //MARK: - Filter Screen
    //All Category
    func getAllCategory(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kGet_All_Category
        self.getRequest(url: loginUrl, methodName: .get,parameters: params, headers: [:]) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
  
    ////////////
    
    //Keyword Search Deal - search screen
    func getKeywordSearchDeal(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kDeal_KeywordSearch
        isQueryString = true
        self.postRequest(url: loginUrl, methodName: .get,parameters: params, headers: [:]) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
   

    //MARK: -  Saved Search
    func getSavedSearch(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        isQueryString = true
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let strTitle = dicUser!["email"] as? String ?? ""
        let strPassword = dicUser!["password"] as? String ?? ""
        
        let str = strTitle +  ":" + strPassword
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kGetSaved_Search_Method
        self.postRequest(url: loginUrl, methodName: .get,parameters: params, headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    //MARK: -  Deal Names
    func getDealNames(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        //queryString=dd
        isQueryString = true
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kGetDeal_Names
        self.postRequest(url: loginUrl, methodName: .get,parameters: params, headers: [:]) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - ContactUs
    func getContactUs(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kContactUs_Method
        self.postRequest(url: loginUrl, methodName: .post,parameters: params, headers: [:]) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - Social Login
    func getSocialLogin(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kSocialLogin_Method
        self.postRequest(url: loginUrl, methodName: .post,parameters: params, headers: [:]) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - Social Connect
    func getSocialConnect(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kSocialConnect_Method
        
        let user = params["email"] as? String ?? ""
        let password = params["password"] as? String ?? ""
        let str = user +  ":" + password
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        self.postRequest(url: loginUrl, methodName: .post,parameters: params, headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - Social Disconnect
    func getSocialDisconnect(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kSocialDisconnect_Method
        let user = params["email"] as? String ?? ""
        let password = params["password"] as? String ?? ""
        let str = user +  ":" + password
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        isQueryString = true
        self.postRequest(url: loginUrl, methodName: .post,parameters: params, headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    
    
    
    //MARK: - all Redeem deals
    func getRedeemService(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let strTitle = dicUser!["email"] as? String ?? ""
        let strPassword = dicUser!["password"] as? String ?? ""
        
        let str = strTitle +  ":" + strPassword
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kRedeem_Method + strTitle + "/1"
        self.getRequest(url: loginUrl, methodName: .get,parameters: params, headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - Redeemed
    func getRedeemed(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        isQueryString = true
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let strTitle = dicUser!["email"] as? String ?? ""
        let strPassword = dicUser!["password"] as? String ?? ""
        
        let str = strTitle +  ":" + strPassword
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kRedeemed_Method
        self.postRequest(url: loginUrl, methodName: .post,parameters: params, headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - Authcode_MainBranch_Method
    func getAuthCodeMainBranch(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kAuthcode_MainBranch_Method
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let strTitle = dicUser!["email"] as? String ?? ""
        let strPassword = dicUser!["password"] as? String ?? ""
        
        let str = strTitle +  ":" + strPassword
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        self.postRequest(url: loginUrl, methodName: .post,parameters: params, headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - Authcode_Branch_Method
    func getAuthCodeBranch(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let strTitle = dicUser!["email"] as? String ?? ""
        let strPassword = dicUser!["password"] as? String ?? ""
        
        let str = strTitle +  ":" + strPassword
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        
        let name = params["name"] as? String ?? ""
        let finalName = "name=" + name + "&"
        
        let branch = params["branchId"] as? String ?? ""
        let finalBranch = "branchId=" + branch
        
        let trimmedString = finalName + finalBranch
        let finalTrimmedString = trimmedString.replacingOccurrences(of: " ", with: "")
        
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kAuthcode_Branch_Method + finalTrimmedString
        
        //No need to send branchId in postparams
        var dicParams = params
        dicParams.removeValue(forKey: "branchId")
        dicParams.removeValue(forKey: "name")
        
        
        
        self.postRequest(url: loginUrl, methodName: .post,parameters: dicParams, headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
    
    //MARK: - Business Branches
    func getBuisinessBranches(params: [String:Any],completion: @escaping (_ : Any?,_ : Any?)->Void)    {
        
        let decoded  = UserDefaults.standard.object(forKey: "UserData") as! Data
        let dicUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Dictionary<String,Any>
        
        let strTitle = dicUser!["email"] as? String ?? ""
        let strPassword = dicUser!["password"] as? String ?? ""
        
        let str = strTitle +  ":" + strPassword
        let credentialData = str.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options:[])
        let headerData = ["Authorization": "Basic \(base64Credentials)"]
        
        let bEmail = params["userId"] as? String ?? ""
        let bName = params["name"] as? String ?? ""
        
        let apendStr = bEmail + "/" + bName
        
        let trimmedString = apendStr.replacingOccurrences(of: " ", with: "")
        
        let loginUrl = Constants.kBayBoonBaseUrl + Constants.kBuisinessBranches_Method + trimmedString
        
        self.getRequest(url: loginUrl, methodName: .get,parameters: [:], headers: headerData) {(response, error) in
            if response != nil{
                let str = response as! [String:Any]
                completion(str ,nil)
            }else{
                completion(nil ,error)
            }
        }
    }
}

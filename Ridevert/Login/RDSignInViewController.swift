//
//  RDSignInViewController.swift
//  Ridevert
//
//  Created by savaram, Ramakrishna on 24/07/2018.
//  Copyright © 2018 savaram, Ramakrishna. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import MBProgressHUD
import FacebookLogin
import FBSDKLoginKit
import SwiftyJSON

class RDSignInViewController: UIViewController, AlertViewControllerDelegate,GIDSignInDelegate,GIDSignInUIDelegate,UITextFieldDelegate {

    @IBOutlet var imgRightIcon: UIImageView!
    @IBOutlet var txtFieldEmail: UITextField!
    @IBOutlet var txtFieldPassword: UITextField!
    let alert = RDAlertViewController.sharedInstance
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var lblLineEmail: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        // Do any additional setup after loading the view.
        self.alert.delegate = self
        // self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
       // self.hideKeyboardWhenTappedAround()
        
        // NotificationCenter.default.addObserver(self, selector: #selector(signUpSuccess(notification:)), name: Notification.Name("SignUpSuccess"), object: nil)
        
        
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "98186277011-vd01mi0lf60ucdlob8lpgno08n8os4dk.apps.googleusercontent.com" //Constants.kGP_ClientId
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
    }
    @objc func linkedInNotification(notification: Notification){
        let dicRes = notification.userInfo as? [String:Any]
        let email = dicRes!["emailAddress"] as? String ?? ""
        let userId = dicRes!["id"] as? String ?? ""
        self.sendSocialLogin(socialType: "linkedin", user:email, id:userId)
    }
    func signUpSuccess(notification: Notification){
        //Take Action on Notification
        self.dismiss(animated: true) {
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.linkedInNotification(notification:)), name: Notification.Name("LinkedInResponse"), object: nil)
        // Hide the navigation bar for current view controller
        //self.navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        //self.navigationController?.isNavigationBarHidden = false;
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func btnForgotPass(_ sender: Any) {
        
        if let forgotPassViewController = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") {
            self.navigationController?.pushViewController(forgotPassViewController, animated: true)
        }
    }
    
    @IBAction func didTapSignIn(_ sender: Any) {
        if RDTextFieldValidation.sharedInstance.isEmptyString(value: txtFieldEmail.text!) {
            self.alert.SubmitAlertView(viewController: self,title:"Error", message: "Please enter email address." , isCancelBtn: false)
            return
        }else{
            let isValid = RDTextFieldValidation.sharedInstance.isValidEmail(testStr: txtFieldEmail.text!)
            if !isValid{
                self.alert.SubmitAlertView(viewController: self,title: "Invalid Email", message: "Please enter  valid email address." , isCancelBtn: false)
                return
            }
        }
        
        if RDTextFieldValidation.sharedInstance.isEmptyString(value: txtFieldPassword.text!) {
            self.alert.SubmitAlertView(viewController: self,title:"Error", message:"Please enter the password." , isCancelBtn: false)
            return
        }else{
            let isValid = RDTextFieldValidation.sharedInstance.isValidPassword(password:  txtFieldPassword.text!)
            if !isValid{
                self.alert.SubmitAlertView(viewController: self,title: "Invalid Password", message:"Please enter Password between 6 and 16 characters.", isCancelBtn: false)
                return
            }
        }
        
        if(appDelegate.isDataSourceAvailable()){
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let dicParams = ["email": txtFieldEmail.text!,"password":txtFieldPassword.text!]
            RDNetworkManager.sharedInstance.getLogin(params:dicParams) { (response, error) in
                if (error as? String) != nil{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
                    UserDefaults.standard.synchronize()
                    self.alert.SubmitAlertView(viewController: self,title: "Error", message: error as! String , isCancelBtn: false)
                }else{
                    let dic = response as! [String:Any]
                    if (dic["code"] as? Int == 200)  {
                        self.txtFieldEmail.text = ""
                        self.txtFieldPassword.text = ""
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        UserDefaults.standard.synchronize()
                        let objectData = dic["object"] as? Dictionary<String, Any>
                        let userData = objectData!["user"] as? Dictionary<String, Any>
                        
                        let encodedData = NSKeyedArchiver.archivedData(withRootObject: userData)
                        UserDefaults.standard.set(encodedData, forKey:"UserData")
                        UserDefaults.standard.synchronize()
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.dismiss(animated: true, completion: {
                            
                        })
                    }else if dic["message"] as! String == "Your account is not activated, please click on the link in email to activate account"{
                        MBProgressHUD.hide(for: self.view, animated: true)
                        UserDefaults.standard.set(false, forKey: "isLoggedIn")
                        UserDefaults.standard.synchronize()
                        
                        let str = "Your account is not activated, please click on the link in \(self.txtFieldEmail.text!)  to activate account Or Click on Resend activation Resend activation mail."
                        
                        self.alert.SubmitAlertView(viewController: self,title: "Error Occured", message: str, isCancelBtn: true)
                        //@"Resend"
                    }
                    else{
                        MBProgressHUD.hide(for: self.view, animated: true)
                        UserDefaults.standard.set(false, forKey: "isLoggedIn")
                        UserDefaults.standard.synchronize()
                        self.alert.SubmitAlertView(viewController: self,title: "Error Occured", message: dic["message"] as! String , isCancelBtn: false)
                    }
                }
            }
        }
        else{
            self.alert.SubmitAlertView(viewController: self,title: "Error", message: "Failed to connect. Check internet connection!" , isCancelBtn: false)
        }
        
    }
    @IBAction func didTapBtnSignUp(_ sender: Any) {
        if let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "BBSignUpViewController") {
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
    // MARK: - AlertDelegate
    func SubmitAlertViewResult(textValue : String) {
        if textValue == "Resend"{
            if(appDelegate.isDataSourceAvailable()){
                MBProgressHUD.showAdded(to: self.view, animated: true)
                let dicParams = ["email": txtFieldEmail.text!]
                RDNetworkManager.sharedInstance.getResendLink(params:dicParams) { (response, error) in
                    if (error as? String) != nil{
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.alert.SubmitAlertView(viewController: self,title: "Error", message: error as! String , isCancelBtn: false)
                    }else{
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let dic = response as! [String:Any]
                        //self.txtFieldEmail.text = ""
                        if dic["message"] != nil {
                            //dic["message"] as! String
                            self.alert.SubmitAlertView(viewController: self,title: "Success", message:"Resend activation link sent to email,please click on the link in email to activate account."  , isCancelBtn: false)
                        }
                    }
                }
            }else{
                self.alert.SubmitAlertView(viewController: self,title: "Error", message: "Failed to connect. Check internet connection!" , isCancelBtn: false)
            }
        }else{
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func didTapShow(_ sender: Any) {
        self.txtFieldPassword.isSecureTextEntry = false
    }
    // MARK: -  UITextField Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtFieldPassword{
            self.txtFieldPassword.isSecureTextEntry = true
        }
        
    }
    func  textFieldDidEndEditing(_ textField: UITextField){
        if textField == self.txtFieldEmail{
            if RDTextFieldValidation.sharedInstance.isValidEmail(testStr: txtFieldEmail.text!){
                self.imgRightIcon.isHidden = false
                lblLineEmail.backgroundColor = UIColor(red: 58.0/255.0, green:213.0/255 , blue: 59.0/255.0, alpha: 1)
            }else{
                self.imgRightIcon.isHidden = true
                lblLineEmail.backgroundColor = UIColor(red: 0, green:0 , blue: 0, alpha: 1)
            }
        }
    }
    
    
    
    @objc func loginButtonClicked() {
        
                let loginManager = LoginManager()
                loginManager.logIn(readPermissions: [ .publicProfile,.email ], viewController: self) { loginResult in
                    switch loginResult {
                    case .failed(let error):
                        print(error)
                    case .cancelled:
                        print("User cancelled login.")
                    case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                        self.getFBUserData()
                    }
                }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        
        
//        if(FBSDKAccessToken.current() != nil)
//        {
//            //print permissions, such as public_profile
//            print(FBSDKAccessToken.current().permissions)
//            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
//            graphRequest?.start(completionHandler: { (connection, result, error) -> Void in
//
//                self.dict =
//
//                self.label.text = result.valueForKey("name") as? String
//
//                let FBid = result.valueForKey("id") as? String
//
//                let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
//                self.imageView.image = UIImage(data: NSData(contentsOfURL: url!)!)
//            })
//        }
//
//        let graphPath = "me"
//
//        let parameters = ["fields": "id, name, first_name, last_name, age_range, link, gender, locale, timezone, picture, updated_time, verified"]
//
//        let completionHandler = { (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError?) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                let json = JSON(result)
//                print(json)
//            }
//        }
//
        
        if((FBSDKAccessToken.current()) != nil){

            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){


                   var dic = result as! [String : Any]

                    let strId = dic["id"] as! String
                    let strname = dic["name"] as! String
                    let pDic = dic["picture"] as! [String:Any]
                    let data = pDic["data"] as! [String:Any]
                    let urlstring = data["url"] as? String ?? ""
                    // var dic = self.dict as NSDictionary
                    print(dic)
                    let url = URL(string: urlstring)
                    

                    self.saveUserData(userName: strname, profileUrl:url! )

                  //  var pictureDic = self.dict["picture"]
                    //var userDatadic = pictureDic!["data"]
                   // var profileUrl = userDatadic!!["url"]
                   // print(self.dict)
                }
            })
        }
    }

    
    @IBAction func didTapFB(_ sender: Any) {
        
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile,.email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
        
    }
    //function is fetching the user data
   
    @IBAction func didTapGooglePlus(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate

            // Perform any operations on signed in user here.
            let userId = user.userID  ?? ""               // For client-side use only!
            /* let idToken = user.authentication.idToken // Safe to send to the server
             let fullName = user.profile.name
             let givenName = user.profile.givenName
             let familyName = user.profile.familyName*/
            let email = user.profile.email ?? ""
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            appDelegate.profileName = user.profile.givenName
            //let profileUrl = user.profile.ur
            
          
            saveUserData(userName:givenName!,profileUrl:user.profile.imageURL(withDimension: 100))


           
            
            
           // self.sendSocialLogin(socialType: "google", user:email, id:userId)
        }
    }
    
    
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //        myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapLinkedIn(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let dealVC = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        self.present(dealVC, animated: true, completion: nil)
        
        // (clientId: "75f3efrngjkgz7", clientSecret: "27cc72207b118380c13926f14a6d0a6c",
        
    }
    
    func sendSocialLogin(socialType:String,user:String,id:String){
        if(appDelegate.isDataSourceAvailable()){
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let dicParams = ["providerId":socialType, "providerUserId":id, "userId":user]
            RDNetworkManager.sharedInstance.getSocialLogin(params:dicParams) { (response, error) in
                if (error as? String) != nil{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.alert.SubmitAlertView(viewController: self,title: "Error", message: error as! String , isCancelBtn: false)
                }else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let dic = response as! [String:Any]
                    let objectData = dic["object"] as? Dictionary<String, Any>
                    if objectData != nil  {
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        UserDefaults.standard.synchronize()
                        let userData = objectData!["user"] as? Dictionary<String, Any>
                        
                        let encodedData = NSKeyedArchiver.archivedData(withRootObject: userData)
                        UserDefaults.standard.set(encodedData, forKey:"UserData")
                        UserDefaults.standard.synchronize()
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        self.dismiss(animated: true, completion: {
                            
                        })
                    }else{
                        self.alert.SubmitAlertView(viewController: self,title: "Error", message: dic["message"] as! String , isCancelBtn: false)
                    }
                }
            }
        }else{
            self.alert.SubmitAlertView(viewController: self,title: "Error", message: "Failed to connect. Check internet connection!" , isCancelBtn: false)
        }
    }
    
    
    func saveUserData(userName:String,profileUrl:URL)
    
    {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(userName, forKey: "profilename")
        do {
            let imgData = try NSData(contentsOf: profileUrl, options: NSData.ReadingOptions())
            UserDefaults.standard.set(imgData, forKey: "profileimage")
            
            DispatchQueue.main.async() { () -> Void in
                
            }
        } catch {
            
        }
        UserDefaults.standard.synchronize()
        print(UserDefaults.standard.value(forKeyPath: "profileimage"))
        appDelegate.showMainScreen()
        
    }

}



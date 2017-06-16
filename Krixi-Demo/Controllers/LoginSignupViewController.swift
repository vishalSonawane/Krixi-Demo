//
//  ViewController.swift
//  Krixi-Demo
//
//  Created by Vishal Sonawane on 14/06/17.
//  Copyright © 2017 Vishal Sonawane. All rights reserved.
//

import UIKit
import CoreData
import Foundation

enum AMLoginSignupViewMode {
    case login
    case signup
}

class LoginSignupViewController: UIViewController {
    
    
    let animationDuration = 0.25
    var mode:AMLoginSignupViewMode = .signup
    
    
    //MARK: - background image constraints
    @IBOutlet weak var backImageLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var backImageBottomConstraint: NSLayoutConstraint!
    
    
    //MARK: - login views and constrains
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginContentView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginWidthConstraint: NSLayoutConstraint!
    
    
    //MARK: - signup views and constrains
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var signupContentView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signupButtonVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var signupButtonTopConstraint: NSLayoutConstraint!
    
    
    //MARK: - logo and constrains
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoButtomInSingupConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoCenterConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var forgotPassTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var socialsView: UIView!
    
    
    //MARK: - input views
    @IBOutlet weak var loginEmailInputView: AMInputView!
    @IBOutlet weak var loginPasswordInputView: AMInputView!
    @IBOutlet weak var signupEmailInputView: AMInputView!
    @IBOutlet weak var signupPasswordInputView: AMInputView!
    @IBOutlet weak var signupPasswordConfirmInputView: AMInputView!
    
    
    
    //MARK: - controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add tap gesture
        let oneTapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginSignupViewController.tappedOnce))
        oneTapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(oneTapGesture)
        
        // set view to login mode
        toggleViewMode(animated: false)
        
        //add keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboarFrameChange(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        resetData()
    }
    
    func resetData()  {
        signupEmailInputView.textFieldView.text = ""
        signupPasswordInputView.textFieldView.text = ""
        signupPasswordConfirmInputView.textFieldView.text = ""
        loginEmailInputView.textFieldView.text = ""
        loginPasswordInputView.textFieldView.text = ""
    }
    
    func tappedOnce()  {
        //hides keyboard if open
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    
    //MARK: - button actions
    @IBAction func loginButtonTouchUpInside(_ sender: AnyObject) {
        
        if mode == .signup {
            toggleViewMode(animated: true)
            
        }else{
            //TODO: login by this data
            NSLog("Email:\(String(describing: loginEmailInputView.textFieldView.text)) Password:\(String(describing: loginPasswordInputView.textFieldView.text))")
           
            
            if loginEmailInputView.textFieldView.text! == "" {
                //
                Utils.showError("Please enter email address")
            }else if !Utils.isValidEmail(testStr: loginEmailInputView.textFieldView.text!) {
                //
                Utils.showError("Please enter valid email address")
            }else if loginPasswordInputView.textFieldView.text! == ""{
                Utils.showError("Please enter password")
            }else{
                //check for registered user
                let context = (UIApplication.shared.delegate as! AppDelegate).getContext()
                var users = [User]()
                //Get users
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
                
                do {
                    users = try context.fetch(fetchRequest) as! [User]
                    if users.isEmpty {
                        Utils.showError(MESSAGE_SIGNUP_FIRST)
                        return
                    }
                    var isUserMatched = false
                    for user in users {
                        if user.email == loginEmailInputView.textFieldView.text! && loginPasswordInputView.textFieldView.text! == user.password{
                            print("Login Successful..")
                            currentUser = user
                            UserDefaults.standard.set(true, forKey: isUserLoggedIn)
                            UserDefaults.standard.set(user.id, forKey: loggedInUserId)
                            loadShoppingView()
                            isUserMatched = true
                            return
                        }else{
                            isUserMatched = false
                            
                        }
                        if !isUserMatched {
                            Utils.showError(ERROR_INVALID_CREDENTIALS)
                        }
                    }
                } catch  {
                    print("Error while fetching users")
                }
            }
           
        }
    }
    
    @IBAction func signupButtonTouchUpInside(_ sender: AnyObject) {
        
        if mode == .login {
            toggleViewMode(animated: true)
        }else{
            
            //TODO: signup by this data
            NSLog("Email:\(String(describing: signupEmailInputView.textFieldView.text)) Password:\(String(describing: signupPasswordInputView.textFieldView.text)), PasswordConfirm:\(String(describing: signupPasswordConfirmInputView.textFieldView.text))")
            
            if signupEmailInputView.textFieldView.text! == "" {
                //
                Utils.showError(ERROR_NO_EMAIL)
            }else if !Utils.isValidEmail(testStr: signupEmailInputView.textFieldView.text!) {
                //
                Utils.showError(ERROR_WRONG_EMAIL)
            }else if signupPasswordInputView.textFieldView.text! == ""{
                Utils.showError(ERROR_NO_PASSWORD)
            }else if signupPasswordConfirmInputView.textFieldView.text! == ""{
                Utils.showError(ERROR_NO_CONFIRM_PASSWORD)
            }else if signupPasswordInputView.textFieldView.text != signupPasswordConfirmInputView.textFieldView.text{
                Utils.showError(ERROR_PASSWORD_NOT_MATCHING)
            }else{
                //Register user
                let context = (UIApplication.shared.delegate as! AppDelegate).getContext()
                
                let user = User(context: context)
                user.email  = signupEmailInputView.textFieldView.text!
                user.password = signupPasswordInputView.textFieldView.text!
                user.id = UUID().uuidString
                Utils.showSucess(SUCCESS_SIGNUP)
                mode = .signup
                toggleViewMode(animated: true)
                resetData()
                
                do {
                    try context.save()
                } catch  {
                    print("ERROR While saving User: \(error.localizedDescription)")
                }
            }
            
        }
    }
    
    
    //MARK: - load Shoping Items view
    func loadShoppingView()  {
        let shoppingNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShoppingItemNavigationController") as! UINavigationController
        let shoppingVC = shoppingNavigationController.viewControllers.first as! ShoppingItemViewController
        let allUserClothsPairs = currentUser?.clothsPair?.allObjects as? [Images]
        if (allUserClothsPairs?.count)! > 0 {
            shoppingVC.pantShirtImages = allUserClothsPairs!
        }
       
        self.navigationController?.show(shoppingNavigationController, sender: nil)
    
    }
    
    //MARK: - toggle view
    func toggleViewMode(animated:Bool){
        
        // toggle mode
        mode = mode == .login ? .signup:.login
        
        
        // set constraints changes
        backImageLeftConstraint.constant = mode == .login ? 0:-self.view.frame.size.width
        
        
        loginWidthConstraint.isActive = mode == .signup ? true:false
        logoCenterConstraint.constant = (mode == .login ? -1:1) * (loginWidthConstraint.multiplier * self.view.frame.size.width)/2
        loginButtonVerticalCenterConstraint.priority = mode == .login ? 300:900
        signupButtonVerticalCenterConstraint.priority = mode == .signup ? 300:900
        
        
        //animate
        self.view.endEditing(true)
        
        UIView.animate(withDuration:animated ? animationDuration:0) {
            
            //animate constraints
            self.view.layoutIfNeeded()
            
            //hide or show views
            self.loginContentView.alpha = self.mode == .login ? 1:0
            self.signupContentView.alpha = self.mode == .signup ? 1:0
            
            
            // rotate and scale login button
            let scaleLogin:CGFloat = self.mode == .login ? 1:0.4
            let rotateAngleLogin:CGFloat = self.mode == .login ? 0:CGFloat(-Double.pi/2)
            
            var transformLogin = CGAffineTransform(scaleX: scaleLogin, y: scaleLogin)
            transformLogin = transformLogin.rotated(by: rotateAngleLogin)
            self.loginButton.transform = transformLogin
            
            
            // rotate and scale signup button
            let scaleSignup:CGFloat = self.mode == .signup ? 1:0.4
            let rotateAngleSignup:CGFloat = self.mode == .signup ? 0:CGFloat(-Double.pi/2)
            
            var transformSignup = CGAffineTransform(scaleX: scaleSignup, y: scaleSignup)
            transformSignup = transformSignup.rotated(by: rotateAngleSignup)
            self.signupButton.transform = transformSignup
        }
        
    }
    
    
    //MARK: - keyboard
    func keyboarFrameChange(notification:NSNotification){
        
        let userInfo = notification.userInfo as! [String:AnyObject]
        
        // get top of keyboard in view
        let topOfKetboard = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue .origin.y
        
        
        // get animation curve for animate view like keyboard animation
        var animationDuration:TimeInterval = 0.25
        var animationCurve:UIViewAnimationCurve = .easeOut
        if let animDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            animationDuration = animDuration.doubleValue
        }
        
        if let animCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
            animationCurve =  UIViewAnimationCurve.init(rawValue: animCurve.intValue)!
        }
        
        
        // check keyboard is showing
        let keyboardShow = topOfKetboard != self.view.frame.size.height
        
        
        //hide logo in little devices
        let hideLogo = self.view.frame.size.height < 667
        
        // set constraints
        backImageBottomConstraint.constant = self.view.frame.size.height - topOfKetboard
        
        logoTopConstraint.constant = keyboardShow ? (hideLogo ? 0:20):50
        logoHeightConstraint.constant = keyboardShow ? (hideLogo ? 0:40):60
        logoBottomConstraint.constant = keyboardShow ? 20:32
        logoButtomInSingupConstraint.constant = keyboardShow ? 20:32
        
        forgotPassTopConstraint.constant = keyboardShow ? 30:45
        
        loginButtonTopConstraint.constant = keyboardShow ? 25:30
        signupButtonTopConstraint.constant = keyboardShow ? 23:35
        
        loginButton.alpha = keyboardShow ? 1:0.7
        signupButton.alpha = keyboardShow ? 1:0.7
        
        
        
        // animate constraints changes
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        
        self.view.layoutIfNeeded()
        
        UIView.commitAnimations()
        
    }
    
    //MARK: - hide status bar in swift3
    
    override var prefersStatusBarHidden: Bool {
        return true
    }  
}



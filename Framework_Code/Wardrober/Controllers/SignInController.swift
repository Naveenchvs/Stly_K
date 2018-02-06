//
//  SignInController.swift
//  Sprint2
//
//  Created by Ravivarma Thirukamu on 10/13/16.
//  Copyright © 2016 Ravivarma Thirukamu. All rights reserved.
//

import UIKit

class SignInController: UIViewController, UITextFieldDelegate
{
    @IBOutlet var btnIG: NSLayoutConstraint!
  
    @IBOutlet var viTxtFields: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var btnForgot: UIButton!
    
    @IBOutlet var viButtons: UIView!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var fbButton: UIButton!
    @IBOutlet var igButton: UIButton!
    @IBOutlet var btnTwitter: UIButton!
    //@IBOutlet var btnGuest: UIButton!
    @IBOutlet var createBtn: UIButton!
    @IBOutlet var guestBtn: UIButton!
    
    @IBOutlet var viBtnsY: NSLayoutConstraint!
    @IBOutlet var btnFBY: NSLayoutConstraint!
    @IBOutlet var btnTWY: NSLayoutConstraint!
    
    var delegate : SignInDelegate!
    
    var activityView = UIActivityIndicatorView()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.viButtons.isHidden = true
        self.btnForgot.isHidden = true
        
        //UITextField delegate
        
        self.emailTextField.delegate=self
        self.passwordTextField.delegate=self
        
        
        print(" siginNavController viewDidLoad")
        
        //UserDefaults.standard.set(true, forKey: Constants.kUserSuccessfullySignedIn)

        let hideKeyBoardGesture = UITapGestureRecognizer(target: self, action: #selector(SignInController.hideKeyBoard(_:)))
        
        self.view.addGestureRecognizer(hideKeyBoardGesture)
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.color = UIColor.black
        activityView.center = self.view.center
        
        self.view.addSubview(activityView)
        
    }
    
    @objc func hideKeyBoard(_ sender: UITapGestureRecognizer? = nil)
    {
        self.view .endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true);
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.viButtons.isHidden = true
        self.btnForgot.isHidden = true
    }
    
  
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true);
    
        showControllers()
    }
    
    func showControllers()
    {
        print(" showControllers begin")

        
        self.viButtons.isHidden = false
        self.viBtnsY.constant = self.view.bounds.size.height
        self.btnFBY.constant = 50.0
        self.btnTWY.constant = 50.0
        self.btnIG.constant=30.0
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5,options: [], animations: {
            self.viBtnsY.constant = 200
          
            self.view.layoutIfNeeded()
    
        }, completion: nil)
        
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            
            self.btnFBY.constant = 20.0
            self.view.layoutIfNeeded()
            
        }, completion: nil)

        
        UIView.animate(withDuration: 1.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
        
            self.btnTWY.constant = 20.0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {

            self.btnIG.constant=20.0
            self.view.layoutIfNeeded()
            
        }, completion: nil)

        
        //set place holder text and placeholder text color
        
        self.emailTextField.attributedPlaceholder = NSAttributedString(string:"EMAIL", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,   NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Bold", size: 10)!])
        
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string:"PASSWORD", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,   NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Bold", size: 10)!])
        
    
        self.btnForgot.isHidden = false
    }
    
    
    @IBAction func cancelButtonTapped(_ sender : UIButton!)
    {
        self.delegate.signInControllerDidCancelLogin(self)
    }
    
    //#MARK:-- CREATE ACCOUNT BUTTON ACTION
    @IBAction func tapCreateAccountButton(_: AnyObject)
    {
        let signUpScreen = self.storyboard?.instantiateViewController(withIdentifier: "signUp") as? SignUpController
        signUpScreen?.delegate = self.delegate
        
        self.navigationController?.pushViewController(signUpScreen!, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }

    //#MARK:-- FORGOT BUTTON ACTION
    @IBAction func forgotPasswrdbtnTapped()
    {
        let forgotPasswordScreen = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordID") as? ForgotPassword
        self.navigationController?.pushViewController(forgotPasswordScreen!, animated: true)
    }
    
    //#MARK:-- SIGNIN BUTTON ACTION
    @IBAction func signInbtnTapped()
    {
        ///VALIDATION TO CHECK EMAIL AND PASSWORD IS NOT NIL
        if emailTextField.text!.isEmpty && passwordTextField.text!.isEmpty
        {
            self.showAlertView("Stanley Korshok", AlertMessage: "Please enter Email Address and Password", AlertButtonTitle: "Ok")
        }
            
        ///VALIDATION TO CHECK EMAIL IS NOT NIL
        else if emailTextField.text!.isEmpty
        {
            self.showAlertView("Stanley Korshok", AlertMessage: "Please enter Email Address", AlertButtonTitle: "Ok")
        }
            
        ///VALIDATION TO CHECK PASSWORD IS NOT NIL
        else if passwordTextField.text!.isEmpty
        {
            self.showAlertView("Stanley Korshok", AlertMessage: "Please enter Password", AlertButtonTitle: "Ok")
        }
        else
        {
            ///VALIDATION TO CHECK EMAIL IS NOT VALIDLY ENTER BY USER
            if !CommonHelper.isValidEmail(emailTextField.text!)
            {
                self.showAlertView("Stanley Korshok", AlertMessage: "Email address not correct.", AlertButtonTitle: "Ok")
            }
            else
            {
                //self.appDelegate.showAcitivyIndictor("Signing In",subTitleString: "Please Wait!!")
                
                self.activityView.startAnimating()
                
                let urlString = String(format: "%@/CustomerLoginVerify", arguments: [Urls.stanleyKorshakUrl]);
                
                let request = NSMutableURLRequest(url: NSURL(string:urlString)! as URL)
                
                let session = URLSession.shared
                
                request.httpMethod = "POST"
                
                request.allHTTPHeaderFields = ["Content-Type":"application/json; charset=utf-8", Urls.AccessToken: Wardrober.shared().serviceAccessToken!]
                
                let requestDict = ["UserName":emailTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"Password":passwordTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)];
                
                request.httpBody = try! JSONSerialization.data(withJSONObject: requestDict, options: [])
                
                let task = session.dataTask(with: request as URLRequest) { data, response, error in
                    
                    guard data != nil else
                    {
                        self.activityView.stopAnimating()
                        
                        print("no data found: \(String(describing: error))")
                        return
                    }
                    
                    do
                    {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? AnyObject
                        {
                            DispatchQueue.main.async
                            {
                                let (custID, message) =  LoginHelper.signInResponseMessage(json as AnyObject?)
                                
                                if custID !=  nil
                                {
                                    //self.appDelegate.hideAcitivyIndicator()
                                    
                                    self.activityView.stopAnimating()
                                    
                                    UserDefaults.standard.set(true, forKey: Constants.kUserSuccessfullySignedIn)
                                    UserDefaults.standard.setValue(custID, forKey: Constants.kSignedInUserID)
                                    UserDefaults.standard.synchronize()
                                    
                                    self.delegate.signInControllerDidLogin(self)
                                    
                                }
                                else
                                {
                                    UserDefaults.standard.set(false, forKey: Constants.kUserSuccessfullySignedIn)
                                    UserDefaults.standard.synchronize()
                                    
                                    if message != nil
                                    {
                                        self.activityView.stopAnimating()
                                        
                                        self.showAlertView("Error", AlertMessage: message! as NSString, AlertButtonTitle: "Ok")
                                    }
                                    else
                                    {
                                        self.activityView.stopAnimating()
                                        
                                        self.showAlertView("Error", AlertMessage: "Unknown Error", AlertButtonTitle: "Ok")
                                    }
                                }
                            }
                            
                        }
                        else
                        {
                            //Failed
                            self.activityView.stopAnimating()
                            
                            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("Error could not parse JSON: \(String(describing: jsonStr))")
                        }
                    }
                        
                    catch let parseError
                    {
                        self.activityView.stopAnimating()
                        
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                    }
                }
                
                task.resume()
            }
        }
    }
    
    func showAlertView(_ AlertTitle: NSString, AlertMessage:NSString, AlertButtonTitle:NSString)
    {
        let alert=UIAlertController(title: AlertTitle as String, message: AlertMessage as String, preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: AlertButtonTitle as String, style: UIAlertActionStyle.cancel, handler: nil));
        self.present(alert, animated: true, completion: nil)
    }
    
}

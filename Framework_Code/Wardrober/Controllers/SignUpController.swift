//
//  SignUpController.swift
//  Sprint2
//
//  Created by Ravivarma Thirukamu on 10/13/16.
//  Copyright © 2016 Ravivarma Thirukamu. All rights reserved.
//

import UIKit

class SignUpController: UIViewController, UITextFieldDelegate
{

    @IBOutlet var topIGButton: NSLayoutConstraint!
    @IBOutlet var topViButton: NSLayoutConstraint!
  
    @IBOutlet var twtTopButton: NSLayoutConstraint!
 
   @IBOutlet var topFbButton: NSLayoutConstraint!
  
    
    @IBOutlet var innerView: UIView!
    @IBOutlet var topViewItems: UIView!
    @IBOutlet var viButtons: UIView!
    @IBOutlet var viTextField: UIView!
    
    @IBOutlet var twButton: UIButton!
    @IBOutlet var igButton: UIButton!
    @IBOutlet var fbButton: UIButton!
    @IBOutlet var createBtn: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    var delegate : SignInDelegate!
    
    var activityView = UIActivityIndicatorView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.viButtons.isHidden=true
        self.emailTextField.delegate=self
        self.passwordTextField.delegate=self
        self.confirmPasswordTextField.delegate=self

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

   
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true);
        
        showControllers()
        
    }
    
    func showControllers()
    {
        self.viButtons.isHidden = false
        self.topViButton.constant = self.view.bounds.size.height
        self.view.layoutIfNeeded()
        
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.5, options: [], animations: {
            self.topViButton.constant = 260.0
            self.view.layoutIfNeeded()
    
        },completion: nil)

        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations: {
            self.topFbButton.constant = 60.0
            self.view.layoutIfNeeded()

        }, completion: nil)
        
        
        UIView.animate(withDuration: 1.5, delay: 0.5, usingSpringWithDamping: 0.5,
                                  initialSpringVelocity: 0.5, options: [], animations: {
                                    
            self.twtTopButton.constant = 60.0
            self.view.layoutIfNeeded()
                                    
        }, completion: nil)
        
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations: {

            self.topIGButton.constant=18.0
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        self.emailTextField.attributedPlaceholder = NSAttributedString(string:"EMAIL", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Bold", size: 10)!])
        
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string:"PASSWORD", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Bold", size: 10)!])
        
        
        self.confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string:"CONFIRM PASSWORD", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Bold", size: 10)!])

    }
    
    @IBAction func createNewAccountTapped()
    {
        if emailTextField.text!.isEmpty && passwordTextField.text!.isEmpty
        {
            self.showAlertView("Stanley Korshok", AlertMessage: "Please enter Email Address and Password", AlertButtonTitle: "Ok")
        }
        else if emailTextField.text!.isEmpty
        {
            self.showAlertView("Stanley Korshok", AlertMessage: "Please enter Email Address", AlertButtonTitle: "Ok")
        }
        else if passwordTextField.text!.isEmpty
        {
            self.showAlertView("Stanley Korshok", AlertMessage: "Please enter password", AlertButtonTitle: "Ok")
        }
        else if(confirmPasswordTextField.text!.isEmpty)
        {
            self.showAlertView("Stanley Korshok", AlertMessage: "Please enter confirm password", AlertButtonTitle: "Ok")
        }
        else if(passwordTextField.text != confirmPasswordTextField.text)
        {
            self.showAlertView("Stanley Korshok", AlertMessage: "User password and confirm password are not same.", AlertButtonTitle: "Ok")
        }
            
        else
        {
            if !CommonHelper.isValidEmail(emailTextField.text!)
            {
                self.showAlertView("Stanley Korshok", AlertMessage: "Email address not correct.", AlertButtonTitle: "Ok")
            }
                
            else
            {
                
                //self.appDelegate.showAcitivyIndictor("Creating Account",subTitleString: "Please Wait!!")
                
                self.activityView.startAnimating()
                
                let urlString = String(format: "%@/UserRegistration", arguments: [Urls.stanleyKorshakUrl]);

                let request = NSMutableURLRequest(url: NSURL(string:urlString)! as URL)
                
                let session = URLSession.shared
                
                request.httpMethod = "POST"
                
                request.allHTTPHeaderFields = ["Content-Type":"application/json; charset=utf-8", Urls.AccessToken: Wardrober.shared().serviceAccessToken!]
                
                let requestDict = ["UserName":emailTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"Passwordinfo":passwordTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"Registrationtype":"1","Firstname":"","LastName":"","Mobilenumber":"","DeviceId":"123456789","DeviceToken":"123456ABC","DeviceType":"1"]
                
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
                                let (custID, message) =  CreateAccountHelper.createAccountResponseMessage(json as AnyObject?)
                                //print("messgae is",message!)
                                if custID != nil
                                {
                                    //self.appDelegate.hideAcitivyIndicator()
                                    self.activityView.stopAnimating()
                                    
                                    UserDefaults.standard.set(true, forKey: Constants.kUserSuccessfullySignedIn)
                                    UserDefaults.standard.setValue(custID, forKey: Constants.kSignedInUserID)
                                    UserDefaults.standard.synchronize()
                                    
                                    self.delegate.signUpControllerDidRegisterSuccessfully(self)
                                    
                                }
                                else
                                {
                                    UserDefaults.standard.set(false, forKey: Constants.kUserSuccessfullySignedIn)
                                    UserDefaults.standard.synchronize()
                                    
                                    //self.appDelegate.hideAcitivyIndicator()
                                    
                                    
                                    if message != nil
                                    {
                                        self.activityView.stopAnimating()
                                        
                                        self.showAlertView("Stanley Korshok", AlertMessage: message! as NSString, AlertButtonTitle: "Ok")
                                        
                                    }
                                    else
                                    {
                                        self.activityView.stopAnimating()
                                        
                                        self.showAlertView("Stanley Korshok", AlertMessage: "Unknown Error", AlertButtonTitle: "Ok")
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


    
      @IBAction func tapBacktButton(_: AnyObject)
      {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
      
        for aViewController in viewControllers
        {
            if(aViewController is SignInController)
            {
                self.navigationController!.popToViewController(aViewController, animated: true);
            }
        }
     }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }


}

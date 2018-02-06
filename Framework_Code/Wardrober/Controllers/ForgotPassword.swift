//
//  ForgotPassword.swift
//  Fashion180
//
//  Created by Srinivas Peddinti on 10/19/16.
//  Copyright © 2016 MobiwareInc. All rights reserved.
//

import UIKit

class ForgotPassword: UIViewController
{

    @IBOutlet weak var emailTextField:UITextField!;
    @IBOutlet weak var forgotBtn:UIButton!

    @IBOutlet var submitButtonBottomConstant: NSLayoutConstraint!
    
    var activityView = UIActivityIndicatorView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.submitButtonBottomConstant.constant = self.submitButtonBottomConstant.constant - 325
        self.view.layoutIfNeeded()
        
        // Do any additional setup after loading the view.
        self.title = "Forgot Password";
        
        //register for push notifications
       
        self.emailTextField.attributedPlaceholder = NSAttributedString(string:"EMAIL", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Bold", size: 10)!])

        forgotBtn.layer.masksToBounds = true
        forgotBtn.layer.cornerRadius = 20.0
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.color = UIColor.black
        activityView.center = self.view.center
        
        self.view.addSubview(activityView)


    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true);
        
        UIView.animate(withDuration: 2.0, delay: 0.3, usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 0.5, options: [], animations: {
           
        self.submitButtonBottomConstant.constant = self.view.frame.size.height - 300
        self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    //#MARK:-- BACKBUTTON ACTION
    @IBAction func backBtnTapped()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        emailTextField.resignFirstResponder();
        return true;
    }
    
    //#MARK:-- FACEBOOK ACTION
    @IBAction func submitBtnTapped()
    {
        emailTextField.resignFirstResponder();
        if emailTextField.text!.isEmpty
        {
            self.showAlertView("Stanley Korshok", AlertMessage: "Please enter email address.", AlertButtonTitle: "Ok")
        }
        else
        {
            if !CommonHelper.isValidEmail(emailTextField.text!)
            {
                self.showAlertView("Stanley Korshok", AlertMessage: "Please enter valid email address.", AlertButtonTitle: "Ok")
                
                return;
            }
            
            //self.appDelegate.showAcitivyIndictor("Sending...",subTitleString: "")
            
            self.activityView.startAnimating()
            
            let urlString = String(format: "%@/UserForgotPassword", arguments: [Urls.stanleyKorshakUrl]);

            let request = NSMutableURLRequest(url: NSURL(string:urlString)! as URL)
            
            let session = URLSession.shared
            
            request.httpMethod = "POST"
            
            request.allHTTPHeaderFields = ["Content-Type":"application/json; charset=utf-8", Urls.AccessToken: Wardrober.shared().serviceAccessToken!]
            
            let requestDict = ["UserName":emailTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)];
            
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
                            let message =  LoginHelper.forgotPassResponseMessage(json as AnyObject?)
                            
                            if message != nil
                            {
                                if message == "Your password has been sent to the email ID entered"
                                {
                                    self.activityView.stopAnimating()
                                    
                                    self.emailTextField.text = nil
                                    self.showAlertView("Stanley Korshok", AlertMessage: "Your password has been sent to your email ID", AlertButtonTitle: "Ok")
                                }
                                    
                                else
                                {
                                    self.activityView.stopAnimating()
                                    self.showAlertView("Stanley Korshok", AlertMessage: "User doesn't exist", AlertButtonTitle: "Ok")
                                    
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
    
    func showAlertView(_ AlertTitle: NSString, AlertMessage:NSString, AlertButtonTitle:NSString)
    {
        
        let alert=UIAlertController(title: AlertTitle as String, message: AlertMessage as String, preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: AlertButtonTitle as String, style: UIAlertActionStyle.cancel, handler: nil));
        self.present(alert, animated: true, completion: nil)
    }
}

//
//  AddressContainerView.swift
//  Wardrober
//
//  Created by Saraschandra on 12/01/18.
//  Copyright © 2018 Mobiware. All rights reserved.
//

import UIKit

class AddNewTVC: UITableViewController
{

    @IBOutlet var firstNameTF : FloatLabelTextField!
    
    @IBOutlet var lastNameTF : FloatLabelTextField!
    
    @IBOutlet var cmpnyNameTF : FloatLabelTextField!
    
    @IBOutlet var mobileNumberTF : FloatLabelTextField!
    
    @IBOutlet var pinCodeTF : FloatLabelTextField!
    
    @IBOutlet var addressLine1TF : FloatLabelTextField!
    
    @IBOutlet var ciytTF : FloatLabelTextField!
    
    @IBOutlet var stateTF : FloatLabelTextField!
    
    //var delegate : AddressContainerViewDelegate!
    @IBOutlet var saveBtn: UIButton!
    
    var doneToolbar = UIToolbar()

    var fromWhichController : String!
    
    var titleString : String!
    
    var editableAddressDict : [String : Address]!
    
    var shippingAddressID : String!
    
    let address = Address()
    
    var activityView = UIActivityIndicatorView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Done toolbar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.tapGestureRecognized))
        doneToolbar = Constants.getDoneToolbar(dismissBtn: doneButton)
        
        mobileNumberTF.inputAccessoryView = doneToolbar
        pinCodeTF.inputAccessoryView = doneToolbar
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.color = UIColor.black
        activityView.center = self.view.center
        
        self.view.addSubview(activityView)
        
        if titleString == "EDIT ADDRESS"
        {
            saveBtn.setTitle("UPDATE",for: .normal)
        }
        else
        {
            saveBtn.setTitle("SAVE",for: .normal)
        }
        
        if editableAddressDict != nil
        {
            var editableAddress =  Address()
            
            editableAddress = editableAddressDict["EditableAddress"]!
            
            firstNameTF.text! = editableAddress.firstName
            lastNameTF.text! = editableAddress.lastName
            cmpnyNameTF.text! = editableAddress.compyName
            addressLine1TF.text! = editableAddress.streetAddress
            ciytTF.text! = editableAddress.city
            stateTF.text! = editableAddress.state
            mobileNumberTF.text! = editableAddress.phone
            pinCodeTF.text! = editableAddress.zip
            shippingAddressID = editableAddress.shippingAddressID
        }
       
    }
    
    @objc func tapGestureRecognized()
    {
        self.mobileNumberTF.resignFirstResponder()
        self.pinCodeTF.resignFirstResponder()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 8
        }
        else if section == 1
        {
            return 3
        }
        return 0
    }
    
    
    @IBAction func saveButtonTapped(_ sender : UIButton)
    {
        //VALIDATION TO CHECK FIRST NAME IS NOT NIL
        if firstNameTF.text!.isEmpty
        {
            self.showAlertView("Stanley Korshok", AlertMessage: "Please enter first name", AlertButtonTitle: "Ok")
        }
            
            //VALIDATION TO CHECK LAST NAME IS NOT NIL
        else if lastNameTF.text!.isEmpty
        {
            self.showAlertView("Stanley Korshok", AlertMessage: "Please enter last name", AlertButtonTitle: "Ok")
        }
            //VALIDATION TO CHECK MOBILE NUMBER IS NOT NIL
        else if mobileNumberTF.text!.isEmpty
        {
            self.showAlertView("Stanley Korshok", AlertMessage: "Please enter mobile number", AlertButtonTitle: "Ok")
        }
            //VALIDATION TO CHECK COMPANY NAME IS NOT NIL
        else if cmpnyNameTF.text!.isEmpty
        {
            self.showAlertView("Stanley Korshok", AlertMessage: "Please enter company name", AlertButtonTitle: "Ok")
        }
            //VALIDATION TO CHECK ADDRESS IS NOT NIL
        else if addressLine1TF.text!.isEmpty
        {
            self.showAlertView("Stanley Korshok", AlertMessage: "Please enter address", AlertButtonTitle: "Ok")
        }
            //VALIDATION TO CITY IS NOT NIL
        else if ciytTF.text!.isEmpty
        {
            self.showAlertView("Stanley Korshok", AlertMessage: "Please enter city", AlertButtonTitle: "Ok")
        }
            //VALIDATION TO STATE IS NOT NIL
        else if stateTF.text!.isEmpty
        {
            self.showAlertView("Stanley Korshok", AlertMessage: "Please enter state", AlertButtonTitle: "Ok")
        }
            //VALIDATION TO PIN CODE IS NOT NIL
        else if pinCodeTF.text!.isEmpty
        {
            self.showAlertView("Stanley Korshok", AlertMessage: "Please enter pin code", AlertButtonTitle: "Ok")
        }
        else
        {
            //self.appDelegate.showAcitivyIndictor("Signing In",subTitleString: "Please Wait!!")
            
            self.activityView.startAnimating()
            
            let urlString : String!
            
            let requestDict : [String : String]!
            
            let userCustomerId = UserDefaults.standard.string(forKey: Constants.kSignedInUserID)
            
            if titleString == "EDIT ADDRESS"
            {
                urlString = String(format: "%@/UpdateShippingAddress", arguments: [Urls.stanleyKorshakUrl])
                
                requestDict = ["FirstName":firstNameTF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"LastName":lastNameTF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"Phone":mobileNumberTF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"CompanyName":cmpnyNameTF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"StreetAddress":addressLine1TF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"City":ciytTF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"State":stateTF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"ZIP":pinCodeTF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"Country":"India","CustomerID": userCustomerId!,"ShippingAddressid": shippingAddressID]
            }
            else
            {
                urlString = String(format: "%@/AddShippingAddress", arguments: [Urls.stanleyKorshakUrl])
                
                requestDict = ["FirstName":firstNameTF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"LastName":lastNameTF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"Phone":mobileNumberTF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"CompanyName":cmpnyNameTF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"StreetAddress":addressLine1TF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"City":ciytTF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"State":stateTF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"ZIP":pinCodeTF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"Country":"India","CustomerID": userCustomerId!]
            }
            
            FAServiceHelper().post(url: urlString, parameters: requestDict as NSDictionary  , completion : { (success : Bool?, message : String?, responseObject : AnyObject?) in
                
                self.activityView.stopAnimating()
                
                guard success == true else
                {
                    let alert=UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert);
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                guard responseObject == nil else
                {
                    if (self.fromWhichController == "HomeContainerVC")
                    {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "SavedDeliveryAddressFromHomeContainerVC"), object: nil)

                    }
                    else
                    {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "SavedDeliveryAddressFromDefaultAddressVC"), object: nil)
                        
                    }
                    return
                }
                
            })
        }
    }
    

    @IBAction func cancelButtonTapped(_ sender : UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "CancelAction"), object: nil)
    }
    
    @IBAction func deleteAddressTapped(_ sender : UIButton)
    {
        
    }
    
    func showAlertView(_ AlertTitle: NSString, AlertMessage:NSString, AlertButtonTitle:NSString)
    {
        let alert=UIAlertController(title: AlertTitle as String, message: AlertMessage as String, preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: AlertButtonTitle as String, style: UIAlertActionStyle.cancel, handler: nil));
        self.present(alert, animated: true, completion: nil)
    }
}

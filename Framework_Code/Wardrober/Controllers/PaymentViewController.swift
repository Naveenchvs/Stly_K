//
//  PaymentViewController.swift
//  FoodBit
//
//  Copyright (c) 2014 Mobiware. All rights reserved.
//

import UIKit

extension String
{
    func isValidEmail() -> Bool
    {
        let regex = try? NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .caseInsensitive)
        return regex!.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
    }
}

class PaymentViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet weak var paymentScrollView: UIScrollView!
    
    @IBOutlet weak var ContentViewControl: UIControl!
    
    @IBOutlet var cashOnDeliveryView: UIView!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet var cashOnDeliveryBtn: UIButton!
    @IBOutlet var cashOnDeliverySubmitBtn: UIButton!
    
    @IBOutlet var bottomView: UIView!

    @IBOutlet var paymentView: UIView!
    
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet var visaBtn: UIButton!
    @IBOutlet var masterCardBtn: UIButton!
    @IBOutlet var discoverBtn: UIButton!
    
    @IBOutlet weak var expirationDateMMTextField: UITextField!
    @IBOutlet weak var expirationDateYYTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var cardHolderNameTextField: UITextField!
    
    
    @IBOutlet var addressView: UIView!

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateProvinceTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var zipPostalCodeTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var payButton: UIButton!
    
    
    //@IBOutlet weak var visaRadioButton: UIButton!
    //@IBOutlet weak var masterCardRadioButton: UIButton!
    //@IBOutlet weak var amexRadioButton: UIButton!
    
    @IBOutlet var pickerView: UIPickerView!
    
    //@IBOutlet weak var cardNumberlabel: UILabel!
    //@IBOutlet weak var cardTypeLabel: UILabel!
    //@IBOutlet weak var expirationDateLabel: UILabel!
    //@IBOutlet weak var cvvLabel: UILabel!
    //@IBOutlet weak var address1Label: UILabel!
    //@IBOutlet weak var cityLabel: UILabel!
    //@IBOutlet weak var stateProvinceLabel: UILabel!
    //@IBOutlet weak var zipPostalCodeLabel: UILabel!
    //@IBOutlet weak var phoneLabel: UILabel!
    
    var activeTextField: UITextField!
    
    let monthsArray = NSArray(array: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"])
    
    var yearsArray:[NSString] = []
    
    //var countriesDict : Dictionary<String, Array<String>>  = ["USA":["Texas", "Alabama", "Alaska", "California", "Virginia", "Florida"], "India" : ["Telangana", "Delhi", "Maharashtra", "Tamil Nadu", "Kolkata"]]
    
    var amount = ""
    
    var selectedAddDict : [String : Address]!
    
    var address : Address =  Address()

    //var paymentParams  =  Dictionary<String, AnyObject>()
    

    //@IBOutlet var selectDeliveryorProfileAddress: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        bottomView.addGestureRecognizer(tapGesture)
        bottomView.isUserInteractionEnabled = true
       
        expirationDateMMTextField.inputView = pickerView
        expirationDateYYTextField.inputView = pickerView
        
        self.totalAmountLabel.text = "Total amount: \(amount)"

        self.setDatesArray()
        
        self.didClickVisaButton(visaBtn)
        
        self.address = selectedAddDict["selectedDeliveryAddress"]!
        
        self.addressTextField.text = self.address.streetAddress
        self.cityTextField.text = self.address.city
        self.stateProvinceTextField.text = self.address.state
        self.countryTextField.text = self.address.country
        self.zipPostalCodeTextField.text = self.address.zip
        self.phoneTextField.text = self.address.phone
        
        
        // register for keyboard WillShow notifications
        NotificationCenter.default.addObserver(self, selector: #selector(PaymentViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        // register for keyboard WillHide notifications
        NotificationCenter.default.addObserver(self, selector: #selector(PaymentViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer)
    {
        cardNumberTextField.resignFirstResponder()
        expirationDateMMTextField.resignFirstResponder()
        expirationDateYYTextField.resignFirstResponder()
        cvvTextField.resignFirstResponder()
        cardHolderNameTextField.resignFirstResponder()
        
        addressTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        countryTextField.resignFirstResponder()
        stateProvinceTextField.resignFirstResponder()
        zipPostalCodeTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
    }
    
    func setDatesArray()
    {
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.year, from: date)
        
        let hour = components.year
        
        var index: Int = 0
        
        if let hourList = hour
        {
            for i in hourList...2030
            {
                yearsArray.insert(String(i) as NSString, at: index)
                index += 1
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.paymentScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        self.paymentScrollView.contentInset = contentInset
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.paymentScrollView.contentInset = contentInset
        
    }
    
   
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        self.dismiss(animated: true) {
            
        }
    }
  
    
    @IBAction func didClickVisaButton(_ sender: AnyObject)
    {
        visaBtn.isSelected = false;
        masterCardBtn.isSelected = false;
        discoverBtn.isSelected = false;
        
        visaBtn.isSelected = true;
        
        self.visaBtn.setImage(UIImage(named: "btn_paymentgateway_checked.png"), for: .normal)
        self.masterCardBtn.setImage(UIImage(named: "btn_paymentgateway_Notchecked.png"), for: .normal)
        self.discoverBtn.setImage(UIImage(named: "btn_paymentgateway_Notchecked.png"), for: .normal)
    }
    
    @IBAction func didClickMasterCardButton(_ sender: AnyObject)
    {
        visaBtn.isSelected = false;
        masterCardBtn.isSelected = false;
        discoverBtn.isSelected = false;
        
        masterCardBtn.isSelected = true;
        
        self.visaBtn.setImage(UIImage(named: "btn_paymentgateway_Notchecked.png"), for: .normal)
        self.masterCardBtn.setImage(UIImage(named: "btn_paymentgateway_checked.png"), for: .normal)
        self.discoverBtn.setImage(UIImage(named: "btn_paymentgateway_Notchecked.png"), for: .normal)
    }
    
    @IBAction func didClickDiscoverButton(_ sender: AnyObject)
    {
        visaBtn.isSelected = false;
        masterCardBtn.isSelected = false;
        discoverBtn.isSelected = false;
        
        discoverBtn.isSelected = true;
        
        self.visaBtn.setImage(UIImage(named: "btn_paymentgateway_Notchecked.png"), for: .normal)
        self.masterCardBtn.setImage(UIImage(named: "btn_paymentgateway_Notchecked.png"), for: .normal)
        self.discoverBtn.setImage(UIImage(named: "btn_paymentgateway_checked.png"), for: .normal)
    }
    
    //UITextFields Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeTextField = textField;
        
        if(textField.tag != 0 & 103)
        {
            pickerView.reloadAllComponents()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if activeTextField.tag == 103
        {
            guard let text = textField.text else { return true }
            
            let newLength = text.utf16.count + string.utf16.count - range.length
            return newLength <= 16
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    //UIPickerView Delegate Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if(activeTextField.tag == 101)
        {
            return monthsArray.count
        }
        if(activeTextField.tag == 102)
        {
            return yearsArray.count
        }
        
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if(activeTextField.tag == 101)
        {
            return monthsArray[row] as! NSString as String
        }
        
        if(activeTextField.tag == 102)
        {
            return yearsArray[row] as NSString as String
        }
    
        return "Some Name"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(activeTextField.tag == 101)
        {
            var monthString : NSString = String(row+1) as NSString
            
            if(monthString.length == 1)
            {
                monthString = ("0"+(monthString as String)) as NSString
            }
            
            activeTextField.text = monthString as String
        }
        else if(activeTextField.tag == 102)
        {
            let yearString : NSString = yearsArray[row]
            activeTextField.text = yearString.substring(with: NSRange(location: 2, length: 2))
        }
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    

    /*@IBAction func didClickBackgroundView(_ sender: AnyObject)
    {
        self.view.endEditing(true);
    }*/
    
    /*func changeMandatoryLabelTextColor(_ label:UILabel)
     {
     let attributedString = NSMutableAttributedString(string: label.text!)
     attributedString .addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range:NSMakeRange(0, 1))
     label.attributedText = attributedString;
     }*/
    
    
    /*@IBAction func didClickedDeliveryorProfileAddress(_ sender: AnyObject)
     {
     self.view.endEditing(true);
     
     let selectDeliveryorProfileAddress: UIButton = sender as! UIButton;
     if(selectDeliveryorProfileAddress.tag==20)
     {
     //selectDeliveryorProfileAddress check on
     
     selectDeliveryorProfileAddress.setImage(UIImage(named: "btn_paymentgateway_checked.png"), for: UIControlState())
     selectDeliveryorProfileAddress.tag=21;
     
     let isAnyUserLoggedIn = UserDefaults.standard.bool(forKey: "user_logged_in") as Bool
     let _ = UserDefaults.standard.object(forKey: "login_type") as! String
     
     if(isAnyUserLoggedIn == true)
     {
     let addressLine1 = UserDefaults.standard.object(forKey: "customerAddressLine1Def") as! String
     
     let addressLine2 = UserDefaults.standard.object(forKey: "customerAddressLine2Def") as! String
     
     if (addressLine1.count == 0 && addressLine2.count == 0)
     {
     addressTextField.text = ""
     }
     else if (addressLine1.count > 0 && addressLine2.count == 0)
     {
     addressTextField.text = "\(addressLine1)"
     }
     else if (addressLine1.count == 0 && addressLine2.count > 0)
     {
     addressTextField.text = "\(addressLine2)"
     }
     else
     {
     addressTextField.text = "\(addressLine1), \(addressLine2)"
     }
     
     
     
     cityTextField.text = UserDefaults.standard.object(forKey: "customerCityDef") as? String
     
     countryTextField.text = UserDefaults.standard.object(forKey: "customerCountryDef") as? String
     
     stateProvinceTextField.text = UserDefaults.standard.object(forKey: "customerStateDef") as? String
     
     zipPostalCodeTextField.text = UserDefaults.standard.object(forKey: "customerZipCodeDef") as? String
     
     phoneTextField.text = UserDefaults.standard.object(forKey: "phoneNumberDef") as? String
     
     }
     else
     {
     print("not logged in user")
     
     selectDeliveryorProfileAddress.setImage(UIImage(named: "btn_paymentgateway_Notchecked.png"), for: UIControlState())
     
     let alert = UIAlertView(title: "FoodBit", message:
     "Your not registered with FoodBit App. So you will not get your address details below. You have to enter manually.", delegate: nil, cancelButtonTitle: "OK")
     
     alert.show()
     
     
     }
     
     }
     else
     {
     selectDeliveryorProfileAddress.setImage(UIImage(named: "btn_paymentgateway_Notchecked.png"), for: UIControlState())
     selectDeliveryorProfileAddress.tag=20;
     
     addressTextField.text = ""
     
     cityTextField.text = ""
     
     countryTextField.text = ""
     
     stateProvinceTextField.text = ""
     
     zipPostalCodeTextField.text = ""
     
     phoneTextField.text = ""
     }
     
     }*/
    
    /*func showErrorAlert(_ alertMsg : String) -> Void
    {
        
        
    }
    
    func validatePaymentForm() -> Bool
    {
        var status:Bool=true;
        
        let commonValidation = CommonValidation()
        
        if(self.cardNumberTextField.text == nil || self.cardNumberTextField.text=="")
        {
            status=false;
            self.showErrorAlert("Please enter Card Number");
            //firstNameTextField.becomeFirstResponder();
        }
        else if(commonValidation.isValidNumeric(self.cardNumberTextField.text!) == false)
        {
            status=false;
            self.showErrorAlert("Card Number should be numeric");
        }
        else if(self.expirationDateMMTextField.text == nil || self.expirationDateMMTextField.text=="")
        {
            status=false;
            self.showErrorAlert("Please enter Month for the Card expiration date");
            //lastNameTextField.becomeFirstResponder();
        }
        else if(self.expirationDateYYTextField.text == nil || self.expirationDateYYTextField.text=="")
        {
            status=false;
            self.showErrorAlert("Please enter Year for the Card expiration date");
        }
        else if(self.cvvTextField.text == nil || self.cvvTextField.text=="")
        {
            status=false;
            self.showErrorAlert("Please enter CVV number for the Card");
        }
        else if(commonValidation.isValidNumeric(self.cvvTextField.text!) == false)
        {
            status=false;
            self.showErrorAlert("CVV Number should be numeric");
        }
        else if(self.cardHolderNameTextField.text == nil || self.cardHolderNameTextField.text=="")
        {
            status=false;
            self.showErrorAlert("Please enter Card Holder's Name");
        }
        else if(self.addressTextField.text == nil || self.addressTextField.text=="")
        {
            status=false;
            self.showErrorAlert("Please enter Address Line 1 field");
        }
        else if(self.cityTextField.text == nil || self.cityTextField.text=="")
        {
            status=false;
            self.showErrorAlert("Please enter City");
        }
        else if(self.countryTextField.text == nil || self.countryTextField.text=="")
        {
            status=false;
            self.showErrorAlert("Please enter Country");
        }
        else if(self.stateProvinceTextField.text == nil || self.stateProvinceTextField.text=="")
        {
            status=false;
            self.showErrorAlert("Please enter State");
            
        }
        else if(self.zipPostalCodeTextField.text == nil || self.zipPostalCodeTextField.text=="")
        {
            status=false;
            self.showErrorAlert("Please enter Zip");
        }
        else if(commonValidation.isValidNumeric(self.zipPostalCodeTextField.text!) == false)
        {
            status=false;
            self.showErrorAlert("Zip Code should be numeric");
        }
            
        else if(self.phoneTextField.text == nil || self.phoneTextField.text=="")
        {
            status=false;
            self.showErrorAlert("Please enter Phone Number");
        }
        else if(commonValidation.isValidNumeric(self.phoneTextField.text!) == false)
        {
            status=false;
            self.showErrorAlert("Phone number should be numeric");
        }
        
        return status;
        
    }

    @IBAction func payButtonTapped(_ sender: AnyObject)
    {
        
    }*/
    
   
    
    

}

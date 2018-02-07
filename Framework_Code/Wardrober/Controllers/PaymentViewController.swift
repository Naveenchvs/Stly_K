//
//  PaymentViewController.swift
//  FoodBit
//
//  Copyright (c) 2014 Mobiware. All rights reserved.
//

import UIKit

import AcceptSDK


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}



//let kClientName = "8sjbvNU52Lfr"
//let kClientKey  = "7356sB68Yj6gv5qTzVX69GHrGv3fLBPypEjyRQg9QCB4cKeqRjJ3j58x9VqpLJPx"

let kAcceptSDKDemoCreditCardLength:Int = 16
let kAcceptSDKDemoCreditCardLengthPlusSpaces:Int = (kAcceptSDKDemoCreditCardLength + 3)
let kAcceptSDKDemoExpirationLength:Int = 4
let kAcceptSDKDemoExpirationMonthLength:Int = 2
let kAcceptSDKDemoExpirationYearLength:Int = 2
let kAcceptSDKDemoExpirationLengthPlusSlash:Int = kAcceptSDKDemoExpirationLength + 1
let kAcceptSDKDemoCVV2Length:Int = 4

let kAcceptSDKDemoCreditCardObscureLength:Int = (kAcceptSDKDemoCreditCardLength - 4)

let kAcceptSDKDemoSpace:String = " "
let kAcceptSDKDemoSlash:String = "/"


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
    
    
    @IBOutlet weak var cardHolderNameTextField: UITextField!
    
    
    @IBOutlet var addressView: UIView!

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateProvinceTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var zipPostalCodeTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    
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
    
    @IBOutlet weak var cardNumberTextField:UITextField!
    @IBOutlet weak var expirationMonthTextField:UITextField!
    @IBOutlet weak var expirationYearTextField:UITextField!
    @IBOutlet weak var cardVerificationCodeTextField:UITextField!
    @IBOutlet weak var payButton:UIButton!
    @IBOutlet weak var activityIndicatorAcceptSDKDemo:UIActivityIndicatorView!
    @IBOutlet weak var textViewShowResults:UITextView!
    
    fileprivate var cardNumber:String!
    fileprivate var cardExpirationMonth:String!
    fileprivate var cardExpirationYear:String!
    fileprivate var cardVerificationCode:String!
    fileprivate var cardNumberBuffer:String!
    var activityView = UIActivityIndicatorView()
    
    var selecetedShippingAddresses : [String : Address]!
    
    var kClientName : String = ""
    var kClientKey : String = ""
    
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
       
        /*expirationDateMMTextField.inputView = pickerView
        expirationDateYYTextField.inputView = pickerView*/
        
        self.totalAmountLabel.text = "Total amount: \(amount)"

        //self.setDatesArray()
        
        //self.didClickVisaButton(visaBtn)
        
        self.address = selectedAddDict["selectedDeliveryAddress"]!
        
       /* self.addressTextField.text = self.address.streetAddress
        self.cityTextField.text = self.address.city
        self.stateProvinceTextField.text = self.address.state
        self.countryTextField.text = self.address.country
        self.zipPostalCodeTextField.text = self.address.zip
        self.phoneTextField.text = self.address.phone
        */
        
        // register for keyboard WillShow notifications
        NotificationCenter.default.addObserver(self, selector: #selector(PaymentViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        // register for keyboard WillHide notifications
        NotificationCenter.default.addObserver(self, selector: #selector(PaymentViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.color = UIColor.black
        activityView.center = self.view.center
        
        self.getPaymetAuthenticationCredentials()
        self.setUIControlsTagValues()
        self.initializeUIControls()
        self.initializeMembers()
        self.updateTokenButton(false)
    }
    
    func getPaymetAuthenticationCredentials()
    {
        self.activityView.startAnimating()
        
        let urlString = String(format: "%@/GetAuthenticationCredentials", arguments: [Urls.stanleyKorshakUrl]);
        
        FAServiceHelper().get(url: urlString, completion : { (success : Bool?, message : String?, responseObject : AnyObject?) in
            
            self.activityView.stopAnimating()
            
            guard success == true else
            {
                
                return
            }
            
            guard responseObject == nil else
            {
                let paymentCredentials : [Credentials] =  PaymentCredentialsHelper.getAuthenticationHelper(responseObject! as AnyObject?)!
                let paymentKeys  = paymentCredentials[0]
                
                self.kClientName = paymentKeys.apiLoginId
                self.kClientKey = paymentKeys.publicClientKey
                
                return
                
            }
        })
        
        
        
    }
    func setUIControlsTagValues() {
        
        self.cardNumberTextField.tag = 1
        self.expirationMonthTextField.tag = 2
        self.expirationYearTextField.tag = 3
        self.cardVerificationCodeTextField.tag = 4
        self.addressTextField.tag = 5
        self.cityTextField.tag = 6
        self.stateProvinceTextField.tag = 7
        self.countryTextField.tag = 8
        self.zipPostalCodeTextField.tag = 9
        self.phoneTextField.tag = 10
        
    }
    
    func initializeUIControls() {
        self.cardNumberTextField.text = ""
        self.expirationMonthTextField.text = ""
        self.expirationYearTextField.text = ""
        self.cardVerificationCodeTextField.text = ""
        self.textChangeDelegate(self.cardNumberTextField)
        self.textChangeDelegate(self.expirationMonthTextField)
        self.textChangeDelegate(self.expirationYearTextField)
        self.textChangeDelegate(self.cardVerificationCodeTextField)
        
        self.cardNumberTextField.delegate = self
        self.expirationMonthTextField.delegate = self
        self.expirationYearTextField.delegate = self
        self.cardVerificationCodeTextField.delegate = self
    }
    
    func validInputs() -> Bool {
        var inputsAreOKToProceed = false
        
        let validator = AcceptSDKCardFieldsValidator()
        
        if (validator.validateSecurityCodeWithString(self.cardVerificationCodeTextField.text!) && validator.validateExpirationDate(self.expirationMonthTextField.text!, inYear: self.expirationYearTextField.text!) && validator.validateCardWithLuhnAlgorithm(self.cardNumberBuffer)) {
            inputsAreOKToProceed = true
        }
        
        return inputsAreOKToProceed
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField:UITextField) -> Bool {
        
        activeTextField = textField
        return true
    }
    
    func isMaxLength(_ textField:UITextField) -> Bool {
        var result = false
        
        if (textField.tag == self.cardNumberTextField.tag && textField.text?.characters.count > kAcceptSDKDemoCreditCardLengthPlusSpaces)
        {
            result = true
        }
        
        if (textField == self.expirationMonthTextField && textField.text?.characters.count > kAcceptSDKDemoExpirationMonthLength)
        {
            result = true
        }
        
        if (textField == self.expirationYearTextField && textField.text?.characters.count > kAcceptSDKDemoExpirationYearLength)
        {
            result = true
        }
        if (textField == self.cardVerificationCodeTextField && textField.text?.characters.count > kAcceptSDKDemoCVV2Length)
        {
            result = true
        }
        
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = true
        
        switch (textField.tag)
        {
        case 1:
            if (string.characters.count > 0)
            {
                if (self.isMaxLength(textField)) {
                    return false
                }
                
                self.cardNumberBuffer = String(format: "%@%@", self.cardNumberBuffer, string)
            }
            else
            {
                if (self.cardNumberBuffer.characters.count > 1)
                {
                    let length = self.cardNumberBuffer.characters.count - 1
                    
                    //self.cardNumberBuffer = self.cardNumberBuffer[self.cardNumberBuffer.index(self.cardNumberBuffer.startIndex, offsetBy: 0)...self.cardNumberBuffer.index(self.cardNumberBuffer.startIndex, offsetBy: length-1)]
                    
                    self.cardNumberBuffer = String(self.cardNumberBuffer[self.cardNumberBuffer.index(self.cardNumberBuffer.startIndex, offsetBy: 0)...self.cardNumberBuffer.index(self.cardNumberBuffer.startIndex, offsetBy: length - 1)])
                }
                else
                {
                    self.cardNumberBuffer = ""
                }
            }
            self.formatCardNumber(textField)
            return false
        case 2:
            
            if (string.characters.count > 0) {
                if (self.isMaxLength(textField)) {
                    return false
                }
            }
            
            break
        case 3:
            
            if (string.characters.count > 0) {
                if (self.isMaxLength(textField)) {
                    return false
                }
            }
            
            break
        case 4:
            
            if (string.characters.count > 0) {
                if (self.isMaxLength(textField)) {
                    return false
                }
            }
            
            break
            
        default:
            break
        }
        
        return result
    }
    
    func formatCardNumber(_ textField:UITextField) {
        var value = String()
        
        if textField == self.cardNumberTextField {
            let length = self.cardNumberBuffer.characters.count
            
            for (i, _) in self.cardNumberBuffer.characters.enumerated() {
                
                // Reveal only the last character.
                if (length <= kAcceptSDKDemoCreditCardObscureLength) {
                    if (i == (length - 1)) {
                        let charIndex = self.cardNumberBuffer.index(self.cardNumberBuffer.startIndex, offsetBy: i)
                        let tempStr = String(self.cardNumberBuffer.characters.suffix(from: charIndex))
                        //let singleCharacter = String(tempStr.characters.first)
                        
                        value = value + tempStr
                    } else {
                        value = value + "●"
                    }
                } else {
                    if (i < kAcceptSDKDemoCreditCardObscureLength) {
                        value = value + "●"
                    } else {
                        let charIndex = self.cardNumberBuffer.index(self.cardNumberBuffer.startIndex, offsetBy: i)
                        let tempStr = String(self.cardNumberBuffer.characters.suffix(from: charIndex))
                        //let singleCharacter = String(tempStr.characters.first)
                        //let singleCharacter = String(tempStr.characters.suffix(1))
                        
                        value = value + tempStr
                        break
                    }
                }
                
                //After 4 characters add a space
                if (((i + 1) % 4 == 0) && (value.characters.count < kAcceptSDKDemoCreditCardLengthPlusSpaces)) {
                    value = value + kAcceptSDKDemoSpace
                }
            }
        }
        
        textField.text = value
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let validator = AcceptSDKCardFieldsValidator()
        
        switch (textField.tag)
        {
            
        case 1:
            
            self.cardNumber = self.cardNumberBuffer
            
            let luhnResult = validator.validateCardWithLuhnAlgorithm(self.cardNumberBuffer)
            
            if ((luhnResult == false) || (textField.text?.characters.count < AcceptSDKCardFieldsValidatorConstants.kInAppSDKCardNumberCharacterCountMin))
            {
                self.cardNumberTextField.textColor = UIColor.red
            }
            else
            {
                self.cardNumberTextField.textColor = self.darkBlueColor() //[UIColor greenColor]
            }
            
            if (self.validInputs())
            {
                self.updateTokenButton(true)
            }
            else
            {
                self.updateTokenButton(false)
            }
            
            break
        case 2:
            self.validateMonth(textField)
            if let expYear = self.expirationYearTextField.text {
                self.validateYear(expYear)
            }
            
            break
        case 3:
            
            self.validateYear(textField.text!)
            
            break
        case 4:
            
            self.cardVerificationCode = textField.text
            
            if (validator.validateSecurityCodeWithString(self.cardVerificationCodeTextField.text!))
            {
                self.cardVerificationCodeTextField.textColor = self.darkBlueColor()
            }
            else
            {
                self.cardVerificationCodeTextField.textColor = UIColor.red
            }
            
            if (self.validInputs())
            {
                self.updateTokenButton(true)
            }
            else
            {
                self.updateTokenButton(false)
            }
            
            break
            
        default:
            break
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if (textField == self.cardNumberTextField)
        {
            self.cardNumberBuffer = String()
        }
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func validateYear(_ textFieldText: String) {
        
        self.cardExpirationYear = textFieldText
        let validator = AcceptSDKCardFieldsValidator()
        
        let newYear = Int(textFieldText)
        if ((newYear >= validator.cardExpirationYearMin())  && (newYear <= AcceptSDKCardFieldsValidatorConstants.kInAppSDKCardExpirationYearMax))
        {
            self.expirationYearTextField.textColor = self.darkBlueColor() //[UIColor greenColor]
        }
        else
        {
            self.expirationYearTextField.textColor = UIColor.red
        }
        
        if (self.expirationYearTextField.text?.characters.count == 0)
        {
            return
        }
        if (self.expirationMonthTextField.text?.characters.count == 0)
        {
            return
        }
        if (validator.validateExpirationDate(self.expirationMonthTextField.text!, inYear: self.expirationYearTextField.text!))
        {
            self.expirationMonthTextField.textColor = self.darkBlueColor()
            self.expirationYearTextField.textColor = self.darkBlueColor()
        }
        else
        {
            self.expirationMonthTextField.textColor = UIColor.red
            self.expirationYearTextField.textColor = UIColor.red
        }
        
        if (self.validInputs())
        {
            self.updateTokenButton(true)
        }
        else
        {
            self.updateTokenButton(false)
        }
    }
    
    func validateMonth(_ textField: UITextField) {
        
        self.cardExpirationMonth = textField.text
        
        if (self.expirationMonthTextField.text?.characters.count == 1)
        {
            if ((textField.text == "0") == false) {
                self.expirationMonthTextField.text = "0" + self.expirationMonthTextField.text!
            }
        }
        
        let newMonth = Int(textField.text!)
        
        if ((newMonth >= AcceptSDKCardFieldsValidatorConstants.kInAppSDKCardExpirationMonthMin)  && (newMonth <= AcceptSDKCardFieldsValidatorConstants.kInAppSDKCardExpirationMonthMax))
        {
            self.expirationMonthTextField.textColor = self.darkBlueColor() //[UIColor greenColor]
            
        }
        else
        {
            self.expirationMonthTextField.textColor = UIColor.red
        }
        
        if (self.validInputs())
        {
            self.updateTokenButton(true)
        }
        else
        {
            self.updateTokenButton(false)
        }
    }
    
    func textChangeDelegate(_ textField: UITextField) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: nil, using: { note in
            if (self.validInputs()) {
                self.updateTokenButton(true)
            } else {
                self.updateTokenButton(false)
            }
        })
    }
    func initializeMembers() {
        self.cardNumber = nil
        self.cardExpirationMonth = nil
        self.cardExpirationYear = nil
        self.cardVerificationCode = nil
        self.cardNumberBuffer = ""
    }
    
    func darkBlueColor() -> UIColor {
        let color = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        return color
    }
    
    @IBAction func payButtonTapped(_ sender: AnyObject) {
        self.activityIndicatorAcceptSDKDemo.startAnimating()
        self.payButtonTapped()
    }
    
    @IBAction func backButtonButtonTapped(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateTokenButton(_ isEnable: Bool) {
        self.payButton.isEnabled = isEnable
        if isEnable {
            self.payButton.backgroundColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        } else {
            self.payButton.backgroundColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.2)
        }
    }
    
    
    func callAddAddressAddOrderDetails()
    {
        
        
        
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
        expirationMonthTextField.resignFirstResponder()
        expirationYearTextField.resignFirstResponder()
        cardVerificationCodeTextField.resignFirstResponder()
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
  
  
    //UITextFields Delegate Methods
    
   /* func textFieldDidBeginEditing(_ textField: UITextField)
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
    }*/

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
    
    /*
    @IBAction func didClickedDeliveryorProfileAddress(_ sender: AnyObject)
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
    
    func showErrorAlert(_ alertMsg : String) -> Void
    {
        var alert = UIAlertController(title: "Error", message: alertMsg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func validatePaymentForm() -> Bool
    {
        var status:Bool=true
        
        let commonValidation = CommonValidation()
        
      /*  if(self.cardNumberTextField.text == nil || self.cardNumberTextField.text=="")
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
        }*/
         if(self.cardHolderNameTextField.text == nil || self.cardHolderNameTextField.text=="")
        {
            status=false;
            self.showErrorAlert("Please enter Card Holder's Name");
        }
        else if(self.addressTextField.text == nil || self.addressTextField.text=="")
        {
            status=false;
            self.showErrorAlert("Please enter Billing Address");
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
        self.activityIndicatorAcceptSDKDemo.stopAnimating()

        return status;
        
    }

     func payButtonTapped()
    {
        if(validatePaymentForm() == true)
        {
        
        self.postBillingAddressToServer()
            
        }
       
    }
    
func postBillingAddressToServer()
{
        self.activityIndicatorAcceptSDKDemo.startAnimating()
        
        let urlString : String!
        
        let requestDict : [String : String]!
        
        let userCustomerId = UserDefaults.standard.string(forKey: Constants.kSignedInUserID)
        
            urlString = String(format: "%@/AddBillingAddress", arguments: [Urls.stanleyKorshakUrl])
            
        requestDict = ["FullName":cardHolderNameTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"AddressLine1":addressTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"Phone":phoneTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"City":cityTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"State":stateProvinceTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"ZIP":zipPostalCodeTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"Country":"India","Customer_Id": userCustomerId!,"Cardnumber":self.cardNumberTextField.text!,"Expmo":self.expirationMonthTextField.text!,"Expyr":self.expirationYearTextField.text!,"Cvv":self.cardVerificationCodeTextField.text!,"BillingID":"1"]
       
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
                
                
                let handler = AcceptSDKHandler(environment: AcceptSDKEnvironment.ENV_TEST)
                
                let request = AcceptSDKRequest()
                request.merchantAuthentication.name = self.kClientName
                request.merchantAuthentication.clientKey = self.kClientKey
                
                request.securePaymentContainerRequest.webCheckOutDataType.token.cardNumber = self.cardNumberBuffer
                request.securePaymentContainerRequest.webCheckOutDataType.token.expirationMonth = self.cardExpirationMonth
                request.securePaymentContainerRequest.webCheckOutDataType.token.expirationYear = self.cardExpirationYear
                request.securePaymentContainerRequest.webCheckOutDataType.token.cardCode = self.cardVerificationCode
                
                
                handler!.getTokenWithRequest(request, successHandler: { (inResponse:AcceptSDKTokenResponse) -> () in
                    DispatchQueue.main.async(execute: {
                        self.updateTokenButton(true)
                        
                        self.activityIndicatorAcceptSDKDemo.stopAnimating()
                        print("Token--->%@", inResponse.getOpaqueData().getDataValue())
                        var output = String(format: "Response: %@\nData Value: %@ \nDescription: %@", inResponse.getMessages().getResultCode(), inResponse.getOpaqueData().getDataValue(), inResponse.getOpaqueData().getDataDescriptor())
                        output = output + String(format: "\nMessage Code: %@\nMessage Text: %@", inResponse.getMessages().getMessages()[0].getCode(), inResponse.getMessages().getMessages()[0].getText())
                        self.callAddAddressAddOrderDetails()
                        // self.textViewShowResults.text = output
                        // self.textViewShowResults.textColor = UIColor.green
                    })
                }) { (inError:AcceptSDKErrorResponse) -> () in
                    self.activityIndicatorAcceptSDKDemo.stopAnimating()
                    self.updateTokenButton(true)
                    
                    let output = String(format: "Response:  %@\nError code: %@\nError text:   %@", inError.getMessages().getResultCode(), inError.getMessages().getMessages()[0].getCode(), inError.getMessages().getMessages()[0].getText())
                    //self.textViewShowResults.text = output
                    // self.textViewShowResults.textColor = UIColor.red
                    print(output)
                }
           
                return
            }
            
        })
    }
  
}
extension String
{
    func isValidEmail() -> Bool
    {
        let regex = try? NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .caseInsensitive)
        return regex!.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
    }
}


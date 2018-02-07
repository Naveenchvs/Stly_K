//
//  DefaultAddressVC.swift
//  Fashion180
//
//  Created by Srinivas Peddinti on 1/5/18.
//  Copyright © 2018 Mobiware. All rights reserved.
//

import UIKit

/*protocol DefaultAddressDelegate
{
    func selectedDeliveryAddress(selectedAddress : [String : Address])
}*/

class DefaultAddressVC: UIViewController,UITableViewDelegate,UITableViewDataSource,DefaultAddressTVCDelegate
{
    

    @IBOutlet var addressTableView: UITableView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    let reuseIdentifier = "DefaultAddressCell"
    
    //var delegate : DefaultAddressDelegate!
    
    var addresses : [Address] =  [Address]()
    
    @IBOutlet var addNewAddressBtn: UIButton!
    
    var activityView = UIActivityIndicatorView()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /*let firstDict : [String : Any] = ["Name" : "CH.V.S.Naveen", "Address" : "8-th floor, D-Block,iLabs Center, Opp Inorbit Mall, Madhapur, Hyderabad, Telangana, 500081, Mobile : 9676252141"]
        
        let secondDict : [String : Any] = ["Name" : "P.Srinivas", "Address" : "7-th floor, Now-Floats"]
        
        
        addressDetailsArray = [firstDict,secondDict]*/
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.color = UIColor.black
        activityView.center = self.view.center
        
        self.view.addSubview(activityView)
        
        addressTableView.estimatedRowHeight = 114
        addressTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.getAddressService()
    }
    
    
    func getAddressService()
    {
        self.activityView.startAnimating()
        
        let userCustomerId = UserDefaults.standard.string(forKey: Constants.kSignedInUserID)
        
        let urlString = String(format: "%@/GetShippingAddress/%@", arguments: [Urls.stanleyKorshakUrl,userCustomerId!]);
        
        self.addresses.removeAll()
        
        FAServiceHelper().get(url: urlString, completion : { (success : Bool?, message : String?, responseObject : AnyObject?) in
            
            self.activityView.stopAnimating()
            
            guard success == true else
            {
                return
            }
            
            guard responseObject == nil else
            {
                self.addresses =  AddressDetailesHelper.getAddressHelper(responseObject! as AnyObject?)!
                self.addressTableView.reloadData()
                return
                
            }
        })
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //UITableView Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let addressCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DefaultAddressTVCell
        addressCell.delegate = self
        addressCell.selectBtn.tag = indexPath.row
        addressCell.editBtn.tag = indexPath.row
        
        let selectedDict  = addresses[indexPath.row]
        
        var fullNamesString : String = ""
        
        if let firstName = selectedDict.firstName
        {
            fullNamesString += (firstName as String) + " "
        }
        
        if let lastName = selectedDict.lastName
        {
            fullNamesString += lastName as String
        }
        
        addressCell.nameLabel.text = fullNamesString
        
        var fullAddressString : String = ""
        
        if let companyName = selectedDict.compyName
        {
            fullAddressString += (companyName as String) + ","
        }
        if let streetAddress = selectedDict.streetAddress
        {
            fullAddressString += (streetAddress as String) + ","
        }
        if let city = selectedDict.city
        {
            fullAddressString += (city as String) + ","
        }
        if let state = selectedDict.state
        {
            fullAddressString += (state as String) + ","
        }
        if let zip = selectedDict.zip
        {
            fullAddressString += (zip as String) + ","
        }
        if let country = selectedDict.country
        {
            fullAddressString += (country as String) + ","
        }
        if let phone = selectedDict.phone
        {
            fullAddressString += (phone as String) + ","
        }
        addressCell.addressLabel.text = fullAddressString
        
        return addressCell
    }
    
    func selectedDeliveryAddress(atSelectedIndex: Int)
    {
        let selectedAddress = ["selectedDeliveryAddress" : addresses[atSelectedIndex]]

        let storyBoard = UIStoryboard(name: "Checkout", bundle:Bundle(for: Wardrober.self))
        let paymentVC = storyBoard.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController
        paymentVC?.selectedAddDict = selectedAddress
        self.navigationController?.pushViewController(paymentVC!, animated: true)
    }
  
    func editSelectedAddress(atSelectedIndex: Int)
    {
        let editableAddress = ["EditableAddress" : addresses[atSelectedIndex]]
        
        let storyBoard = UIStoryboard(name: "Address", bundle:Bundle(for: Wardrober.self))
        let addContainerVC = storyBoard.instantiateViewController(withIdentifier: "AddContainerViewController") as? AddContainerVC
        addContainerVC?.fromWhichController = "DefaultAddressVC"
        addContainerVC?.titleString = "EDIT ADDRESS"
        addContainerVC?.editableAddress = editableAddress
        self.navigationController?.pushViewController(addContainerVC!, animated: true)
    }
    
    @IBAction func addNewAddressBtnAction(_ sender: Any)
    {
        let storyBoard = UIStoryboard(name: "Address", bundle:Bundle(for: Wardrober.self))
        let addContainerVC = storyBoard.instantiateViewController(withIdentifier: "AddContainerViewController") as? AddContainerVC
        addContainerVC?.fromWhichController = "DefaultAddressVC"
        addContainerVC?.titleString = "ADD NEW ADDRESS"
        self.navigationController?.pushViewController(addContainerVC!, animated: true)
    }
}

//
//  AddNewAddressVC.swift
//  Wardrober
//
//  Created by Saraschandra on 12/01/18.
//  Copyright © 2018 Mobiware. All rights reserved.
//

import UIKit

protocol AddContainerDelegate
{
   func addressSaved()
}

class AddContainerVC : UIViewController
{

    @IBOutlet var navBarHeightConstraint : NSLayoutConstraint!
    
    var delegate : AddContainerDelegate!
    
    var fromWhichController : String!
    
    var titleString  : String!
    
    var editableAddress : [String : Address]!
    
    @IBOutlet var titleLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if (fromWhichController == "HomeContainerVC")
        {
            self.navBarHeightConstraint.constant = 0
        }
        else
        {
            self.navBarHeightConstraint.constant = 44
            self.titleLabel.text = titleString
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddContainerVC.savedAddressFromHomeVC(_:)), name: NSNotification.Name(rawValue: "SavedDeliveryAddressFromHomeContainerVC") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddContainerVC.savedAddressFromDefaultVC(_:)), name: NSNotification.Name(rawValue: "SavedDeliveryAddressFromDefaultAddressVC") , object: nil)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddContainerVC.cancelAction(_:)), name: NSNotification.Name(rawValue: "CancelAction") , object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let controller = segue.destination as? AddNewTVC, segue.identifier == "SegueAddNewIdentifier"
        {
            controller.fromWhichController = fromWhichController
            controller.titleString = titleString
            if editableAddress != nil
            {
                controller.editableAddressDict = editableAddress
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender : UIButton)
    {
       self.navigationController?.popViewController(animated: true)
    }
    
    @objc func savedAddressFromHomeVC(_ notification: NSNotification)
    {
        self.delegate.addressSaved()
        
        /*let storyBoard = UIStoryboard(name: "Address", bundle:Bundle(for: Wardrober.self))
        let defaultAddressVC = storyBoard.instantiateViewController(withIdentifier: "DefaultAddressViewController") as? DefaultAddressVC
        self.navigationController?.pushViewController(defaultAddressVC!, animated: true)*/
    }
    
    @objc func savedAddressFromDefaultVC(_ notification: NSNotification)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelAction(_ notification: NSNotification)
    {
        if (fromWhichController == "HomeContainerVC")
        {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

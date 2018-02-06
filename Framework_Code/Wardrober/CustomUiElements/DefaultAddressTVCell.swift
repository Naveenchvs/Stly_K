//
//  AddressTableViewCell.swift
//  CheckOut
//
//  Created by Saraschandra on 04/01/18.
//  Copyright © 2018 Mobiware. All rights reserved.
//

import UIKit

protocol DefaultAddressTVCDelegate
{
    func selectedDeliveryAddress(atSelectedIndex:Int)
    func editSelectedAddress(atSelectedIndex:Int)
}

class DefaultAddressTVCell : UITableViewCell
{

    @IBOutlet var bgView: UIView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var selectBtn: UIButton!
    
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var editBtn: UIButton!
    
    var delegate : DefaultAddressTVCDelegate!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        /*print(nameLabel.frame.height)
        print(addressLabel.frame.height)
        print(selectBtn.frame.height)*/
        
        selectBtn.backgroundColor = .clear
        selectBtn.layer.cornerRadius = selectBtn.frame.width/12
        selectBtn.layer.borderWidth = 1
        selectBtn.layer.borderColor = UIColor.init(red:103/255.0, green:162/255.0, blue:258/255.0, alpha: 1.0).cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func selectBtnAction(_ sender: UIButton)
    {
        self.delegate.selectedDeliveryAddress(atSelectedIndex : sender.tag)
    }
    
    @IBAction func editBtnAction(_ sender: UIButton)
    {
        self.delegate.editSelectedAddress(atSelectedIndex: sender.tag)
    }
}

//
//  PopupCell.swift
//  Fashion180
//
//  Created by Saraschandra on 07/04/17.
//  Copyright © 2017 Mobiware. All rights reserved.
//

import UIKit

class PopupCell: UICollectionViewCell
{
    
    @IBOutlet var cellBgView: UIView!
    
    @IBOutlet var itemImageView: UIImageView!
    
    @IBOutlet var designerLabel: UILabel!
    
    @IBOutlet var itemNameLabel: UILabel!
    
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var customView: CustomSizesView!
    
    @IBOutlet var innerDotView: UIView!
    
    @IBOutlet var selectedOrUnselectedLabel: UILabel!

    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        itemImageView.layer.borderWidth = 1.0
        itemImageView.layer.masksToBounds = false
        let imageBorderColor = UIColor(red: CGFloat(7)/CGFloat(255), green: CGFloat(7)/CGFloat(255), blue: CGFloat(7)/CGFloat(255), alpha: 1)
        itemImageView.layer.borderColor = imageBorderColor.cgColor
        itemImageView.layer.cornerRadius = itemImageView.frame.width/2
        itemImageView.clipsToBounds = true
        
        innerDotView.backgroundColor = Constants.dotSelectedColor
        innerDotView.layer.cornerRadius = innerDotView.frame.width/2
       
    }
}

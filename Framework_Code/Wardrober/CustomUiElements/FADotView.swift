//
//  FADotView.swift
//  Fashion180
//
//  Created by Yogi on 30/11/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//

import UIKit

class FADotView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.layoutIfNeeded()
        
        self.backgroundColor = Constants.dotUnselectedColor
        self.clipsToBounds = false
        self.layer.cornerRadius = self.bounds.size.width / CGFloat(2)
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
        
        let shadowFactor = CGFloat(0.1)
        self.layer.shadowOffset = CGSize(width: shadowFactor * self.bounds.size.width, height: shadowFactor * self.bounds.size.height)
        self.layer.shadowOpacity = 0.5
        
        
    }

    func unhide(_ unhide : Bool)
    {
        if unhide == true
        {
            //unhide with animation
            self.alpha = 1
        }
        else
        {
            //hide with animation
            self.alpha = 0

        }
    }
    
    func setColorSelected(_ selected : Bool)
    {
        if selected == true
        {
            self.backgroundColor = Constants.dotSelectedColor

        }
        else
        {
            self.backgroundColor = Constants.dotUnselectedColor

        }

    }
    
    
}

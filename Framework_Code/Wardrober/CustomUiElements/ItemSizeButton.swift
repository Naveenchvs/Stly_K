//
//  ItemSizeButton.swift
//  Fashion180
//
//  Created by Yogi on 18/10/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//

import UIKit

class ItemSizeButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = UIColor(red: 29.0/255.0, green: 29.0/255.0, blue: 29.0/255.0, alpha: 1).cgColor
        self.layer.borderWidth = 1
    }
    

}

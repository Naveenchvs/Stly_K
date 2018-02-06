//
//  ItemDetailAnimationView.swift
//  Fashion180
//
//  Created by Yogi on 19/10/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//

import UIKit

class ItemDetailAnimationView: UIView {

    @IBOutlet var topHalfImageView : UIImageView!
    @IBOutlet var bottomHalfImageView : UIImageView!
    @IBOutlet var AddToBagImageView : UIImageView!
    @IBOutlet var checkoutImageView : UIImageView!
    @IBOutlet var checkoutFinalButton : UIButton!


    @IBOutlet var topConstraint : NSLayoutConstraint!
    @IBOutlet var leadingConstraint : NSLayoutConstraint!
    @IBOutlet var widthConstraint : NSLayoutConstraint!
    @IBOutlet var heightConstraint : NSLayoutConstraint!
    
    
    @IBOutlet var bottomConstraintAddToBag : NSLayoutConstraint!
    @IBOutlet var centerConstraintAddToBag : NSLayoutConstraint!
    @IBOutlet var widthConstraintAddToBag : NSLayoutConstraint!
    @IBOutlet var heightConstraintAddToBag : NSLayoutConstraint!
    
    @IBOutlet var bottomConstraintCheckout : NSLayoutConstraint!
    @IBOutlet var centerConstraintCheckout : NSLayoutConstraint!
    @IBOutlet var widthConstraintCheckout : NSLayoutConstraint!
    @IBOutlet var heightConstraintCheckout : NSLayoutConstraint!
    
    
    @IBOutlet var topConstraintTopHalfView : NSLayoutConstraint!
    @IBOutlet var bottomConstraintBottomHalfView : NSLayoutConstraint!

    
    
    @IBOutlet var bottomConstraintFinalCheckoutBtn : NSLayoutConstraint!
    @IBOutlet var leadingConstraintFinalCheckoutBtn : NSLayoutConstraint!
    @IBOutlet var trailingConstraintFinalCheckoutBtn : NSLayoutConstraint!
    @IBOutlet var heightConstraintFinalCheckoutBtn : NSLayoutConstraint!
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

//
//  FAFillColorButton.swift
//  Fashion180
//
//  Created by Yogi on 14/10/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//

import UIKit

protocol FAFillColorButtonDelegate {
    
    func faFillColorButtonShouldSelect(_ view : FAFillColorButton!) -> Bool
    func faFillColorButtonWasSelected(_ view : FAFillColorButton!)
    func faFillColorButtonWasUnselected(_ view : FAFillColorButton!)

}

class FAFillColorButton: UIView {

    var isSelected : Bool = false
    
    var isFirstTime : Bool = true
    var buttonWidth : CGFloat!
    var buttonHeight : CGFloat!
    
    var delegate : FAFillColorButtonDelegate!
    
    
    @IBOutlet var selectedStateButton : UIButton!
    @IBOutlet var unselectedStateButton : UIButton!
    
    
    @IBOutlet var unselectedStateButtonWidthConstraint : NSLayoutConstraint!
    @IBOutlet var unselectedStateButtonHeightConstraint : NSLayoutConstraint!
    @IBOutlet var selectedStateButtonWidthConstraint : NSLayoutConstraint!
    @IBOutlet var selectedStateButtonHeightConstraint : NSLayoutConstraint!

    

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.unselectedStateButton.layer.cornerRadius = 16
        self.unselectedStateButton.layer.borderColor = UIColor(red: 29.0/255.0, green: 29.0/255.0, blue: 29.0/255.0, alpha: 1).cgColor
        self.unselectedStateButton.layer.borderWidth = 1
        self.unselectedStateButton.layer.cornerRadius = 16
        
        
        self.selectedStateButton.layer.cornerRadius = 16
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if isFirstTime == true
        {
            isFirstTime = false
            buttonWidth = unselectedStateButton.bounds.size.width
            buttonHeight = unselectedStateButton.bounds.size.height
        }
        
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func selectTapped()
    {
        let shouldSelect = delegate.faFillColorButtonShouldSelect(self) as Bool
        
        if shouldSelect == false
        {
            return
        }
        
        
        selectedStateButtonWidthConstraint.constant = 32
        selectedStateButtonHeightConstraint.constant = 32
        self.layoutIfNeeded()
        
        self.bringSubview(toFront: selectedStateButton)
        
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {

            self.selectedStateButtonWidthConstraint.constant = self.buttonWidth
            self.selectedStateButtonHeightConstraint.constant = self.buttonHeight
            self.layoutIfNeeded()
            


        }) { (finished) in
            self.isUserInteractionEnabled = true

            self.delegate.faFillColorButtonWasSelected(self)
        }
        
        isSelected = true
    }
    
    @IBAction func unselectTapped()
    {
//        unselectedStateButtonWidthConstraint.constant = 32
//        unselectedStateButtonHeightConstraint.constant = 32
//        self.layoutIfNeeded()
        
        /////self.bringSubviewToFront(unselectedStateButton)

        
        let shouldSelect = delegate.faFillColorButtonShouldSelect(self) as Bool
        
        if shouldSelect == false
        {
            return
        }
        
        self.isUserInteractionEnabled = false

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            self.selectedStateButtonWidthConstraint.constant = 0
            self.selectedStateButtonHeightConstraint.constant = 0
            self.layoutIfNeeded()
            
        }) { (finished) in
            
            self.bringSubview(toFront: self.unselectedStateButton)
            self.isUserInteractionEnabled = true

            self.delegate.faFillColorButtonWasUnselected(self)

        }
        
        isSelected = false

    }
    
    
    func setFaFillColorButtonStateSelected(_ setSelectedState : Bool)
    {
        
        
        if setSelectedState == true
        {
            selectedStateButtonWidthConstraint.constant = 32
            selectedStateButtonHeightConstraint.constant = 32
            self.layoutIfNeeded()
            
            self.bringSubview(toFront: selectedStateButton)
            
            self.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                
                self.selectedStateButtonWidthConstraint.constant = self.buttonWidth
                self.selectedStateButtonHeightConstraint.constant = self.buttonHeight
                self.layoutIfNeeded()
                
                
                
            }) { (finished) in
                self.isUserInteractionEnabled = true
            }
            
            isSelected = true
        }
        else
        {
            self.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                
                self.selectedStateButtonWidthConstraint.constant = 0
                self.selectedStateButtonHeightConstraint.constant = 0
                self.layoutIfNeeded()
                
            }) { (finished) in
                
                self.bringSubview(toFront: self.unselectedStateButton)
                self.isUserInteractionEnabled = true
                
            }
            
            isSelected = false
        }
        
        
    }
    

}

//
//  ClothingItemCell.swift
//  Fashion180
//
//  Created by Yogi on 15/12/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//


protocol ClothingItemCellDelegate {
    
    func clothingItemCellDeleteTapped(_ clothingItemCell : UITableViewCell)
}

class ClothingItemCell: UITableViewCell {

    @IBOutlet var itemImageView : UIImageView!
    @IBOutlet var designerNameLbl : UILabel!
    @IBOutlet var itemNameLbl : UILabel!
    @IBOutlet var priceLbl : UILabel!

    @IBOutlet var deleteButton : UIButton!
    var delegate : ClothingItemCellDelegate!

    var deleteButtonAlreadyAnimatedIn : Bool = false
    
    @IBAction func deleteButtonTapped(_ sender : UIButton!)
    {
        self.delegate.clothingItemCellDeleteTapped(self)
    }
    
    func showDeleteButton()
    {
        if self.deleteButtonAlreadyAnimatedIn == false
        {
            self.popInDeleteButton()
        }
        else
        {
            self.deleteButton.alpha = 1
        }
    }
    
    func hideDeleteButton()
    {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [ UIViewAnimationOptions.curveEaseOut], animations: {
            
            self.deleteButton.alpha = 0
            
        }) { (finished) in
            
        }
    }
    
    func popInDeleteButton()
    {
        self.deleteButton.alpha = 0

        self.deleteButton.transform = CGAffineTransform.identity.scaledBy(x: 0.01, y: 0.01)

        UIView.animate(withDuration: 0.4, delay: 0.0, options: [UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.curveEaseIn], animations: {
            
            self.deleteButton.alpha = 1
            self.deleteButton.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            
            
        }) { (finished) in
            
        }
    }
    
    
    
    
    func wobble()
    {
        self.stopWobble()
        self.startWobble()
        
    }
    
    func dontWobble()
    {
        self.stopWobble()
    }
    
    func startWobble()
    {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.deleteButton.alpha = 1
        }) 
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.repeat, UIViewAnimationOptions.autoreverse], animations: {
            

            
            self.contentView.transform = CGAffineTransform.identity.rotated(by: CGFloat(self.degreesToRadians(5)));
            
            }) { (finished) in
                
        }
    }
    
    func stopWobble()
    {
        UIView.animate(withDuration: 0.3, animations: {
            
            self.deleteButton.alpha = 0
        }) 
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveLinear], animations: {
            
            self.contentView.transform = CGAffineTransform.identity
            
        }) { (finished) in
            
        }
    }
    
    func degreesToRadians(_ degrees : Double) -> Double
    {
        return (degrees * M_PI) / 180.0
    }

    
}

//
//  ItemDetailCollectionViewCell.swift
//  Fashion180
//
//  Created by Yogi on 18/10/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//

import UIKit

@objc protocol ItemDetailCollectionViewCellDelegate {
    
    @objc optional func itemDetailCell(_ cell : ItemDetailCollectionViewCell!, checkOutTappedForItemAtIndex index : Int)
    
    @objc optional func itemDetailCell(_ cell : ItemDetailCollectionViewCell!, addToBagTappedForItemAtIndex index : Int)
    
    @objc optional func itemDetailCell(_ cell : ItemDetailCollectionViewCell!, wardrobeTappedForItemAtIndex index : Int)

    
    
    @objc optional func itemDetailCell(_ cell : ItemDetailCollectionViewCell!, sizeButton button : UIButton, tappedForItemAtIndex index : Int)
    
    @objc optional func itemDetailCell(_ cell : ItemDetailCollectionViewCell!, sizeButtonTappedForShoeItemAtIndex shoeItemIndex : Int, atSizeArrayIndex sizeArrayIndex : Int )
    
    
    @objc optional func itemDetailCell(_ cell : ItemDetailCollectionViewCell!, checkoutSelected : Bool )
    
    
    @objc optional func itemDetailCellNeedsLogin(_ cell : ItemDetailCollectionViewCell!)
    
    @objc optional func shareBtnTapped(sender : Any)
    
    
}

class ItemDetailCollectionViewCell: UICollectionViewCell, customCollectionViewDelegate {
    
    
    @IBOutlet var mainContentView : UIView!
    
    @IBOutlet var buttonAddToBag : UIButton!
    
    @IBOutlet var AddToBagAnimatingView : UIView!
    
    @IBOutlet var AddToBagAnimatingViewWidthConstraint : NSLayoutConstraint!
    
    @IBOutlet var buttonCheckout : UIButton!
    
    
    @IBOutlet var topHalfView : UIView!
    
    @IBOutlet var bottomHalfView : UIView!
    
    
    @IBOutlet var messageLabel : UILabel!
    
    @IBOutlet var priceLable : UILabel!
    
    @IBOutlet var designerNameLable : UILabel!
    
    @IBOutlet var itemTypeLable : UILabel!
    
    @IBOutlet var itemNameLable : UILabel!
    
    @IBOutlet var productImageView : UIImageView!
    
    @IBOutlet var productDescriptionLble : UILabel!
    
    
    var sizesArray : NSMutableArray!
    
    var sizeNamesArray : NSMutableArray!
    
    var collectionView : UICollectionView!
    
    var delegate : ItemDetailCollectionViewCellDelegate? = nil
    
    @IBOutlet var customView : CustomCollectionView!
    
    @IBOutlet var dotView : UIView!
    
    @IBOutlet var wardrobeBtn : UIButton!
    
    @IBOutlet var shareBtn : UIButton!
    
    //@IBOutlet var productSizesCollectioView : UICollectionView!
    
    @IBOutlet var dotViewWidthConstraint : NSLayoutConstraint!
    
    var fontSize : CGFloat!
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    @IBOutlet weak var checkoutBtn_B_Constraint: NSLayoutConstraint!
    
    @IBOutlet var checkoutBtn_H_Constraint: NSLayoutConstraint!
    
    
    @IBOutlet var customViewTopContrainT: NSLayoutConstraint!
    
    @IBOutlet var vzImageTopConstaint: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.wardrobeBtn.layer.masksToBounds = true
        
        self.wardrobeBtn.layer.borderWidth = 2.0
        
        self.wardrobeBtn.layer.borderColor = UIColor.black.cgColor
        
        self.dotView.layer.masksToBounds = true
        self.dotView.layer.cornerRadius = self.dotViewWidthConstraint.constant/2
        
        
        mainContentView.layer.shadowColor = UIColor.black.cgColor
        mainContentView.layer.shadowOffset = CGSize(width: 10, height: 10)
        mainContentView.layer.shadowOpacity = 0.3
        mainContentView.layer.shadowRadius = 6
        
        
        
        customView.delegate = self
        
        self.wardrobeBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        self.buttonAddToBag.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        self.buttonCheckout.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        
        
        switch (Constants.deviceIdiom)
        {
        case .pad:
            
            self.wardrobeBtn.layer.cornerRadius = 20
            self.buttonAddToBag.layer.cornerRadius = 20
            self.buttonCheckout.layer.cornerRadius = 20
            self.checkoutBtn_B_Constraint.constant = 22.0
            
        case .phone:
            
                self.wardrobeBtn.layer.cornerRadius = 12
                self.buttonAddToBag.layer.cornerRadius = 12
                self.buttonCheckout.layer.cornerRadius = 12
                self.checkoutBtn_B_Constraint.constant = 15.0

        default: break
            ///print("Unspecified UI idiom")
            
        }

        ////hide share button if NSPhotoLibraryUsageDescription isn't there in the info.plist of the host app.
        if let infoPlistDict = Bundle.main.infoDictionary
        {
            if infoPlistDict["NSPhotoLibraryUsageDescription"] == nil
            {
                shareBtn.isHidden = true
            }
        }
        ////////
        
        
    }
    
    
    @IBAction func checkoutTapped(_ sender : UIButton!)
    {
        
        delegate?.itemDetailCell!(self, checkOutTappedForItemAtIndex: sender.tag)
    }
    
   /* @IBAction func shareBtnTapped(_ sender : AnyObject!){
        
        //delegate?.shareBtnTapped!()
        delegate?.shareBtnTapped!(sender: sender)
        
        
    }*/
    
    
    @IBAction func wardrobeShareBtnTapped(_ sender: Any)
    {
        delegate?.shareBtnTapped!(sender: sender)
    }
    @IBAction func shareBtnTapped(_ sender: Any)
    {
        delegate?.shareBtnTapped!(sender: sender)
    }
    
    @IBAction func wardrobeBtnTapped()
    {
        let userSignedIn =   UserDefaults.standard.bool(forKey: Constants.kUserSuccessfullySignedIn)
        
        if userSignedIn == false
        {
            delegate!.itemDetailCellNeedsLogin!(self)
        }
        else
        {
            self.delegate?.itemDetailCell!(self, wardrobeTappedForItemAtIndex: (self.collectionView.indexPath(for: self)?.row)!)

        }
        
    }
    
    @IBAction func addToBagTapped(_ sender : UIButton!)
    {
        
        self.collectionView.isUserInteractionEnabled = false
        
        
        self.AddToBagAnimatingView.layer.cornerRadius = self.buttonAddToBag.layer.cornerRadius
        
        self.AddToBagAnimatingView.tintColor = UIColor.white
        self.AddToBagAnimatingView.backgroundColor = self.buttonAddToBag.backgroundColor
        self.buttonAddToBag.isHidden = true
        self.AddToBagAnimatingView.isHidden = false
        
        let titleLabel = self.AddToBagAnimatingView.viewWithTag(1) as! UILabel
        let imageView = self.AddToBagAnimatingView.viewWithTag(2) as! UIImageView
        
        imageView.image = UIImage(named:"CartButton", in: Bundle(for: type(of: self)), compatibleWith: nil)!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        titleLabel.text = "ADD TO BAG"
        titleLabel.alpha = 1
        
        imageView.alpha = 0
        
        
        let duration = Double(0.3)
        let estimateCorner = self.AddToBagAnimatingView.bounds.size.height / 2.0
        let animation = CABasicAnimation(keyPath : "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.fromValue = self.AddToBagAnimatingView.layer.cornerRadius
        animation.toValue = estimateCorner
        animation.duration = duration;
        self.AddToBagAnimatingView.layer.cornerRadius = estimateCorner
        
        self.AddToBagAnimatingView.layer.add(animation, forKey: "cornerRadius")
        
        
        
        
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            
            imageView.alpha = 1
            titleLabel.alpha = 0
            self.AddToBagAnimatingViewWidthConstraint.constant = self.AddToBagAnimatingView.bounds.size.height
            
            self.AddToBagAnimatingView.layoutIfNeeded()
            
        }) { (finished) in
            
            
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                
                //back to original state
                
                
                let duration = Double(0.3)
                let estimateCorner = self.buttonAddToBag.layer.cornerRadius
                let animation = CABasicAnimation(keyPath : "cornerRadius")
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                animation.fromValue = self.AddToBagAnimatingView.layer.cornerRadius
                animation.toValue = estimateCorner
                animation.duration = duration;
                self.AddToBagAnimatingView.layer.cornerRadius = estimateCorner
                
                self.AddToBagAnimatingView.layer.add(animation, forKey: "cornerRadius")
                
                
                
                UIView.animate(withDuration: duration, animations: {
                    
                    imageView.alpha = 0
                    titleLabel.alpha = 1
                    self.AddToBagAnimatingViewWidthConstraint.constant = self.buttonAddToBag.bounds.size.width
                    
                    self.layoutIfNeeded()
                    
                    
                    }, completion: { (finished) in
                        
                        titleLabel.text = "(1) ADD TO BAG"
                        self.buttonAddToBag.setTitle(titleLabel.text, for: UIControlState())
                        self.buttonAddToBag.isHidden = false
                        self.AddToBagAnimatingView.isHidden = true
                        
                        self.delegate?.itemDetailCell!(self, addToBagTappedForItemAtIndex: (self.collectionView.indexPath(for: self)?.row)!)
                        
                        
                        self.collectionView.isUserInteractionEnabled = true
                        
                        
                })
                
            })
            
            
            let degreesVariance = CGFloat(45);
            let radiansToRotate =  (degreesVariance / CGFloat(180.0)) * CGFloat(M_PI);
            let zRotation1 = CATransform3DMakeRotation(radiansToRotate, 0, 0, 1.0);
            let zRotation2 = CATransform3DMakeRotation(2 * CGFloat(M_PI) - radiansToRotate, 0, 0, 1.0);
            
            let zRotation3 = CATransform3DMakeRotation(0, 0, 0, 1.0);
            
            let animateZRotation = CAKeyframeAnimation(keyPath: "transform")
            animateZRotation.values = [NSValue(caTransform3D:zRotation1), NSValue(caTransform3D:zRotation2), NSValue(caTransform3D:zRotation1), NSValue(caTransform3D:zRotation2), NSValue(caTransform3D:zRotation3)]
            
            animateZRotation.keyTimes = [ NSNumber(value: 0 as Float), NSNumber(value: (1 / 6.0) as Float), NSNumber(value: (3 / 6.0) as Float), NSNumber(value: (5 / 6.0) as Float), NSNumber(value: (1) as Float) ]
            
            animateZRotation.duration = 0.4;
            animateZRotation.repeatCount = 2
            
            animateZRotation.isAdditive = true;
            
            
            self.AddToBagAnimatingView.layer.removeAllAnimations()
            self.AddToBagAnimatingView.layer.add(animateZRotation, forKey: "shake")
            
            
            CATransaction.commit()
            
        }
        
    }
    
    
    @IBAction func sizeButtonTapped(_ button : UIButton!)
    {
        
        delegate?.itemDetailCell!(self, sizeButton: button, tappedForItemAtIndex: (self.collectionView.indexPath(for: self)?.row)!)
    }
    
    
    // MARK: - CUSTOM COLLECTIONVIEW DELEGATE
    
    
    func selectedSizeAtIndexpath(_ cell: CustomCollectionView, selectedIndex: Int) {
        
        let shoeItemIndex =   collectionView.indexPath(for: self)!.row
        
        cell.selectedIndex = selectedIndex
        cell.productsCollectionView.reloadData()
        
        self.delegate?.itemDetailCell!(self, sizeButtonTappedForShoeItemAtIndex: shoeItemIndex, atSizeArrayIndex: selectedIndex)
        
    }
    
    
    
    // MARK: - FAFillColorButton View Delegate
    func faFillColorButtonShouldSelect(_ view: FAFillColorButton!) -> Bool {
        
        let userSignedIn =   UserDefaults.standard.bool(forKey: Constants.kUserSuccessfullySignedIn)

        if userSignedIn == false
        {
            delegate!.itemDetailCellNeedsLogin!(self)
        }
        
        return userSignedIn
        
    }
    
    
}

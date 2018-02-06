//
//  TagDragDropVC.swift
//  Fashion180
//
//  Created by Yogi on 29/12/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//


class TagDragDropVC: UIViewController {

    
    // MARK: -  Info Popup
    @IBOutlet var productContainerView : UIView!
    @IBOutlet weak var productInfoView: UIView!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var designerLable: UILabel!
    @IBOutlet weak var costLable: UILabel!
    @IBOutlet weak var brandLable: UILabel!
    
    @IBOutlet weak var productContainerView_X_Constraint: NSLayoutConstraint!
    @IBOutlet weak var productContainerView_Y_Constraint: NSLayoutConstraint!
    @IBOutlet weak var productContainerView_H_Constraint: NSLayoutConstraint!
    @IBOutlet weak var productContainerView_W_Constraint: NSLayoutConstraint!

    @IBOutlet weak var infoContainerView_W_Constraint: NSLayoutConstraint!
    @IBOutlet weak var infoContainerView_H_Constraint: NSLayoutConstraint!

    
//    @IBOutlet weak var brandLable_W_Constraint: NSLayoutConstraint!
//    @IBOutlet weak var designerLable_W_Constraint: NSLayoutConstraint!
    
    
    ///Cart & Wardrobe icons
    @IBOutlet var cartButtonTrailingConstraint : NSLayoutConstraint!
    @IBOutlet var cartButtonTopConstraint : NSLayoutConstraint!
    @IBOutlet var cartButtonWidthConstant : NSLayoutConstraint!

    
    @IBOutlet var wardrobeButtonTrailingConstraint : NSLayoutConstraint!
    @IBOutlet var wardrobeButtonBottomConstraint : NSLayoutConstraint!
    @IBOutlet var wardrobeButtonWidthConstant : NSLayoutConstraint!

    @IBOutlet var bgView : UIView!

    @IBOutlet var cartView : UIView!
    @IBOutlet var wardrobeView : UIView!
    @IBOutlet var checkmarkView : UIView!

    @IBOutlet var cartImgView : UIImageView!
    @IBOutlet var wardrobeImgView : UIImageView!
    @IBOutlet var checkmarkImgView : UIImageView!

    
    var startTagDragOrigin : CGPoint = CGPoint.zero
    var startCartViewOrigin : CGPoint = CGPoint.zero
    var startWardrobeViewOrigin : CGPoint = CGPoint.zero
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.checkmarkView.alpha = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.performWithoutAnimation {
            self.view.layoutIfNeeded()
            
        }
        self.bgView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            
            self.bgView.alpha = 0.6
            
            
        }, completion: { (finished) in
            
        }) 
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)

        
        self.applyOffsetToCornerViews()
        
        UIView.performWithoutAnimation {
            self.view.layoutIfNeeded()

        }
        
        
        
        
        self.cartView.layer.cornerRadius = self.cartView.frame.size.width / 2
        self.cartView.layer.shadowColor = UIColor.darkGray.cgColor
        self.cartView.layer.shadowOffset = CGSize(width: -4, height: 4)
        self.cartView.layer.shadowOpacity = 0.4
        self.cartView.layer.shadowRadius = 2
        
        self.wardrobeView.layer.cornerRadius = self.wardrobeView.frame.size.width / 2
        self.wardrobeView.layer.shadowColor = UIColor.darkGray.cgColor
        self.wardrobeView.layer.shadowOffset = CGSize(width: -4, height: -4)
        self.wardrobeView.layer.shadowOpacity = 0.4
        self.wardrobeView.layer.shadowRadius = 2
        
        self.checkmarkView.layer.cornerRadius = self.checkmarkView.frame.size.width / 2
        self.checkmarkView.layer.shadowColor = UIColor.darkGray.cgColor
        self.checkmarkView.layer.shadowOffset = CGSize(width: -4, height: -4)
        self.checkmarkView.layer.shadowOpacity = 0.4
        self.checkmarkView.layer.shadowRadius = 2
        
        
        ////Info Tag
        self.dotView.layer.cornerRadius = self.dotView.bounds.size.width / 2
        self.dotView.layer.shadowOpacity = 0.8
        self.dotView.layer.shadowColor = Constants.dotUnselectedColor.cgColor
        self.dotView.layer.shadowOffset = CGSize.zero
        self.dotView.layer.borderColor = UIColor.black.cgColor
        
        
        
        self.productContainerView.layer.masksToBounds = true
        self.productContainerView.layer.borderWidth = 2.0
        self.productContainerView.layer.cornerRadius = 20.0
        self.productContainerView.layer.shadowOpacity = 0.8
        self.productContainerView.layer.shadowColor = Constants.dotUnselectedColor.cgColor
        self.productContainerView.layer.shadowOffset = CGSize.zero
        
        self.productContainerView.alpha = 1
        
        
        let wardrobeImg = UIImage(named: "WardroberButton", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let cartImg = UIImage(named: "CartButton", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let checkmarkImg = UIImage(named: "checkmark-icon", in: Bundle(for: type(of: self)), compatibleWith: nil)

        let tintedWardrobeImg = wardrobeImg?.withRenderingMode(.alwaysTemplate)
        let tintedCartImg = cartImg?.withRenderingMode(.alwaysTemplate)
        let tintedCheckmarkImg = checkmarkImg?.withRenderingMode(.alwaysTemplate)

        self.wardrobeImgView.tintColor = UIColor.white
        self.cartImgView.tintColor = UIColor.white
        self.checkmarkImgView.tintColor = UIColor.white

        self.wardrobeImgView.image = tintedWardrobeImg
        self.cartImgView.image = tintedCartImg
        self.checkmarkImgView.image = tintedCheckmarkImg


        self.startCartViewOrigin = self.cartView.frame.origin
        self.startWardrobeViewOrigin = self.wardrobeView.frame.origin

    }

    func applyOffsetToCornerViews()
    {
        let cartViewOffset = (self.cartView.frame.width / 2) * CGFloat(1 - cos(M_PI_4))
        
        self.cartButtonTrailingConstraint.constant = cartViewOffset
        self.cartButtonTopConstraint.constant = cartViewOffset
        
        let wardrobeViewOffset = (self.wardrobeView.frame.width / 2) * CGFloat(1 - cos(M_PI_4))
        
        self.wardrobeButtonTrailingConstraint.constant = wardrobeViewOffset
        self.wardrobeButtonBottomConstraint.constant = wardrobeViewOffset
    }
    
}

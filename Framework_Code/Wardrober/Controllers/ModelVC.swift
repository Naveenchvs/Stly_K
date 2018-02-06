//
//  2DModelVC.swift
//  Fashion180
//
//  Created by Yogi on 07/10/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//

import UIKit

import Photos
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


enum DragMode {
    case item_TAG
    case clothing_ITEM
    case wardrobe_PUT_BACK
    case none
   }

enum ViewMode {
    case front
    case rear
}


class ModelVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, ClothingItemImageViewDelegate, UIScrollViewDelegate, FAZoomVCDelegate, ItemsDetailVcDelegate,ShoppingCartDelegate
{

    // MARK: -  Category View
    @IBOutlet var categoryContainerView : UIView!
    @IBOutlet var categoryUnderlinerView : UIView!
    @IBOutlet var categoryUnderlinerViewCenterXConstraint : NSLayoutConstraint!
    @IBOutlet var categoryUnderlinerViewWidthConstraint : NSLayoutConstraint!
    var selectedCategoryIndex = 0
    @IBOutlet var businessCategoryLabel : UILabel!
    @IBOutlet var categoryTopLinerView : UIView!

    @IBOutlet var categoryCollectionView : UICollectionView!
    
    // MARK: -  Model Container View
    @IBOutlet var modelImage : UIImageView!
    @IBOutlet var modelContainerView : UIView!
    @IBOutlet var modelItemImagesContainerView : UIView!
    @IBOutlet var modelImageAspectConstraint : NSLayoutConstraint!
    
    @IBOutlet var topMainImageView : ClothingItemImageView!
    @IBOutlet var topSecondaryImageView : ClothingItemImageView!
    @IBOutlet var bottomImageView : ClothingItemImageView!
    @IBOutlet var shoeImageView : ClothingItemImageView!
    @IBOutlet var earringsImageView : ClothingItemImageView!
    
    
    @IBOutlet var dragDropImageView : UIImageView!
    @IBOutlet var dragImgViewConstraintX : NSLayoutConstraint!
    @IBOutlet var dragImgViewConstraintY : NSLayoutConstraint!
    @IBOutlet var dragImgViewConstraintWidth : NSLayoutConstraint!
    @IBOutlet var dragImgViewConstraintHeight : NSLayoutConstraint!

    
    
    @IBOutlet var rearModelImage : UIImageView!
    @IBOutlet var rearModelItemImagesContainerView : UIView!
    @IBOutlet var rearModelImageAspectConstraint : NSLayoutConstraint!
    @IBOutlet var rearModelImageHeightConstraint : NSLayoutConstraint!
    @IBOutlet var rearTopMainImageView : ClothingItemImageView!
    @IBOutlet var rearTopSecondaryImageView : ClothingItemImageView!
    @IBOutlet var rearBottomImageView : ClothingItemImageView!
    @IBOutlet var rearShoeImageView : ClothingItemImageView!
    @IBOutlet var rearEarringsImageView : ClothingItemImageView!
    
    @IBOutlet var hairRearImageView : ClothingItemImageView!

    
    
    // MARK: -  Model View Mode
    var viewMode : ViewMode = ViewMode.front
    @IBOutlet var flipButton : UIButton!
    var fetchingRearAssets = false

    @IBOutlet var actionPanel : UIView!
    @IBOutlet var screenshotButtonHConstraint : NSLayoutConstraint!
    @IBOutlet var shareButtonHConstraint : NSLayoutConstraint!

    
    // MARK: -   Items Data Model
    var earringsArray : [ShoeItem] = []
    var topsMainArray : [ShoeItem] = []
    var topsSecArray : [ShoeItem] = []
    var bottomsArray : [ShoeItem] = []
    var shoeArray : [ShoeItem] = []
    

    
    var currentEarringsItem : ShoeItem? = nil
    var currentTopMainItem : ShoeItem? = nil
    var currentTopSecItem : ShoeItem? = nil
    var currentBottomItem : ShoeItem? = nil
    var currentShoeItem : ShoeItem? = nil
    
    
    var mainItemsArray : [ShoeItem] = [ShoeItem]()
    var totalMainTopsCount = 0
    
    
    // MARK: -   Clothing Items Table View
    @IBOutlet var clothingItemsTableView : UITableView!
    
    
    
    // MARK: -   Drag-n-Drop Pan Gesture Recogniser
    var dragDropPanGestureRecogniser : UIPanGestureRecognizer!
    var dragDropLongPressGestureRecogniser : UILongPressGestureRecognizer!
    var longPressStartPoint : CGPoint!
    var dragDropOriginRect : CGRect!
    var dragDropDestinationRect : CGRect!
    
    // MARK: -  Pagination Related
    var fetchingMoreTopItems = false
    let pageSize = 2
    let pageSizeSecondaryItems = 1
    let pageSizeSecondaryItemsLoadMore = 10

    var firstDataLoad : Bool = false
    var secItemsDownloadQueue : [ClothingType : [ShoeItem : [ShoeItem]]] = [ClothingType.earrings : [:], ClothingType.top_SECONDARY : [:], ClothingType.top_MAIN : [:], ClothingType.shoes : [:]]
    var processingDownloadQueue = false
    
    var fetchingMoreSecItems = false
    var lastItemReached = false
    
    // MARK: -  Size Scale Related
    var firstLayout : Bool = true
    let scale = UIScreen.main.scale
    var sizeFactor : CGPoint!
    var sizeFactorRear : CGPoint!

    var frontModelSize : CGSize!
    var rearModelSize : CGSize!
    
    // MARK: -  Activity Indicator
    var faAnimatedHanger : FAAnimatedHanger!
    
    // MARK: -  Current Selected Item
    var currentItemSelectedForInfoView : ShoeItem? = nil
    var currentClothingTypeForSwap : ClothingType? = nil
    var currentItemDragging : ShoeItem? = nil
    
    
    // MARK: -  Home Container VC
    var homeContainerVC : HomeContainerVC!
    
    // MARK: -  Item Detail VC
    var itemsDetailsVC : ItemsDetailVC? = nil

    
    // MARK: -  Dot Views
    @IBOutlet var earringsDotView : FADotView!
    @IBOutlet var topMainDotView : FADotView!
    @IBOutlet var topSecDotView : FADotView!
    @IBOutlet var bottomDotView : FADotView!
    @IBOutlet var shoesDotView : FADotView!
    
    @IBOutlet var rearEarringsDotView : FADotView!
    @IBOutlet var rearTopMainDotView : FADotView!
    @IBOutlet var rearTopSecDotView : FADotView!
    @IBOutlet var rearBottomDotView : FADotView!
    @IBOutlet var rearShoesDotView : FADotView!
    
    
    @IBOutlet var showJacketsButton : UIButton!
    @IBOutlet var showJacketsButtonTop : NSLayoutConstraint!
    @IBOutlet var showJacketsButtonLeft : NSLayoutConstraint!
    
    var interactiveDotsOn : Bool! = false
    var tapRecogniser : UITapGestureRecognizer!
    var selectedAccessoryDotView : FADotView? = nil

    
    // MARK: -  Info Popup 
    @IBOutlet weak var productContainerView: UIView!
    @IBOutlet weak var productInfoView: UIView!

    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var designerLable: UILabel!
    @IBOutlet weak var costLable: UILabel!
    @IBOutlet weak var brandLable: UILabel!
    
    @IBOutlet weak var productContainerView_X_Constraint: NSLayoutConstraint!
    @IBOutlet weak var productContainerView_Y_Constraint: NSLayoutConstraint!
    @IBOutlet weak var productContainerView_H_Constraint: NSLayoutConstraint!
    @IBOutlet weak var productContainerView_W_Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var infoContainerView_H_Constraint: NSLayoutConstraint!
    @IBOutlet weak var infoContainerView_W_Constraint: NSLayoutConstraint!
    @IBOutlet weak var infoContainerView_X_Constraint: NSLayoutConstraint!
    @IBOutlet weak var infoContainerView_Y_Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var dotViewLeadingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var brandLable_W_Constraint: NSLayoutConstraint!
//    @IBOutlet weak var designerLable_W_Constraint: NSLayoutConstraint!
    


    
    var fontSize : CGFloat!
    let screenSize: CGRect = UIScreen.main.bounds
    var lableWidth : CGFloat!
    
    var currentDragMode : DragMode = DragMode.none
    
    
    
    

    
    
    // MARK: -  Fade Out Timer
    var fadeOutTimer : Timer? = nil

    
    
    // MARK: -  Zoom Controller
    var zoomVC : FAZoomVC!
    var pinchRecognizer : UIPinchGestureRecognizer!
    var zoomStarted : Bool = false
    
    
    // MARK: -  Item Tag Drag Controller
    var itemTagDragVC : TagDragDropVC!
    
    // MARK: -  Item Popup Controller
    //var popupVC : PopupVC!
    
    var shoppingCartController : ShoppingCart!
    
    @IBOutlet var clothingItemsTableView_W_Constraint: NSLayoutConstraint!
    
    // MARK: -  View Controller Delegate Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        ///check if the info.plist contains Photo Library usage  description
        ///if not, hide the share/screenshot button in the action Panel
        
        //Naveen 15/12/2017
        /*if let infoPlistDict = Bundle.main.infoDictionary
        {
            if infoPlistDict["NSPhotoLibraryUsageDescription"] == nil
            {
                self.screenshotButtonHConstraint.constant = 0
                self.shareButtonHConstraint.constant = 0
                self.actionPanel.layoutIfNeeded()
            }
        }*/
        
        
        switch (Constants.deviceIdiom)
        {
            
        case .pad:
            self.clothingItemsTableView_W_Constraint.constant = self.view.frame.size.width * 0.4
            self.clothingItemsTableView.layoutIfNeeded()
            self.fontSize = 15
            
        case .phone:
            self.fontSize = 12
        default: break
            ///print("Unspecified UI idiom")
            
        }

        
        self.currentClothingTypeForSwap = ClothingType.bottom

        self.dragDropImageView.alpha = 0

        
        clothingItemsTableView.delegate = self
        clothingItemsTableView.dataSource = self
        
        
        self.topMainImageView.delegate = self
        self.topSecondaryImageView.delegate = self
        self.bottomImageView.delegate = self
        self.shoeImageView.delegate = self
        self.earringsImageView.delegate = self
        
        
        self.topMainImageView.image = nil
        self.topSecondaryImageView.image = nil
        self.bottomImageView.image = nil
        self.shoeImageView.image = nil
        self.earringsImageView.image = nil

        self.topMainImageView.clothingType = ClothingType.top_MAIN
        self.topSecondaryImageView.clothingType = ClothingType.top_SECONDARY
        self.bottomImageView.clothingType = ClothingType.bottom
        self.shoeImageView.clothingType = ClothingType.shoes
        self.earringsImageView.clothingType = ClothingType.earrings
        
        self.rearModelImage.alpha = 0
        self.rearTopMainImageView.image = nil
        self.rearTopSecondaryImageView.image = nil
        self.rearEarringsImageView.image = nil
        self.rearBottomImageView.image = nil
        self.rearShoeImageView.image = nil
        self.rearTopMainImageView.clothingType = ClothingType.top_MAIN
        self.rearTopSecondaryImageView.clothingType = ClothingType.top_SECONDARY
        self.rearBottomImageView.clothingType = ClothingType.bottom
        self.rearShoeImageView.clothingType = ClothingType.shoes
        self.rearEarringsImageView.clothingType = ClothingType.earrings
//        self.rearTopMainImageView.isUserInteractionEnabled = false
//        self.rearTopSecondaryImageView.isUserInteractionEnabled = false
//        self.rearBottomImageView.isUserInteractionEnabled = false
//        self.rearShoeImageView.isUserInteractionEnabled = false
//        self.rearEarringsImageView.isUserInteractionEnabled = false
        self.hairRearImageView.isUserInteractionEnabled = false
        
        self.rearTopMainImageView.delegate = self
        self.rearTopSecondaryImageView.delegate = self
        self.rearBottomImageView.delegate = self
        self.rearShoeImageView.delegate = self
        self.rearEarringsImageView.delegate = self
        self.rearModelImage.alpha = 0
        self.rearModelItemImagesContainerView.alpha = 0

        
        ///adding pan gesture recognizer to main gesture view
        
//        self.dragDropPanGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(ModelVC.panGestureRecognized(_:)))
//        dragDropPanGestureRecogniser.delegate = self
//        self.view.addGestureRecognizer(dragDropPanGestureRecogniser)
        
        ///adding long press gesture recognizer to main gesture view

        self.dragDropLongPressGestureRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(ModelVC.longPressGestureRecognized(_:)))
        dragDropLongPressGestureRecogniser.minimumPressDuration = 0.2
        dragDropLongPressGestureRecogniser.allowableMovement = 5000
        dragDropLongPressGestureRecogniser.delegate = self
        self.view.addGestureRecognizer(dragDropLongPressGestureRecogniser)
        
        self.tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(ModelVC.tapGestureRecognized(_:)))
        tapRecogniser.delegate = self
        self.view.addGestureRecognizer(tapRecogniser)
        

        self.pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(ModelVC.pinchGestureRecognized(_:)))
        pinchRecognizer.delegate = self
        self.view.addGestureRecognizer(pinchRecognizer)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ModelVC.anItemWasAddedToWardrobe), name: NSNotification.Name(rawValue: Constants.kAddedToWardrobeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ModelVC.anItemWasDeletedFromWardrobe), name: NSNotification.Name(rawValue: Constants.kRemovedFromWardrobeNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ModelVC.userSignedIn), name: NSNotification.Name(rawValue: Constants.kUserSuccessfullySignedInNotif), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ModelVC.userSignedOut), name: NSNotification.Name(rawValue: Constants.kUserSuccessfullySignedOutNotif), object: nil)

    }
    
    // MARK : - Sign In Status Notification
    @objc func userSignedIn()
    {
        self.slideToCategoryAtIndex(self.selectedCategoryIndex, animated: false)
    }
    
    @objc func userSignedOut()
    {
        self.slideToCategoryAtIndex(self.selectedCategoryIndex, animated: false)
    }

    // MARK: - wardrobe NSNotification Handling
    
    @objc func anItemWasAddedToWardrobe()
    {
        self.refreshColorForDotViews()
        if self.currentItemSelectedForInfoView != nil
        {
            self.refreshColorForCurrentInfoView()

        }
    }
    
    @objc func anItemWasDeletedFromWardrobe()
    {
        self.refreshColorForDotViews()
        if self.currentItemSelectedForInfoView != nil
        {
            self.refreshColorForCurrentInfoView()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if(firstLayout == true)
        {
            self.fadeModelContainerView(0)
            self.productContainerView.alpha = 0
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        super.viewDidAppear(animated)
        
        if(firstLayout == true)
        {
            self.view.layoutIfNeeded()
            
            firstLayout = false
            
            
            categoryTopLinerView.layer.shadowColor = UIColor.black.cgColor
            categoryTopLinerView.layer.shadowOffset = CGSize(width: 0, height: -1)
            categoryTopLinerView.layer.shadowOpacity = 0.15
            categoryTopLinerView.layer.shadowRadius = 4
            
            self.dotView.layer.cornerRadius = self.dotView.bounds.size.width / 2
            self.dotView.layer.shadowOpacity = 0.8
            self.dotView.layer.shadowColor = Constants.dotUnselectedColor.cgColor
            self.dotView.layer.shadowOffset = CGSize.zero
            self.dotView.layer.borderWidth = 1.0
            self.dotView.layer.borderColor = UIColor.black.cgColor
            
            
            ///Show Jackets Button UI customization
            self.showJacketsButton.tintColor = UIColor.white
            self.showJacketsButton.backgroundColor = UIColor.gray
            self.showJacketsButton.layer.cornerRadius = self.showJacketsButton.bounds.width / 2.0
            self.showJacketsButton.layer.borderColor = UIColor.black.cgColor
            self.showJacketsButton.layer.shadowColor = UIColor.black.cgColor
            self.showJacketsButton.layer.shadowOpacity = 0.8
            self.showJacketsButton.layer.borderWidth = 1.0
            
            
            
            
            self.productContainerView.layer.masksToBounds = true
            self.productContainerView.layer.borderWidth = 2.0
            self.productContainerView.layer.borderColor = UIColor.black.cgColor
            self.productContainerView.layer.cornerRadius = 20.0
            self.productContainerView.layer.shadowOpacity = 0.8
            self.productContainerView.layer.shadowColor = Constants.dotUnselectedColor.cgColor
            self.productContainerView.layer.shadowOffset = CGSize.zero
            
            self.productContainerView.alpha = 0
            
            //            if(screenSize.size.height >= 480 && screenSize.size.height < 667){
            //
            //                fontSize = 11
            //                lableWidth = 70
            //            }
            //            else{
            
            fontSize = 12
            lableWidth = 110
            //            }
            
            
            self.fadeModelContainerView(0)
            
            
            if self.view.bounds.width <= 320
            {
                var i = 111
                while i <= 555
                {
                    let categLabel = self.categoryContainerView.viewWithTag(i) as? UILabel
                    
                    if categLabel != nil
                    {
                        categLabel?.font = UIFont(name: categLabel!.font.fontName, size: 10)
                    }
                    
                    i += 111
                }
            }
            
            
            // download front and rear model images, assign them, let the layout refresh and then proceed
            self.setProgressHudHidden(false)
            if let frontUrl = Wardrober.shared().modelConfig?.frontAssetUrl
            {
                CommonHelper.checkAndDownloadAsset(imageUrl: frontUrl, completion: { (success : Bool, errorMsg : String?) in
                    
                    self.setProgressHudHidden(true)

                    guard success == true else
                    {
                        ///print("failed to download front asset url (\(errorMsg!))")
                        return
                    }
                    
                    self.modelImage.image = ClothingItemImageView.imageForImageUrl(url: frontUrl)
                    
                    self.setProgressHudHidden(false)

                    if let rearUrl = Wardrober.shared().modelConfig?.rearAssetUrl
                    {
                        CommonHelper.checkAndDownloadAsset(imageUrl: rearUrl, completion: { (success : Bool, errorMsg : String?) in
                            
                            
                            self.setProgressHudHidden(true)

                            if success == false
                            {
                                ///print("failed to download rear asset url (\(errorMsg!))")
                            }
                            
                            self.rearModelImage.image = ClothingItemImageView.imageForImageUrl(url: rearUrl)
                            
                            
                            /////proceed
                            self.adjustModelImageAndRelatedComponents()
                            
                        })
                    }
                    else
                    {
                        ///print("warning : rear Model Image url doesn't exist")
                        /////proceed
                        self.adjustModelImageAndRelatedComponents()

                    }
                    
                    
                })
            }
            else
            {
                //print("error : front Model Image url doesn't exist")
            }

        }
    }
    
    
    func adjustModelImageAndRelatedComponents()
    {
        self.slideToCategoryAtIndex(self.selectedCategoryIndex, animated: false)
        
        
        let newWidth = modelImage.bounds.size.width
        let newHeight = modelImage.bounds.size.height
        
        let mannequin_image_size = self.modelImage.image!.size
        
        
        ////replace the modelImageAspectConstraint
        self.modelImage.removeConstraint(modelImageAspectConstraint)
        var aspectConstraint = NSLayoutConstraint(item: self.modelImage, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.modelImage, attribute: NSLayoutAttribute.height, multiplier: (mannequin_image_size.width / mannequin_image_size.height), constant: 0)
        
        self.modelImage.addConstraint(aspectConstraint)
        self.modelImageAspectConstraint = aspectConstraint
        
        let originalWidth =  mannequin_image_size.width
        let originalHeight = mannequin_image_size.height
        
        sizeFactor = CGPoint(x: newWidth/originalWidth, y: newHeight/originalHeight)
        
        
        
        let rear_mannequin_image_size = self.rearModelImage.image!.size
        let originalWidthRear = rear_mannequin_image_size.width
        let originalHeightRear = rear_mannequin_image_size.height
        
        
        ////replace the rearModelImageAspectConstraint
        self.rearModelImage.removeConstraint(rearModelImageAspectConstraint)
        aspectConstraint = NSLayoutConstraint(item: self.rearModelImage, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.rearModelImage, attribute: NSLayoutAttribute.height, multiplier: (originalWidthRear / originalHeightRear), constant: 0)
        self.rearModelImage.addConstraint(aspectConstraint)
        self.rearModelImageAspectConstraint = aspectConstraint
        
        rearModelImageHeightConstraint.constant =  sizeFactor.y * originalHeightRear
        self.modelContainerView.layoutIfNeeded()
        
        let newWidthRear = rearModelImage.bounds.size.width
        let newHeightRear = rearModelImage.bounds.size.height
        
        sizeFactorRear = CGPoint(x: newWidthRear/originalWidthRear, y: newHeightRear/originalHeightRear)
        
        self.frontModelSize = CGSize(width: self.modelImage.frame.size.width, height: self.modelImage.frame.size.height)
        self.rearModelSize = CGSize(width: self.rearModelImage.frame.size.width, height: self.rearModelImage.frame.size.height)
        
        self.adjustShowJacketButton()
        
        
        self.hairRearImageView.isHidden = true
        self.hairRearImageView.xConstraint.constant = self.sizeFactorRear.x *  70.5
        self.hairRearImageView.yConstraint.constant = self.sizeFactorRear.y * 0.0
        self.hairRearImageView.widhtConstraint.constant = self.sizeFactorRear.x * 84.0
        self.hairRearImageView.heightConstraint.constant = self.sizeFactorRear.y * 107.0
        
        self.rearModelItemImagesContainerView.layoutIfNeeded()
        
        
        //topMainImageView.xConstraint.constant *= sizeFactor.x
        //topMainImageView.yConstraint.constant *= sizeFactor.y
        //topMainImageView.widhtConstraint.constant *= sizeFactor.x
        //topMainImageView.heightConstraint.constant *= sizeFactor.y
        
        //topSecondaryImageView.xConstraint.constant *= sizeFactor.x
        //topSecondaryImageView.yConstraint.constant *= sizeFactor.y
        //topSecondaryImageView.widhtConstraint.constant *= sizeFactor.x
        //topSecondaryImageView.heightConstraint.constant *= sizeFactor.y
        
        //bottomImageView.xConstraint.constant *= sizeFactor.x
        //bottomImageView.yConstraint.constant *= sizeFactor.y
        //bottomImageView.widhtConstraint.constant *= sizeFactor.x
        //bottomImageView.heightConstraint.constant *= sizeFactor.y
        
        //shoeImageView.xConstraint.constant *= sizeFactor.x
        //shoeImageView.yConstraint.constant *= sizeFactor.y
        //shoeImageView.widhtConstraint.constant *= sizeFactor.x
        //shoeImageView.heightConstraint.constant *= sizeFactor.y
        
        //earringsImageView.xConstraint.constant *= sizeFactor.x
        //earringsImageView.yConstraint.constant *= sizeFactor.y
        //earringsImageView.widhtConstraint.constant *= sizeFactor.x
        //earringsImageView.heightConstraint.constant *= sizeFactor.y
    }
    
    
    func adjustShowJacketButton()
    {
        self.showJacketsButtonTop.constant = self.sizeFactor.y * CGFloat(90)
        self.showJacketsButtonLeft.constant = self.sizeFactor.x * CGFloat(20)
        self.modelItemImagesContainerView.layoutIfNeeded()
        
    }
    
    
    // MARK: - Fade/Unfade Model Container and Image Container view
    func fadeModelContainerView(_ alphaValue : CGFloat)
    {
        self.view.isUserInteractionEnabled = false
        
        self.modelContainerView.alpha = alphaValue
        
        self.productContainerView.alpha = alphaValue

        self.clothingItemsTableView.alpha = alphaValue
        
        self.actionPanel.alpha = alphaValue

    }
    
    func unfadeModelContainerView()
    {
        self.view.isUserInteractionEnabled = true
        
        self.modelContainerView.alpha = 1
    }

    
    // MARK: - Category Container Related
    func slideToCategoryAtIndex(_ index : Int, animated : Bool)
    {
        if animated == true
        {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: UIViewAnimationOptions(), animations: {
                
                
                self.categoryCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
                
                
                let selectedIndex = CGFloat(index)
                let categoryLabelSelected : UILabel!
                switch selectedIndex
                {
                case 0:
                    categoryLabelSelected = self.categoryContainerView.viewWithTag(111) as! UILabel
                    break
                    
                case 1:
                    categoryLabelSelected = self.categoryContainerView.viewWithTag(222) as! UILabel
                    break
                    
                case 2:
                    categoryLabelSelected = self.categoryContainerView.viewWithTag(333) as! UILabel
                    break
                    
                case 3:
                    categoryLabelSelected = self.categoryContainerView.viewWithTag(444) as! UILabel
                    break
                    
                case 4:
                    categoryLabelSelected = self.categoryContainerView.viewWithTag(555) as! UILabel
                    break
                    
                default :
                    categoryLabelSelected = self.categoryContainerView.viewWithTag(111) as! UILabel
                    break
                    
                }
                
                self.categoryContainerView.removeConstraint(self.categoryUnderlinerViewCenterXConstraint)
                //self.categoryContainerView.removeConstraint(self.categoryUnderlinerViewWidthConstraint)
                
                self.categoryUnderlinerViewCenterXConstraint = NSLayoutConstraint(item: self.categoryUnderlinerView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: categoryLabelSelected, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0)
                //self.categoryUnderlinerViewWidthConstraint = NSLayoutConstraint(item: self.categoryUnderlinerView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: categoryLabelSelected, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0)
                self.categoryUnderlinerViewWidthConstraint.constant = categoryLabelSelected.intrinsicContentSize.width
                
                //self.categoryUnderlinerView.layoutIfNeeded()
                
                self.categoryContainerView.addConstraints([self.categoryUnderlinerViewCenterXConstraint])
                
                
                self.categoryContainerView.layoutIfNeeded()
                
            }) { (finished) in
               
                
                self.topsMainArray.removeAll()
                self.earringsArray.removeAll()
                self.bottomsArray.removeAll()
                self.topsSecArray.removeAll()
                self.shoeArray.removeAll()

                
                self.firstDataLoad = true
                self.fetchingMoreTopItems  = true
                
                let selectedCategory = Wardrober.shared().categories[self.selectedCategoryIndex]
                
                self.fetchClothingItems(selectedCategory.categoryId, startIndex: 1, pageSize: self.pageSize, secondaryItemsPageSize: self.pageSizeSecondaryItems)
            }
        }
        else
        {
            
            self.categoryCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            
            let selectedIndex = CGFloat(index)
            let categoryLabelSelected : UILabel!
            switch selectedIndex
            {
            case 0:
                categoryLabelSelected = self.categoryContainerView.viewWithTag(111) as! UILabel
                break
                
            case 1:
                categoryLabelSelected = self.categoryContainerView.viewWithTag(222) as! UILabel
                break
                
            case 2:
                categoryLabelSelected = self.categoryContainerView.viewWithTag(333) as! UILabel
                break
                
            case 3:
                categoryLabelSelected = self.categoryContainerView.viewWithTag(444) as! UILabel
                break
                
            case 4:
                categoryLabelSelected = self.categoryContainerView.viewWithTag(555) as! UILabel
                break
                
            default :
                categoryLabelSelected = self.categoryContainerView.viewWithTag(111) as! UILabel
                break
                
            }
            
            self.categoryContainerView.removeConstraint(self.categoryUnderlinerViewCenterXConstraint)
            //self.categoryContainerView.removeConstraint(self.categoryUnderlinerViewWidthConstraint)
            
            self.categoryUnderlinerViewCenterXConstraint = NSLayoutConstraint(item: self.categoryUnderlinerView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: categoryLabelSelected, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0)
            //self.categoryUnderlinerViewWidthConstraint = NSLayoutConstraint(item: self.categoryUnderlinerView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: categoryLabelSelected, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0)
            self.categoryContainerView.addConstraints([self.categoryUnderlinerViewCenterXConstraint])
            
            self.categoryUnderlinerViewWidthConstraint.constant = categoryLabelSelected.intrinsicContentSize.width
            //self.categoryUnderlinerView.layoutIfNeeded()
            
            self.categoryContainerView.layoutIfNeeded()

            
            self.topsMainArray.removeAll()
            self.earringsArray.removeAll()
            self.bottomsArray.removeAll()
            self.topsSecArray.removeAll()
            self.shoeArray.removeAll()

            firstDataLoad = true
            self.fetchingMoreTopItems  = true
            
            let selectedCategory = Wardrober.shared().categories[self.selectedCategoryIndex]
            
            
            self.fetchClothingItems(selectedCategory.categoryId, startIndex: 1, pageSize: self.pageSize, secondaryItemsPageSize: self.pageSizeSecondaryItems)
        }
        
        
        
    }
    
    @IBAction func categoryTapped(_ sender : UIButton!)
    {
    

        if viewMode == ViewMode.rear
        {
            self.flipBtnTapped(self.flipButton)
        }
        
        self.fadeModelContainerView(0.3)
        selectedCategoryIndex = sender.tag - 1
        self.slideToCategoryAtIndex(selectedCategoryIndex, animated: true)
        
        
    }
    
    
    
    // MARK: - Fetching Clothing items from the server
    
    func fetchClothingItems(_ categoryID : String, startIndex : Int, pageSize : Int, secondaryItemsPageSize : Int)
    {
        
        if startIndex == 1
        {
            self.setProgressHudHidden(false)
        }
        
        var customerID = "0"
        
        let userSignedIn =   UserDefaults.standard.bool(forKey: Constants.kUserSuccessfullySignedIn)
        
        if userSignedIn == true
        {
            customerID = UserDefaults.standard.object(forKey: Constants.kSignedInUserID) as! String!
            
        }
        
        //call the service and get the data
        let url = String(format: "%@/%@", arguments: [Wardrober.shared().serviceMainUrl!,Urls.GetProductCatalogV2]);
        
        let requestDict =  ClothingItemsHelper.getRequestDictForGetCatalogServiceV2(categoryID, customerID :  customerID, startIndex: "\(startIndex)", pageSize: "\(pageSize)", secondaryItemsPageSize: "\(self.pageSizeSecondaryItems)")
        
        FAServiceHelper().post(url: url, parameters: requestDict as NSDictionary  , completion : { (success : Bool?, message : String?, responseObject : AnyObject?) in
            
            guard success == true else
            {
                
                self.hideModelInteractiveElements(true)
                
                self.fetchingMoreTopItems = false
                
                
                if startIndex == 1
                {
                    self.setProgressHudHidden(true)
                }
                
                let alert=UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert);
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
                
                self.present(alert, animated: true, completion: nil)
                
                self.view.isUserInteractionEnabled = true
                
                return
            }
            
            guard responseObject == nil else
            {
                let (itemsArray, count, errorMsg) = ClothingItemsHelper.parseFetchCatalogV2Response(responseObject as AnyObject?)
                
                if errorMsg == nil
                {
                    self.totalMainTopsCount = count!
                    
                    if startIndex == 1
                    {
                        //first time
                        self.mainItemsArray = itemsArray!
                        
                    }
                    else
                    {
                        self.mainItemsArray.append(contentsOf: itemsArray!)
                        
                    }
                    if self.mainItemsArray.count == 0
                    {
                        
                        self.setProgressHudHidden(true)
                        
                        self.hideModelInteractiveElements(true)
                        
                        let alert=UIAlertController(title: "Wardrober", message: "Sorry there are currently no items available for this category", preferredStyle: UIAlertControllerStyle.alert);
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
                        
                        self.navigationController?.present(alert, animated: true, completion: nil)
                        
                        self.view.isUserInteractionEnabled = true
                        
                        
                    }
                    else
                    {
                        ///start downloading images in queued fashion for the new top items
                        self.downloadAssets()
                    }
                    
                }
                else
                {
                    self.fetchingMoreTopItems = false
                    
                    
                    self.view.isUserInteractionEnabled = true
                    
                    if startIndex == 1
                    {
                        self.setProgressHudHidden(true)
                    }
                    
                    let alert=UIAlertController(title: "Alert", message: errorMsg, preferredStyle: UIAlertControllerStyle.alert);
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                return
            }
            
        })
    }
    
    
    
    func fetchMoreSecondaryItemsOfType( _ type : ClothingType, forMainTop mainTopID : String, startIndex : Int, pageSize : Int)
    {
        var customerID = "0"
        
        let userSignedIn =   UserDefaults.standard.bool(forKey: Constants.kUserSuccessfullySignedIn)
        
        if userSignedIn == true
        {
            customerID = CommonHelper.getCustomerID()
            
        }
        var url : String!
        
        let parametersDict = ClothingItemsHelper.getRequestDictForFetchMoreSecondaryItems(mainTopID, customerID: customerID, startIndex: "\(startIndex)", pageSize: "\(pageSize)")
        
        switch type{
            
        case ClothingType.earrings:
            url = String(format: "%@/%@", arguments: [Wardrober.shared().serviceMainUrl!,Urls.GetEarByProductTopId]);
            
            break
        case ClothingType.top_SECONDARY:
            url = String(format: "%@/%@", arguments: [Wardrober.shared().serviceMainUrl!,Urls.GetJacketByProductTopId]);
            
            break
            
        case ClothingType.top_MAIN:
            url = String(format: "%@/%@", arguments: [Wardrober.shared().serviceMainUrl!,Urls.GetTopsByProductId]);
            
            break
            
        case ClothingType.shoes:
            url = String(format: "%@/%@", arguments: [Wardrober.shared().serviceMainUrl!,Urls.GetShooeByProductTopId]);
            break
            
        default:
            return
        }
        
        
        FAServiceHelper().post(url: url, parameters: parametersDict as NSDictionary  , completion : { (success : Bool?, message : String?, responseObject : AnyObject?) in
            
            guard success == true else
            {
                
                self.fetchingMoreSecItems = false
                
                self.view.isUserInteractionEnabled = true
                
                let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert);
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
                
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            guard responseObject == nil else
            {
                
                let (itemsArray, mainTopItemID, errorMsg) = ClothingItemsHelper.parseFetchMoreSecondaryItemsResponse(responseObject as AnyObject?, forItemType: type)
                
                if errorMsg == nil
                {
                    
                    let matchingMainTops = self.topsMainArray.filter({ (item : ShoeItem) -> Bool in
                        return item.itemProductID == mainTopItemID
                    })
                    
                    var matchingMainTop : ShoeItem? = nil
                    if matchingMainTops.count > 0
                    {
                        matchingMainTop = matchingMainTops.first
                    }
                    
                    
                    ///check and add these new items to the downloadQueue
                    
                    var downloadDictForCurrentType = self.secItemsDownloadQueue[type]
                    if let downloadQueueForMainTop = downloadDictForCurrentType![matchingMainTop!]
                    {
                        ///check and append only new items
                        var newItemsToAdd = [ShoeItem]()
                        for item in itemsArray!
                        {
                            let arr = downloadQueueForMainTop.filter({ (clothingItem : ShoeItem) -> Bool in
                                
                                return item.itemProductID == clothingItem.itemProductID
                                
                            })
                            
                            if arr.count == 0
                            {
                                newItemsToAdd.append(item)
                            }
                        }
                        
                        self.secItemsDownloadQueue[type]![matchingMainTop!]!.append(contentsOf: newItemsToAdd)
                        
                    }
                    else
                    {
                        ///add items array to the queue and then to the dict
                        
                        self.secItemsDownloadQueue[type]![matchingMainTop!] = itemsArray!
                        
                    }
                    
                    self.fetchingMoreSecItems = false
                    
                    
                    /////Process the Queue
                    self.processDownloadQueue()
                    
                }
                else
                {
                    self.fetchingMoreSecItems = false
                    
                    self.view.isUserInteractionEnabled = true
                    
                    let alert=UIAlertController(title: "Alert", message: errorMsg, preferredStyle: UIAlertControllerStyle.alert);
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                return
            }
            
        })
        
    }
    
    
    // MARK: - Add to Wardrobe service call
    
    func addItemToWardrobe(_ item : ShoeItem,  add: Bool)
    {
        
        let userSignedIn =   UserDefaults.standard.bool(forKey: Constants.kUserSuccessfullySignedIn)
        
        if userSignedIn == false
        {
            self.presentSignIn()
            return
        }
        else
        {
            let custID = CommonHelper.getCustomerID()
            
            let itemID = item.itemProductID
            
            let url = String(format: "%@/%@", arguments: [Wardrober.shared().serviceMainUrl!,Urls.AddWardrobeinfo]);
            
            var addOrRemove = "0"
            if add == true
            {
                addOrRemove = "1"
            }
            
            let requestDict = WardrobeHelper.getRequestDictForAddToWardrobeService(custID, ProductItemID: itemID!, AddOrRemove: addOrRemove)
            
            FAServiceHelper().post(url: url, parameters: requestDict as NSDictionary  , completion : { (success : Bool?, message : String?, responseObject : AnyObject?) in
                
                guard success == true else
                {
                    
                    item.isAddedToWardrobe = !add
                    
                    self.refreshColorForDotViews()
                    if self.currentItemSelectedForInfoView?.itemProductID == itemID
                    {
                        self.refreshColorForCurrentInfoView()
                    }
                    
                    let alert=UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert);
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    if add == true
                    {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kAddedToWardrobeNotification), object: nil)
                    }
                    else
                    {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kRemovedFromWardrobeNotification), object: nil)
                    }
                    return
                }
                guard responseObject == nil else
                {
                    
                    ///print(responseObject!)
                    
                    let (success, errorMsg) = WardrobeHelper.parseAddToWardrobeResponse(responseObject as AnyObject?)
                    
                    if success == true
                    {
                        
                        item.isAddedToWardrobe = add
                        
                        self.refreshColorForDotViews()
                        if self.currentItemSelectedForInfoView?.itemProductID == itemID
                        {
                            self.refreshColorForCurrentInfoView()
                        }
                    }
                    else
                    {
                        ///print("add to Wishlist failed : \(errorMsg)")
                        
                        item.isAddedToWardrobe = !add
                        
                        self.refreshColorForDotViews()
                        if self.currentItemSelectedForInfoView?.itemProductID == itemID
                        {
                            self.refreshColorForCurrentInfoView()
                        }
                        
                        
                        let alert=UIAlertController(title: "Alert", message: errorMsg, preferredStyle: UIAlertControllerStyle.alert);
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    if add == true
                    {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kAddedToWardrobeNotification), object: nil)
                    }
                    else
                    {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kRemovedFromWardrobeNotification), object: nil)
                    }
                    
                    return
                }
                
            })
            
        }
    }
    
    // MARK: - SignIn Service Calls
    
    func presentSignIn()
    {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kUserNotSignedIn), object: nil, userInfo: nil)
        
    }
    
        
    func setProgressHudHidden(_ hidden : Bool)
    {
        
        if hidden == false
        {
            let storyBoard = UIStoryboard(name: "Checkout", bundle:Bundle(for: Wardrober.self))
            self.faAnimatedHanger = storyBoard.instantiateViewController(withIdentifier: "FAAnimatedHanger") as? FAAnimatedHanger
            
            let childView = self.faAnimatedHanger!.view
            childView?.translatesAutoresizingMaskIntoConstraints = false;
            
            self.addChildViewController(faAnimatedHanger)
            faAnimatedHanger!.didMove(toParentViewController: self)
            self.view.addSubview(childView!)
            self.view.clipsToBounds = true
            
            let xConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0)
            
            let yConstraint =  NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0)
            
            let tConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0)
            
            let bConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
            
            self.view.addConstraints([xConstraint, yConstraint, tConstraint, bConstraint])
            
            self.faAnimatedHanger.view.layoutIfNeeded()
            
        }
        else
        {
            //hide
            self.faAnimatedHanger.view.removeFromSuperview()
        }
    }

    
    func checkForLoadMore(_ indexPath : IndexPath)
    {
        if self.currentClothingTypeForSwap == ClothingType.bottom
        {
            if fetchingMoreTopItems == false
            {
                
                let currentArray = self.getCurrentArray().pointee
                let currentCount = currentArray.count
                
                let totalCount = self.getTotalCountForClothingType(self.currentClothingTypeForSwap!, forMainTopItem: self.currentTopMainItem!)
                ///print("totalTopCount = \(totalCount)")
                if currentCount < totalCount
                {
                    ///print("currentCount = \(currentCount)")
                    
                    
                    let middleIndexApprox = Int(floor(Float(currentCount) / 2) - 1)
                    
                    if indexPath.row >= middleIndexApprox
                    {
                        
                        if self.fetchingMoreTopItems == false
                        {
                            self.fetchingMoreTopItems = true
                            
                            let selectedCategory = Wardrober.shared().categories[self.selectedCategoryIndex]
                            
                            
                            self.fetchClothingItems(selectedCategory.categoryId, startIndex: currentCount + 1, pageSize: self.pageSize, secondaryItemsPageSize: self.pageSizeSecondaryItems)
                            
                        }
                    }
                    
                }
                
                
            }
        }
        else
        {
            let downloadDictForCurrentItemType = self.secItemsDownloadQueue[self.currentClothingTypeForSwap!] as [ShoeItem : [ShoeItem]]!
        
            let downloadQueueForCurrentMainTop = downloadDictForCurrentItemType?[self.currentTopMainItem!]
            
            if downloadQueueForCurrentMainTop != nil
            {
                ///Process the queue
                self.processDownloadQueue()
            }
            else
            {
                ///download and add items to queue and then process it
                let currentArray = self.getCurrentArray().pointee
                let currentCount = currentArray.count
                
                let totalCount = self.getTotalCountForClothingType(self.currentClothingTypeForSwap!, forMainTopItem: self.currentTopMainItem!)
                ///////print("totalTopCount = \(totalCount)")
                if currentCount < totalCount
                {
                    ///////print("currentCount = \(currentCount)")
                    
                   /// let middleIndexApprox = Int(ceil(Float(currentCount) / 2) - 1)
                    
                    if indexPath.row == currentCount - 1
                    {
                        ////call the service
                        if self.fetchingMoreSecItems == false
                        {
                            self.fetchingMoreSecItems = true
                            self.fetchMoreSecondaryItemsOfType(self.currentClothingTypeForSwap!, forMainTop: self.currentTopMainItem!.itemProductID, startIndex: currentCount + 1, pageSize: self.pageSizeSecondaryItemsLoadMore)
                        }
                       
                    }
                    
                }

            }
 
        }
        
        
    }
    
    
    // MARK: - Download Asset Images
    @objc func downloadAssets()
    {
        ///print("downloadAssets called when topsMainArray.count = \(topsMainArray.count)")
        let i = topsMainArray.count
        if i < mainItemsArray.count
        {
            let mainItem = mainItemsArray[i]
            
            CommonHelper.checkAndDownloadFrontAsset(item: mainItem) { (success : Bool, errorMsg : String?) in
                
                self.performSecondaryItemsDownloadForMainItem(mainItem)

            }
            
            
        }
        else
        {
            ///print("fetchingMoreTopItems set to false")
            self.fetchingMoreTopItems = false
        }
    }
    
    
    
    func performSecondaryItemsDownloadForMainItem(_ mainItem : ShoeItem)
    {
        //download ER items
        
        if(mainItem.earringsArray.count == 0 && mainItem.topSecArray.count == 0 && mainItem.bottomsArray.count == 0 && mainItem.shoesArray.count == 0)
        {
            self.checkForCompletion(mainItem)
        }
        
        for item in mainItem.earringsArray
        {
            
            CommonHelper.checkAndDownloadFrontAsset(item: item) { (success : Bool, errorMsg : String?) in
                
                self.checkForCompletion(mainItem)
                
            }
            
            
            

        }
        
        //download TS items
        
        for item in mainItem.topSecArray
        {
            CommonHelper.checkAndDownloadFrontAsset(item: item) { (success : Bool, errorMsg : String?) in
                
                self.checkForCompletion(mainItem)
                
            }
            
            
            
            
        }
        
        //download BT items
        
        for item in mainItem.bottomsArray
        {
            
            CommonHelper.checkAndDownloadFrontAsset(item: item) { (success : Bool, errorMsg : String?) in
                
                self.checkForCompletion(mainItem)
                
            }
            
            
            
        }
        
        //download SH items
        
        for item in mainItem.shoesArray
        {
            CommonHelper.checkAndDownloadFrontAsset(item: item) { (success : Bool, errorMsg : String?) in
                
                self.checkForCompletion(mainItem)
                
            }
            
            
        }
    }
    
    
    func checkForCompletion(_ mainTopItem : ShoeItem)
    {
        ///print("checkForCompletion \(mainTopItem.itemName)")
        
        for item in mainTopItem.earringsArray
        {
            if item.isAssetDownloaded == false
            {
                return
            }
        }
        
        for item in mainTopItem.topSecArray
        {
            if item.isAssetDownloaded == false
            {
                return
            }
        }
        
        for item in mainTopItem.bottomsArray
        {
            if item.isAssetDownloaded == false
            {
                return
            }
        }
        
        for item in mainTopItem.shoesArray
        {
            if item.isAssetDownloaded == false
            {
                return
            }
        }
        
        
        self.topsMainArray.append(mainTopItem)
        ///print("appending \(mainTopItem)")
        self.lastItemReached = false

        let pass = self.mainItemsArray.index(of: mainTopItem)
        
        if pass > 0
        {

                ///reload TableView data
                self.clothingItemsTableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.automatic)
                self.view.layoutIfNeeded()
                
                ///print("pass \(pass)")
                self.perform(#selector(ModelVC.downloadAssets), with: nil, afterDelay: 0.01)
            
                
                return
            
        }
        
        
//        self.fetchingMoreTopItems = false
        
        self.earringsArray = self.mainItemsArray[0].earringsArray
        self.topsSecArray  = self.mainItemsArray[0].topSecArray
        self.bottomsArray  = self.mainItemsArray[0].bottomsArray
        self.shoeArray     = self.mainItemsArray[0].shoesArray
        
        
        
        var mainTopItem : ShoeItem? = nil
        var secTopItem : ShoeItem? = nil
        var earringsItem : ShoeItem? = nil
        var bottomItem : ShoeItem? = nil
        var shoeItem : ShoeItem? = nil
        
        
        var selectedItemsArray = [ShoeItem]()
        if topsMainArray.count > 0
        {
            mainTopItem = topsMainArray[0]
            
            selectedItemsArray.append(mainTopItem!)
            
            self.currentTopMainItem = mainTopItem

        }
        else
        {
            self.currentTopMainItem = nil
        }
        
        if topsSecArray.count > 0
        {
            secTopItem = topsSecArray[0]
            selectedItemsArray.append(secTopItem!)
            
            self.currentTopSecItem = secTopItem
        }
        else
        {
            self.currentTopSecItem = nil
        }
        
        if earringsArray.count > 0
        {
            earringsItem = earringsArray[0]
            selectedItemsArray.append(earringsItem!)
            
            self.currentEarringsItem = earringsItem
        }
        else
        {
            self.currentEarringsItem = nil
            
        }
        
        
        if bottomsArray.count > 0
        {
            bottomItem = bottomsArray[0]
            selectedItemsArray.append(bottomItem!)
            
            self.currentBottomItem = bottomItem
        }
        else
        {
            self.currentBottomItem = nil
        }
        
        
        if shoeArray.count > 0
        {
            shoeItem = shoeArray[0]
            selectedItemsArray.append(shoeItem!)
            
            self.currentShoeItem = shoeItem
        }
        else
        {
            self.currentShoeItem = nil
        }
        
        
        self.perform(#selector(ModelVC.checkRearAssets), with: nil, afterDelay: 0.01)
        
        
        self.topMainImageView.image = nil
        self.topSecondaryImageView.image = nil
        self.earringsImageView.image = nil
        self.bottomImageView.image = nil
        self.shoeImageView.image = nil
        
        
        
        if mainTopItem != nil
        {
            
            for shoeItem in selectedItemsArray
            {
                let clothingItemImageView = self.getImageViewForItem(shoeItem)
                
                clothingItemImageView.xConstraint.constant = self.frontModelSize.width *  shoeItem.assetSizeSpecs.assetBoundsFront.xPos!
                clothingItemImageView.yConstraint.constant = self.frontModelSize.height * shoeItem.assetSizeSpecs.assetBoundsFront.yPos!
                clothingItemImageView.widhtConstraint.constant = self.frontModelSize.width * shoeItem.assetSizeSpecs.assetBoundsFront.width!
                clothingItemImageView.heightConstraint.constant = self.frontModelSize.height * shoeItem.assetSizeSpecs.assetBoundsFront.height!
                
                clothingItemImageView.image = ClothingItemImageView.imageForImageUrl(url: shoeItem.itemImageURL!)
                
                
               
                self.updateDotViewPositionFor(clothItem: shoeItem)
                
            }
            
            
            
            self.reorderImageViewsWithZOrder()
            self.refreshColorForDotViews()


            
        }
        
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.layoutIfNeeded()
            
            
            self.unfadeModelContainerView()
            self.setProgressHudHidden(true)
            
        }, completion: { (finished) in
            
            
            self.lastItemReached = false
            self.clothingItemsTableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.automatic)
            self.view.layoutIfNeeded()
            
            
            self.unhideDotViews(true)
            self.startFadeOutTimer()

            self.actionPanel.alpha = 1
            
            if let currentSelectedItem =  self.getCurrentItemForClothingType(self.currentClothingTypeForSwap!)
            {
                self.clothingItemImageViewDidTap(self.getImageViewForItem(currentSelectedItem))
            }
            else
            {
                self.currentClothingTypeForSwap = ClothingType.bottom
                
                if let currentSelectedItem =  self.getCurrentItemForClothingType(self.currentClothingTypeForSwap!)
                {
                    self.clothingItemImageViewDidTap(self.getImageViewForItem(currentSelectedItem))

                }
            }

            
//            self.performSelector(#selector(ModelVC.downloadAssets), withObject: nil, afterDelay: 0.01)
            
            
        }) 
        
        
    }
    
    
    @objc func processDownloadQueue()
    {
        if self.currentClothingTypeForSwap! == ClothingType.bottom
        {
            return
        }
        
        if processingDownloadQueue == false
        {
            processingDownloadQueue = true
            
            let currentType : ClothingType! = self.currentClothingTypeForSwap!
            let currentMainTop : ShoeItem! = self.currentTopMainItem!
            
            var queueDictForCurrentType = self.secItemsDownloadQueue[currentType]
            
            if let itemsQueue = queueDictForCurrentType![currentMainTop]
            {
                if itemsQueue.count > 0
                {
                    let item = itemsQueue.first as ShoeItem!
                    
                    CommonHelper.checkAndDownloadFrontAsset(item: item!) { (success : Bool, errorMsg : String?) in
                        
                        self.appendSecItemAssetCompleted(secItem: item!, forMainTop: currentMainTop, andClothingType: currentType)
                        ////append Item To Where It belongs (to the correct Main Top and clothingType) and refresh the UI if required
                        
                        self.secItemsDownloadQueue[currentType]![currentMainTop]!.removeFirst()
                        
                        self.processingDownloadQueue = false
                        self.perform(#selector(ModelVC.processDownloadQueue), with: nil, afterDelay: 0.1)
                        
                    }
                    

                }
                else
                {
                    self.secItemsDownloadQueue[self.currentClothingTypeForSwap!]?.removeValue(forKey: self.currentTopMainItem!)
                    
                    self.processingDownloadQueue = false
                   /////// self.performSelector(#selector(ModelVC.processDownloadQueue), withObject: nil, afterDelay: 0.1)
                }
            }
            else
            {
                self.processingDownloadQueue = false

            }
            
        }
    }
    
    
    func appendSecItemAssetCompleted(secItem item : ShoeItem, forMainTop mainTop : ShoeItem, andClothingType type : ClothingType)
    {
        let tops = self.topsMainArray.filter({ (mTop) -> Bool in
            
            return mTop.itemProductID == mainTop.itemProductID
            
        })
        
        var matchingTop : ShoeItem? = nil
        if tops.count > 0
        {
            matchingTop = tops.first
        }
        
        if matchingTop == nil
        {
            return
        }
        
        switch type {
        case ClothingType.earrings:
            
            if self.doesItemAlreadyExistsInArray(item, itemsArray: matchingTop!.earringsArray) == false
            {
                matchingTop!.earringsArray.append(item)

            }
            
            break
            
        case ClothingType.top_SECONDARY:
            
            if self.doesItemAlreadyExistsInArray(item, itemsArray: matchingTop!.topSecArray) == false
            {
                matchingTop!.topSecArray.append(item)
            }

            break
            
        case ClothingType.top_MAIN:
            
            if self.doesItemAlreadyExistsInArray(item, itemsArray: matchingTop!.bottomsArray) == false
            {
                matchingTop!.bottomsArray.append(item)
            }

            break
            
            
        case ClothingType.shoes:

            if self.doesItemAlreadyExistsInArray(item, itemsArray: matchingTop!.shoesArray) == false
            {
                matchingTop!.shoesArray.append(item)
            }
            break
            
        default:
            break
        }
        
        self.loadSecondaryItemsForTopIndex(self.mainItemsArray.index(of: matchingTop!)!)
        
        if type == self.currentClothingTypeForSwap && self.currentTopMainItem! == matchingTop!
        {
            ///reload TableView data
            self.lastItemReached = false
            self.clothingItemsTableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.automatic)
            self.view.layoutIfNeeded()
            
        }

        
    }
    
    
    func loadSecondaryItemsForTopIndex(_ index : Int)
    {
        self.earringsArray = self.mainItemsArray[index].earringsArray
        self.topsSecArray  = self.mainItemsArray[index].topSecArray
        self.bottomsArray  = self.mainItemsArray[index].bottomsArray
        self.shoeArray     = self.mainItemsArray[index].shoesArray

    }
    
    
    @objc func checkRearAssets()
    {
        self.flipButton.isEnabled = false
        
        
        ///placing the existence of top and jacket rear assets above than others.
        
        if let item = self.currentTopMainItem
        {
            if item.rearItemImageURL == nil
            {
                if self.firstDataLoad == true
                {
                    self.firstDataLoad = false
                    
                    self.perform(#selector(ModelVC.downloadAssets), with: nil, afterDelay: 0.01)
                    
                }
                return
            }
            else
            {
                if item.isRearAssetDownloaded == false && item.isRearAssetDownloading == false
                {
                    self.downloadRearAsset(forItem: item)
                    return
                }
            }
            
            
        }
        
        
        if let item = self.currentTopSecItem
        {
            if item.rearItemImageURL == nil
            {
                if self.firstDataLoad == true
                {
                    self.firstDataLoad = false
                    
                    self.perform(#selector(ModelVC.downloadAssets), with: nil, afterDelay: 0.01)
                    
                }
                return
            }
            
            if item.isRearAssetDownloaded == false && item.isRearAssetDownloading == false && item.rearItemImageURL != nil
            {
                self.downloadRearAsset(forItem: item)
                return
            }
        }
        
        
        if let item = self.currentBottomItem
        {
            if item.rearItemImageURL == nil
            {
                if self.firstDataLoad == true
                {
                    self.firstDataLoad = false
                    
                    self.perform(#selector(ModelVC.downloadAssets), with: nil, afterDelay: 0.01)
                    
                }
                return
            }
            
            if item.isRearAssetDownloaded == false && item.isRearAssetDownloading == false && item.rearItemImageURL != nil
            {
                self.downloadRearAsset(forItem: item)
                return
            }
        }
        
        
        
        
        if let item = self.currentShoeItem
        {
            if item.rearItemImageURL == nil
            {
                if self.firstDataLoad == true
                {
                    self.firstDataLoad = false
                    
                    self.perform(#selector(ModelVC.downloadAssets), with: nil, afterDelay: 0.01)
                    
                }
                return
            }
            
            if item.isRearAssetDownloaded == false && item.isRearAssetDownloading == false && item.rearItemImageURL != nil
            {
                self.downloadRearAsset(forItem: item)
                return
            }
        }
        
        
        

        
//        if let item = self.currentEarringsItem
//        {
//            if item.rearItemImageURL == nil
//            {
//                if self.firstDataLoad == true
//                {
//                    self.firstDataLoad = false
//                    
//                    self.performSelector(#selector(ModelVC.downloadAssets), withObject: nil, afterDelay: 0.01)
//                    
//                }
//                return
//            }
//            
//            if item.isRearAssetDownloaded == false && item.isRearAssetDownloading == false && item.rearItemImageURL != nil
//            {
//                self.downloadRearAsset(forItem: item)
//                return
//            }
//        }
        
        self.flipButton.isEnabled = true
        
        if self.firstDataLoad == true
        {
            self.firstDataLoad = false
            
            self.perform(#selector(ModelVC.downloadAssets), with: nil, afterDelay: 0.01)

        }

        
    }
    
    func downloadRearAsset(forItem item : ShoeItem)
    {
        
        CommonHelper.checkAndDownloadRearAsset(item: item) { (success : Bool, errorMsg : String?) in
            
            self.perform(#selector(ModelVC.checkRearAssets), with: nil, afterDelay: 0.01)
        }
        

    }
    
    
    

    
    
    // MARK: - Table View Data Source / Delegate methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.currentClothingTypeForSwap == nil
        {
            return 0
        }
        
        return self.getCurrentArray().pointee.count
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let item = self.getCurrentArray().pointee[indexPath.row]
        
        let currentItemOfCurrentSwapType = self.getCurrentItemForClothingType(self.currentClothingTypeForSwap!)
        
        if item.itemProductID == currentItemOfCurrentSwapType?.itemProductID
        {
            return 0
        }
        else
        {
            switch (Constants.deviceIdiom)
            {
            case .pad:
                return 300
            case .phone:
                return 186
            default:
                return 186
                
            }

        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClothingItemCell") as! ClothingItemCell

        let itemsArray = self.getArrayForClothingType(self.currentClothingTypeForSwap!).pointee
        
        let shoeItem = itemsArray[indexPath.row]

        cell.itemImageView.image = ClothingItemImageView.imageForImageUrl(url: shoeItem.itemImageURL!)

        cell.designerNameLbl.text = shoeItem.designerName
        cell.itemNameLbl.text = shoeItem.itemName
        cell.priceLbl.text = shoeItem.price
        
        if lastItemReached == false && indexPath.row == self.getCurrentArrayFromMain().pointee.count - 1
        {
            self.lastItemReached = true

            self.checkForLoadMore(indexPath)
        }
        
        return cell
    }
    
    
    
    
    
    // MARK: - Scrollview delegate methods
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.invalidateFadeOutTimer()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.startFadeOutTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if decelerate == false
        {
            self.startFadeOutTimer()
        }
    }
    
    // MARK: - Clothing Item Image View Delegate methods

    func clothingItemImageViewDidTap(_ clothingItemImgView: ClothingItemImageView) {
        
        ///print("ClothingItemImageView tapped")
        
        if interactiveDotsOn == true
        {
            
            if let currentTappedItem = self.getCurrentItemForClothingType(clothingItemImgView.clothingType)
            {
                if currentTappedItem.itemProductID != self.currentItemSelectedForInfoView?.itemProductID
                {
                    self.currentItemSelectedForInfoView = currentTappedItem
                    self.currentClothingTypeForSwap = clothingItemImgView.clothingType
                    
                    
                    ///display products and tag
                    
                    if clothingItemsTableView.alpha == 0 && self.viewMode != .rear
                    {
                        self.unhideTableView(true)
                    }
                    
                    if self.viewMode == .front
                    {
                        self.displayInfoTag(forType: clothingItemImgView.clothingType!)

                    }
                    else{
                        self.displayInfoTagInRearMode(forType: clothingItemImgView.clothingType!)
                        
                    }
                    
                    self.lastItemReached = false
                    ///reload TableView data
                    self.clothingItemsTableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.automatic)
                    self.view.layoutIfNeeded()
                }
                
                
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    if self.currentTopSecItem == nil && self.getArrayForClothingType(ClothingType.top_SECONDARY).pointee.count > 0 && self.currentClothingTypeForSwap != ClothingType.top_SECONDARY
                    {
                        self.showJacketsButton.alpha = 1
                        
                    }
                    else
                    {
                        self.showJacketsButton.alpha = 0
                        
                    }
                    
                    }, completion: { (finshed) in
                        
                        self.showJacketsButton.isUserInteractionEnabled = true
                })
                
            }
            


        }
        else
        {
            self.unhideDotViews(true)
        }
        
        self.startFadeOutTimer()
        
    }
    
    // MARK: - Hide/Unhide ModelContainerView, tableView, action items container together
    func hideModelInteractiveElements(_ hide : Bool)
    {
        if hide == true
        {
            self.modelContainerView.alpha = 0
            self.clothingItemsTableView.alpha = 0
            self.actionPanel.alpha = 0
        }
        else
        {
            self.modelContainerView.alpha = 1
            self.clothingItemsTableView.alpha = 1
            self.actionPanel.alpha = 1
        }

    }
    
    
    // MARK: - hide Unhide Product List View
    func unhideTableView(_ unhide : Bool)
    {
        UIView.animate(withDuration: 0.3, animations: {
            
            if unhide == true
            {
                self.clothingItemsTableView.alpha = 1
            }
            else
            {
                self.clothingItemsTableView.alpha = 0
            }
            
            
            }, completion: { (finished) in
                
                
        }) 
        
    }


    
    // MARK: - hide Unhide Dot Views
    func unhideDotViews(_ unhide : Bool)
    {
        self.modelItemImagesContainerView.bringSubview(toFront: self.earringsDotView)
        self.modelItemImagesContainerView.bringSubview(toFront: self.topMainDotView)
        self.modelItemImagesContainerView.bringSubview(toFront: self.topSecDotView)
        self.modelItemImagesContainerView.bringSubview(toFront: self.bottomDotView)
        self.modelItemImagesContainerView.bringSubview(toFront: self.shoesDotView)
       
        self.rearModelItemImagesContainerView.bringSubview(toFront: self.rearEarringsDotView)
        self.rearModelItemImagesContainerView.bringSubview(toFront: self.rearTopMainDotView)
        self.rearModelItemImagesContainerView.bringSubview(toFront: self.rearTopSecDotView)
        self.rearModelItemImagesContainerView.bringSubview(toFront: self.rearBottomDotView)
        self.rearModelItemImagesContainerView.bringSubview(toFront: self.rearShoesDotView)
        
        
        self.modelItemImagesContainerView.bringSubview(toFront: self.showJacketsButton)
        

        if unhide == true
        {
            self.interactiveDotsOn = true
            //show
            
            UIView.animate(withDuration: 0.3, animations: {
                self.earringsDotView.unhide(true)
                self.topMainDotView.unhide(true)
                self.topSecDotView.unhide(true)
                self.bottomDotView.unhide(true)
                self.shoesDotView.unhide(true)
                
                self.rearEarringsDotView.unhide(true)
                self.rearTopMainDotView.unhide(true)
                self.rearTopSecDotView.unhide(true)
                self.rearBottomDotView.unhide(true)
                self.rearShoesDotView.unhide(true)
                
                
                if self.currentTopSecItem == nil && self.getArrayForClothingType(ClothingType.top_SECONDARY).pointee.count > 0 && self.currentClothingTypeForSwap != ClothingType.top_SECONDARY
                {
                    self.showJacketsButton.alpha = 1
                    
                }
                else
                {
                    self.showJacketsButton.alpha = 0
                    
                }
                
            })
            
            
        }
        else
        {
            self.interactiveDotsOn = false
            //hide
            UIView.animate(withDuration: 0.3, animations: {
                self.earringsDotView.unhide(false)
                self.topMainDotView.unhide(false)
                self.topSecDotView.unhide(false)
                self.bottomDotView.unhide(false)
                self.shoesDotView.unhide(false)
                
                
                self.rearEarringsDotView.unhide(false)
                self.rearTopMainDotView.unhide(false)
                self.rearTopSecDotView.unhide(false)
                self.rearBottomDotView.unhide(false)
                self.rearShoesDotView.unhide(false)
                
                self.showJacketsButton.alpha = 0

                
                self.productContainerView.alpha = 0
                self.currentItemSelectedForInfoView = nil

            })
            
        }
    }

    
    func displayInfoTag(forType type : ClothingType)
    {
        if let item = self.getCurrentItemForClothingType(type)
        {
            
            var dotCenter : CGPoint? = nil
            
            switch item.clothingType!
            {
            case ClothingType.earrings :
                
                dotCenter =  self.modelItemImagesContainerView.convert(self.earringsDotView.center, to: self.view)
                
                selectedAccessoryDotView = self.earringsDotView
                
                break
                
            case ClothingType.top_MAIN:
                
                dotCenter =  self.modelItemImagesContainerView.convert(self.topMainDotView.center, to: self.view)
                
                selectedAccessoryDotView = self.topMainDotView
                
                break
                
            case ClothingType.top_SECONDARY:
                
                dotCenter =  self.modelItemImagesContainerView.convert(self.topSecDotView.center, to: self.view)
                
                selectedAccessoryDotView = self.topSecDotView
                
                break
                
            case ClothingType.bottom:
                
                dotCenter =  self.modelItemImagesContainerView.convert(self.bottomDotView.center, to: self.view)
                selectedAccessoryDotView = self.bottomDotView
                
                break
                
            case ClothingType.shoes:
                
                dotCenter =  self.modelItemImagesContainerView.convert(self.shoesDotView.center, to: self.view)
                
                selectedAccessoryDotView = self.shoesDotView
                
                break
                
            default :
                
                break
                
            }
            
            if let center = dotCenter
            {
                self.dotTappedForItem(item, atPoint: center)
            }
            
        }
    }
    
    
    func displayInfoTagInRearMode(forType type : ClothingType)
    {
        if let item = self.getCurrentItemForClothingType(type)
        {
            
            var dotCenter : CGPoint? = nil
            
            switch item.clothingType!
            {
            case ClothingType.earrings :
                
                dotCenter =  self.rearModelItemImagesContainerView.convert(self.rearEarringsDotView.center, to: self.view)
                
                selectedAccessoryDotView = self.rearEarringsDotView
                
                break
                
            case ClothingType.top_MAIN:
                
                dotCenter =  self.rearModelItemImagesContainerView.convert(self.rearTopMainDotView.center, to: self.view)
                
                selectedAccessoryDotView = self.rearTopMainDotView
                
                break
                
            case ClothingType.top_SECONDARY:
                
                dotCenter =  self.rearModelItemImagesContainerView.convert(self.rearTopSecDotView.center, to: self.view)
                
                selectedAccessoryDotView = self.rearTopSecDotView
                
                break
                
            case ClothingType.bottom:
                
                dotCenter =  self.rearModelItemImagesContainerView.convert(self.rearBottomDotView.center, to: self.view)
                selectedAccessoryDotView = self.rearBottomDotView
                
                break
                
            case ClothingType.shoes:
                
                dotCenter =  self.rearModelItemImagesContainerView.convert(self.rearShoesDotView.center, to: self.view)
                
                selectedAccessoryDotView = self.rearShoesDotView
                
                break
                
            default :
                
                break
                
            }
            
            if let center = dotCenter
            {
                self.dotTappedForItem(item, atPoint: center)
            }
            
        }
    }

    
    
    
    
    func dotTappedForItem(_ item : ShoeItem, atPoint point : CGPoint)
    {
        ///print(point)
        

        let PROD_CONT_VIEW_WIDTH = CGFloat(176) // (CGFloat(174) / 414) * self.view.bounds.size.width
        
        
        self.productContainerView.layoutIfNeeded()
        
        self.currentItemSelectedForInfoView = item
        
        let  x_point : CGFloat = point.x
        
        let  y_point : CGFloat = point.y
        
//        let selectedDot_X_Point = point.x - (32 - self.dotView.bounds.width/CGFloat(2))
        
        
        
        let selectedDot_X_Point = point.x - (self.dotView.bounds.size.width/CGFloat(2))
        
        let selectedDot_Y_Point = point.y - (self.dotView.bounds.size.height/CGFloat(2))
        
        
        
        let destination_X = selectedDot_X_Point - self.dotViewLeadingConstraint.constant
        
        let destination_Y = y_point - (self.productContainerView_H_Constraint.constant / CGFloat(2))
        
        
        
        self.productContainerView.layer.cornerRadius = 0
        
        self.productContainerView.layer.borderColor = UIColor.white.cgColor
        
        
        
        self.infoContainerView_W_Constraint.constant = 0
        
        self.infoContainerView_X_Constraint.constant = 0
        
        self.dotViewLeadingConstraint.constant = 0
        
        
        
        self.productContainerView_H_Constraint.constant = self.dotView.bounds.height
        
        self.productContainerView_W_Constraint.constant = self.dotView.bounds.width
        
        self.productContainerView_X_Constraint.constant = selectedDot_X_Point
        
        self.productContainerView_Y_Constraint.constant = selectedDot_Y_Point
        
        
        
        
        self.productContainerView.layer.cornerRadius = self.dotView.bounds.width/2
        
        
        
        self.productContainerView.layoutIfNeeded()
        
        
        
        self.productContainerView.transform = CGAffineTransform.identity
        
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            self.productContainerView.alpha = 1
            
            
            
            self.productContainerView_X_Constraint.constant = destination_X
            self.productContainerView_Y_Constraint.constant = destination_Y
            self.productContainerView_H_Constraint.constant = 60
            self.productContainerView_W_Constraint.constant = 44
            
            
            self.infoContainerView_H_Constraint.constant = 60
            self.infoContainerView_W_Constraint.constant = 0
            self.infoContainerView_X_Constraint.constant = 12
            
            self.dotViewLeadingConstraint.constant = 17
            
            self.productContainerView.layer.cornerRadius = 20
            
            /////SHOE ITEM DETAILS
            self.costLable.text = item.price
            self.costLable.font = UIFont(name: "HelveticaNeue-Bold", size: self.fontSize)
            self.designerLable.text = item.designerName
            self.designerLable.font = UIFont(name: "HelveticaNeue-Bold", size: self.fontSize)
            self.brandLable.text = item.itemName
            self.brandLable.font = UIFont(name: "HelveticaNeue", size: self.fontSize)
//            self.brandLable_W_Constraint.constant = self.lableWidth
//            self.designerLable_W_Constraint.constant = self.lableWidth
            self.productInfoView.layoutIfNeeded()
            
        }) { (finished) in
            
        }
        
        
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            self.infoContainerView_W_Constraint.constant = PROD_CONT_VIEW_WIDTH - 44 - 17
            
            self.productContainerView_W_Constraint.constant = PROD_CONT_VIEW_WIDTH
            
            self.refreshColorForCurrentInfoView()
            
            
            self.productContainerView.layoutIfNeeded()
            
        }) { (finished) in
            
        }
        
    }
    
    func displayItemsDetailView()
    {
        if self.currentItemSelectedForInfoView == nil
        {
            return
        }
        
        var selectedItems = [ShoeItem]()
        
        if let earringsItem = self.getCurrentItemForClothingType(ClothingType.earrings)
        {
            earringsItem.sizeSelected = nil
            selectedItems.append(earringsItem)
        }

        if let topSecItem = self.getCurrentItemForClothingType(ClothingType.top_SECONDARY)
        {
            topSecItem.sizeSelected = nil
            selectedItems.append(topSecItem)
        }
        

        if let topmainItem = self.getCurrentItemForClothingType(ClothingType.top_MAIN)
        {
            topmainItem.sizeSelected = nil
            selectedItems.append(topmainItem)
        }
      

        if let bottomItem = self.getCurrentItemForClothingType(ClothingType.bottom)
        {
            bottomItem.sizeSelected = nil
            selectedItems.append(bottomItem)
        }
        

        if let shoeItem = self.getCurrentItemForClothingType(ClothingType.shoes)
        {
            shoeItem.sizeSelected = nil
            selectedItems.append(shoeItem)
        }
        
        
        
        if selectedItems.count == 0
        {
            return
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle:Bundle(for: Wardrober.self))
        self.itemsDetailsVC = storyBoard.instantiateViewController(withIdentifier: "ItemsDetailVC") as? ItemsDetailVC
        
        
        itemsDetailsVC!.delegate = self
        itemsDetailsVC!.mode = ITEMS_DETAIL_MODE.model_SCENE
        itemsDetailsVC!.selectedItems = selectedItems
        itemsDetailsVC!.scrollToCenterItemIndex = selectedItems.index(of: self.currentItemSelectedForInfoView!)
        
        
        let childView = self.itemsDetailsVC!.view
        childView?.translatesAutoresizingMaskIntoConstraints = false;
        
        
        
        self.homeContainerVC.addChildViewController(itemsDetailsVC!)
        itemsDetailsVC!.didMove(toParentViewController: self.homeContainerVC)
        self.homeContainerVC.view.addSubview(childView!)
        self.homeContainerVC.view.clipsToBounds = true;
        
        self.homeContainerVC.view.addConstraint(NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0.0))
        self.homeContainerVC.view.addConstraint(NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0))
        self.homeContainerVC.view.addConstraint(NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0))
        self.homeContainerVC.view.addConstraint(NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
        
        self.homeContainerVC.view.layoutIfNeeded()
        
        
        itemsDetailsVC!.itemsCollectionView.scrollToItem(at: IndexPath(item: itemsDetailsVC!.scrollToCenterItemIndex, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
//        itemsDetailsVC!.itemsCollectionView.reloadData()
//        itemsDetailsVC!.view.layoutIfNeeded()

    }
    
    // MARK: - get DotView for item
    func getDotViewForItem(_ item : ShoeItem) -> FADotView
    {
        var dotView : FADotView!
        switch item.clothingType!
        {
        case ClothingType.earrings:
            dotView = earringsDotView
            break
            
        case ClothingType.top_MAIN:
            dotView = topMainDotView
            break
            
        case ClothingType.top_SECONDARY:
            dotView = topSecDotView
            break
            
        case ClothingType.bottom:
            dotView = bottomDotView
            break
            
        case ClothingType.shoes:
            dotView = shoesDotView
            break
            
        default:
            dotView = topMainDotView
            break
        }
        
        return dotView
    }
    
    // MARK: - get RearDotView for item
    func getRearDotViewForItem(_ item : ShoeItem) -> FADotView
    {
        var dotView : FADotView!
        switch item.clothingType!
        {
        case ClothingType.earrings:
            dotView = rearEarringsDotView
            break
            
        case ClothingType.top_MAIN:
            dotView = rearTopMainDotView
            break
            
        case ClothingType.top_SECONDARY:
            dotView = rearTopSecDotView
            break
            
        case ClothingType.bottom:
            dotView = rearBottomDotView
            break
            
        case ClothingType.shoes:
            dotView = rearShoesDotView
            break
            
        default:
            dotView = rearTopMainDotView
            break
        }
        
        return dotView
    }
    
    
    // MARK: - Utility Methods - ImageView-Array-Index relationship
    func getImageViewForItem(_ item : ShoeItem) -> ClothingItemImageView
    {
        var imageView : ClothingItemImageView!
        switch item.clothingType!
        {
        case ClothingType.earrings:
            imageView = earringsImageView
            break
            
        case ClothingType.top_MAIN:
            imageView = topMainImageView
            break
            
        case ClothingType.top_SECONDARY:
            imageView = topSecondaryImageView
            break
            
        case ClothingType.bottom:
            imageView = bottomImageView
            break
            
        case ClothingType.shoes:
            imageView = shoeImageView
            break
            
        default:
            imageView = topMainImageView
            break
        }
        
        return imageView
    }
    
    
    func getRearImageViewForItem(_ item : ShoeItem) -> ClothingItemImageView
    {
        var imageView : ClothingItemImageView!
        switch item.clothingType!
        {
        case ClothingType.earrings:
            imageView = rearEarringsImageView
            break
            
        case ClothingType.top_MAIN:
            imageView = rearTopMainImageView
            break
            
        case ClothingType.top_SECONDARY:
            imageView = rearTopSecondaryImageView
            break
            
        case ClothingType.bottom:
            imageView = rearBottomImageView
            break
            
        case ClothingType.shoes:
            imageView = rearShoeImageView
            break
            
        default:
            imageView = rearTopMainImageView
            break
        }
        
        return imageView
    }

    func getArrayForClothingType(_ clothingType : ClothingType) -> UnsafeMutablePointer<[ShoeItem]>
    {
        var array : UnsafeMutablePointer<[ShoeItem]>
        switch clothingType
        {
        case ClothingType.earrings:
            array = withUnsafeMutablePointer(to: &earringsArray, {$0})
            break
            
        case ClothingType.top_MAIN:
            array = withUnsafeMutablePointer(to: &bottomsArray, {$0})
            break
            
        case ClothingType.top_SECONDARY:
            array = withUnsafeMutablePointer(to: &topsSecArray, {$0})
            break
            
        case ClothingType.bottom:
            array = withUnsafeMutablePointer(to: &topsMainArray, {$0})
            break
            
        case ClothingType.shoes:
            array = withUnsafeMutablePointer(to: &shoeArray, {$0})
            break
            
        default:
            array = withUnsafeMutablePointer(to: &bottomsArray, {$0})
            break
        }
        
        return array
    }
    
    func getArrayMainForClothingType(_ clothingType : ClothingType) -> UnsafeMutablePointer<[ShoeItem]>
    {
        var array : UnsafeMutablePointer<[ShoeItem]>
        switch clothingType
        {
        case ClothingType.earrings:
            
            var earArray = self.mainItemsArray[self.mainItemsArray.index(of: self.currentTopMainItem!)!].earringsArray
            
            array = withUnsafeMutablePointer(to: &earArray, {$0})
            break
            
        case ClothingType.bottom:
            
            var tMainArr = self.mainItemsArray
            
            array = withUnsafeMutablePointer(to: &tMainArr, {$0})
            
            break
            
        case ClothingType.top_SECONDARY:
            var tsecArr = self.mainItemsArray[self.mainItemsArray.index(of: self.currentTopMainItem!)!].topSecArray
            
            array = withUnsafeMutablePointer(to: &tsecArr, {$0})
            break
            
        case ClothingType.top_MAIN:
            var btArr = self.mainItemsArray[self.mainItemsArray.index(of: self.currentTopMainItem!)!].bottomsArray
            
            array = withUnsafeMutablePointer(to: &btArr, {$0})
            break
            
        case ClothingType.shoes:
            var shArr = self.mainItemsArray[self.mainItemsArray.index(of: self.currentTopMainItem!)!].shoesArray
            
            array = withUnsafeMutablePointer(to: &shArr, {$0})
            break
            
        default:
            var tMainArr = self.mainItemsArray
            array = withUnsafeMutablePointer(to: &tMainArr, {$0})
            break
        }
        
        return array
    }
    
    
    
    
    func getCurrentArray()-> UnsafeMutablePointer<[ShoeItem]>
    {
        return self.getArrayForClothingType(self.currentClothingTypeForSwap!)
    }
    
    func getCurrentArrayFromMain() -> UnsafeMutablePointer<[ShoeItem]>
    {
        return self.getArrayMainForClothingType(self.currentClothingTypeForSwap!)
    }
    
    func getCurrentItemForClothingType(_ clothingType : ClothingType) -> ShoeItem?
    {
        var item : ShoeItem?
        switch clothingType
        {
        case ClothingType.earrings:
            item = self.currentEarringsItem
            break
            
        case ClothingType.top_MAIN:
            item = self.currentBottomItem
            break
            
        case ClothingType.top_SECONDARY:
            item = self.currentTopSecItem
            break
            
        case ClothingType.bottom:
            item = self.currentTopMainItem
            break
            
        case ClothingType.shoes:
            item = self.currentShoeItem
            break
            
        default:
            item = nil
            break
        }
        
        return item
    }
    
    
    func setCurrentItem(_ item : ShoeItem?, forClothingType clothingType : ClothingType)
    {
        switch clothingType
        {
        case ClothingType.earrings:
            self.currentEarringsItem = item
            break
            
        case ClothingType.bottom:
            self.currentTopMainItem = item
            break
            
        case ClothingType.top_SECONDARY:
            self.currentTopSecItem = item
            break
            
        case ClothingType.top_MAIN:
            self.currentBottomItem = item
            break
            
        case ClothingType.shoes:
            self.currentShoeItem = item
            break
            
        default:
            
            break
        }
    }
    
    func getDotViewForCurrentItem() -> FADotView
    {
        let clothingType = self.currentClothingTypeForSwap!
        var dotView : FADotView!
        switch clothingType
        {
        case ClothingType.earrings:
            dotView = self.earringsDotView
            break
            
        case ClothingType.top_MAIN:
            dotView = self.topMainDotView
            break
            
        case ClothingType.top_SECONDARY:
            dotView = self.topSecDotView
            break
            
        case ClothingType.bottom:
            dotView = self.bottomDotView
            break
            
        case ClothingType.shoes:
            dotView = self.shoesDotView
            break
            
        default:
            
            break
        }
        
        return dotView
    }
    
    func getTotalCountForClothingType(_ clothingType : ClothingType, forMainTopItem mainTopItem : ShoeItem) -> Int!
    {
        var totalCount = 0
        switch clothingType
        {
        case ClothingType.earrings:
            totalCount = mainTopItem.totalEarringsCount
            break
            
        case ClothingType.top_MAIN:
            totalCount = mainTopItem.totalBottomsCount
            break
            
        case ClothingType.top_SECONDARY:
            totalCount = mainTopItem.totalJackectsCount
            break
            
        case ClothingType.bottom:
            totalCount = self.totalMainTopsCount
            break
            
        case ClothingType.shoes:
            totalCount = mainTopItem.totalShoesCount
            break
            
        default:
            
            break
        }
        
        return totalCount
    }
    
    func refreshColorForDotViews()
    {
        
        if self.currentEarringsItem == nil
        {
            self.earringsDotView.isHidden = true
            self.rearEarringsDotView.isHidden = true
        }
        else
        {
            self.earringsDotView.isHidden = false
            
            ///self.rearEarringsDotView.isHidden = false
            self.rearEarringsDotView.isHidden = true ////Hiding earrings dot view deliberately
            if self.currentEarringsItem?.isAddedToWardrobe == true
            {
                self.earringsDotView.setColorSelected(true)
                self.earringsDotView.layer.borderWidth = 0
                self.rearEarringsDotView.setColorSelected(true)
                self.rearEarringsDotView.layer.borderWidth = 0
            }
            else
            {
                self.earringsDotView.setColorSelected(false)
                self.earringsDotView.layer.borderWidth = 1
                self.rearEarringsDotView.setColorSelected(false)
                self.rearEarringsDotView.layer.borderWidth = 1
            }
            
            self.updateDotViewPositionFor(clothItem: self.currentEarringsItem)

            
        }
        
        
        if self.currentTopMainItem == nil
        {
            self.bottomDotView.isHidden = true
            self.rearBottomDotView.isHidden = true

        }
        else
        {
            self.bottomDotView.isHidden = false
            self.rearBottomDotView.isHidden = false

            if self.currentTopMainItem?.isAddedToWardrobe == true
            {
                self.bottomDotView.setColorSelected(true)
                self.bottomDotView.layer.borderWidth = 0
                self.rearBottomDotView.setColorSelected(true)
                self.rearBottomDotView.layer.borderWidth = 0
            }
            else
            {
                self.bottomDotView.setColorSelected(false)
                self.bottomDotView.layer.borderWidth = 1
                self.rearBottomDotView.setColorSelected(false)
                self.rearBottomDotView.layer.borderWidth = 1
                
            }
            
            self.updateDotViewPositionFor(clothItem: self.currentTopMainItem)

            
        }
        
        
        
        if self.currentTopSecItem != nil
        {
            self.topSecDotView.isHidden = false
            self.topSecondaryImageView.isHidden = false
            
            self.rearTopSecDotView.isHidden = false
            self.rearTopSecondaryImageView.isHidden = false
            
            self.rearTopMainDotView.isHidden = true
            
            if self.currentTopSecItem!.isAddedToWardrobe == true
            {
                self.topSecDotView.setColorSelected(true)
                self.topSecDotView.layer.borderWidth = 0
                
                self.rearTopSecDotView.setColorSelected(true)
                self.rearTopSecDotView.layer.borderWidth = 0
            }
            else
            {
                self.topSecDotView.setColorSelected(false)
                self.topSecDotView.layer.borderWidth = 1
                
                self.rearTopSecDotView.setColorSelected(false)
                self.rearTopSecDotView.layer.borderWidth = 1
            }
            
            self.updateDotViewPositionFor(clothItem: self.currentTopSecItem)

        }
        else
        {
            self.topSecDotView.isHidden = true
            self.topSecondaryImageView.image = nil
            self.topSecondaryImageView.isHidden = true
            
            self.rearTopSecDotView.isHidden = true
            self.rearTopSecondaryImageView.image = nil
            self.rearTopSecondaryImageView.isHidden = true
            
        }
        
        
        if self.currentBottomItem == nil
        {
            self.topMainDotView.isHidden = true
            
            self.rearTopMainDotView.isHidden = true

        }
        else
        {
            self.topMainDotView.isHidden = false
            
            self.rearTopMainDotView.isHidden = false

            if self.currentBottomItem?.isAddedToWardrobe == true
            {
                self.topMainDotView.setColorSelected(true)
                self.topMainDotView.layer.borderWidth = 0
                
                self.rearTopMainDotView.setColorSelected(true)
                self.rearTopMainDotView.layer.borderWidth = 0
                
            }
            else
            {
                self.topMainDotView.setColorSelected(false)
                self.topMainDotView.layer.borderWidth = 1
                
                self.rearTopMainDotView.setColorSelected(false)
                self.rearTopMainDotView.layer.borderWidth = 1
                
            }
            
            self.updateDotViewPositionFor(clothItem: self.currentBottomItem)

        }
        
        
        if self.currentShoeItem == nil
        {
            self.shoesDotView.isHidden = true
            self.rearShoesDotView.isHidden = true

        }
        else
        {
            self.shoesDotView.isHidden = false
            self.rearShoesDotView.isHidden = false

            if self.currentShoeItem?.isAddedToWardrobe == true
            {
                self.shoesDotView.setColorSelected(true)
                self.shoesDotView.layer.borderWidth = 0
                
                self.rearShoesDotView.setColorSelected(true)
                self.rearShoesDotView.layer.borderWidth = 0
                
            }
            else
            {
                self.shoesDotView.setColorSelected(false)
                self.shoesDotView.layer.borderWidth = 1
                
                self.rearShoesDotView.setColorSelected(false)
                self.rearShoesDotView.layer.borderWidth = 1
                
            }
            
            self.updateDotViewPositionFor(clothItem: self.currentShoeItem)

        }
        
        
    }
    
    func refreshColorForCurrentInfoView()
    {

        if(self.currentItemSelectedForInfoView?.isAddedToWardrobe == true)
        {
            self.dotView.backgroundColor = Constants.dotSelectedColor
            self.dotView.layer.borderWidth = 0
            self.productContainerView.layer.borderColor = Constants.dotSelectedColor.cgColor
            
        }
        else
        {
            self.dotView.backgroundColor = Constants.dotUnselectedColor
            self.dotView.layer.borderWidth = 1
            self.productContainerView.layer.borderColor = UIColor.black.cgColor
            
        }
       
        
    }
    
    func updateDotViewPositionFor(clothItem : ShoeItem?)
    {
        guard let item = clothItem else
        {
            return
        }
        
        let dotView = self.getDotViewForItem(item)
        guard let dotCenterX = item.assetSizeSpecs.assetBoundsFront.dotCenterX else
        {
            return
        }
        guard let dotCenterY = item.assetSizeSpecs.assetBoundsFront.dotCenterY else
        {
            return
        }
        
        CommonHelper.updateMultiplierCenterXConstraint(multiplier: dotCenterX, forDotView: dotView)
        CommonHelper.updateMultiplierCenterYConstraint(multiplier: dotCenterY, forDotView: dotView)
        
        
        let rearDotView = self.getRearDotViewForItem(item)
        guard let rearDotCenterX = item.assetSizeSpecs.assetBoundsRear.dotCenterX else
        {
            return
        }
        guard let rearDotCenterY = item.assetSizeSpecs.assetBoundsRear.dotCenterY else
        {
            return
        }
        
        CommonHelper.updateMultiplierCenterXConstraint(multiplier: rearDotCenterX, forDotView: rearDotView)
        CommonHelper.updateMultiplierCenterYConstraint(multiplier: rearDotCenterY, forDotView: rearDotView)
        
    }
    
    func doesItemAlreadyExistsInArray(_ item : ShoeItem, itemsArray : [ShoeItem]) -> Bool
    {
        let results = itemsArray.filter({ (shoeItem) -> Bool in
            
            return item.itemProductID == shoeItem.itemProductID
            
        })
        
        return results.count > 0
    }
    
    func computeDragDropScaleAtTransitionalPoint(_ point : CGPoint, betweenOriginFrame originFrame : CGRect, andDestinationFrame destinationFrame : CGRect) -> CGFloat
    {
        
        let transitionalScaleAtOrigin = originFrame.size.width / destinationFrame.size.width
        
        var effectiveScale : CGFloat!
        
        if point.x <= destinationFrame.origin.x
        {
            effectiveScale = 1
        }
        else if point.x >= originFrame.origin.x
        {
            effectiveScale = transitionalScaleAtOrigin
        }
        else
        {
            effectiveScale = transitionalScaleAtOrigin + (1 - transitionalScaleAtOrigin) * (fabs(point.x - originFrame.origin.x) / fabs(destinationFrame.origin.x - originFrame.origin.x))
        }
        
        return effectiveScale
    }
    
    func imageSizeAspectFit(_ imgview: UIImageView) -> CGSize
    {
        var newwidth: CGFloat
        var newheight: CGFloat
        let image: UIImage = imgview.image!
        
        if image.size.height >= image.size.width
        {
            newheight = imgview.frame.size.height;
            newwidth = (image.size.width / image.size.height) * newheight
            if newwidth > imgview.frame.size.width
            {
                let diff: CGFloat = imgview.frame.size.width - newwidth
                newheight = newheight + diff / newheight * newheight
                newwidth = imgview.frame.size.width
            }
        }
        else
        {
            newwidth = imgview.frame.size.width
            newheight = (image.size.height / image.size.width) * newwidth
            if newheight > imgview.frame.size.height
            {
                let diff: CGFloat = imgview.frame.size.height - newheight
                newwidth = newwidth + diff / newwidth * newwidth
                newheight = imgview.frame.size.height
            }
        }
        
        return CGSize(width: newwidth, height: newheight)
    }
    
    
    func resetZOrderFor(items : [ShoeItem])
    {
        for item in items
        {
            
            switch item.clothingType!
            {
            case ClothingType.earrings :
                item.zOrder = 5
                break
                
            case ClothingType.top_SECONDARY :
                item.zOrder = 4
                break
                
            case ClothingType.top_MAIN :
                item.zOrder = 3
                break
                
            case ClothingType.bottom :
                item.zOrder = 2
                break
                
            case ClothingType.shoes :
                item.zOrder = 1
                break
                
            default :
                break
            }
        }
    }
    
    func reorderImageViewsWithZOrder()
    {
        var currentSelectedItemsArray = [ShoeItem]()

        if self.currentTopMainItem != nil
        {
            currentSelectedItemsArray.append(self.currentTopMainItem!)
        }
        if self.currentTopSecItem != nil
        {
            currentSelectedItemsArray.append(self.currentTopSecItem!)
        }
        if self.currentEarringsItem != nil
        {
            currentSelectedItemsArray.append(self.currentEarringsItem!)
        }
        if self.currentBottomItem != nil
        {
            currentSelectedItemsArray.append(self.currentBottomItem!)
        }
        if self.currentShoeItem != nil
        {
            currentSelectedItemsArray.append(self.currentShoeItem!)
        }
        
        self.resetZOrderFor(items : currentSelectedItemsArray)

        
        ///check for default Z order override behaviour for Top
        if let mainTopItem = self.currentTopMainItem
        {
            if mainTopItem.assetSizeSpecs.overridesDefaultZOrder == true
            {
                if let bottomItem = self.currentBottomItem
                {
                    if mainTopItem.zOrder >= bottomItem.zOrder
                    {
                        if self.shouldRespectTheZOrderSetting(higherZOrderItem: bottomItem, lowerZOrderItem: mainTopItem) == true
                        {
                            bottomItem.zOrder = mainTopItem.zOrder
                            mainTopItem.zOrder = bottomItem.zOrder - 1
                        }
                        
                    }
                    
                }
            }
        }
        
        
        
        ///check for default Z order override behaviour for Shoe
        if let shoeItem = self.currentShoeItem
        {
            if shoeItem.assetSizeSpecs.overridesDefaultZOrder == true
            {
                if let bottomItem = self.currentBottomItem
                {
                    let zOrder = shoeItem.zOrder
                    if zOrder! <= bottomItem.zOrder
                    {
                        if self.shouldRespectTheZOrderSetting(higherZOrderItem: shoeItem, lowerZOrderItem: bottomItem) == true
                        {
                            shoeItem.zOrder = bottomItem.zOrder + 1
//                            bottomItem.zOrder = shoeItem.zOrder - 1
                        }

                    }
                }
            }
        }
        
        
        
        currentSelectedItemsArray.sort(by: { (shoeItem1, shoeItem2) -> Bool in
            
            return shoeItem1.zOrder <= shoeItem2.zOrder
        })
        
        
        
        let view = self.topMainImageView.superview as UIView!
        
        var currentTopImageView : ClothingItemImageView!
        for index in (0 ..< currentSelectedItemsArray.count).reversed()
        {
            let imageView = self.getImageViewForItem(currentSelectedItemsArray[index])
            if index == currentSelectedItemsArray.count - 1
            {
                view?.bringSubview(toFront: imageView)
            }
            else
            {
                view?.insertSubview(imageView, belowSubview: currentTopImageView)
            }
            
            currentTopImageView = imageView
            
        }

    }
    
    func setAndReorderRearImageViewsWithZOrder()
    {
        var currentSelectedItemsArray = [ShoeItem]()
        
        if self.currentTopMainItem != nil
        {
            currentSelectedItemsArray.append(self.currentTopMainItem!)
            self.rearTopMainImageView.isHidden = false
        }
        else
        {
            self.rearTopMainImageView.isHidden = true
        }
        
        
        if self.currentTopSecItem != nil
        {
            currentSelectedItemsArray.append(self.currentTopSecItem!)
            self.rearTopSecondaryImageView.isHidden = false
        }
        else
        {
            self.rearTopSecondaryImageView.isHidden = true
        }
        
        
//        if self.currentEarringsItem != nil
//        {
//            currentSelectedItemsArray.append(self.currentEarringsItem!)
//            self.rearEarringsImageView.hidden = false
//        }
//        else
//        {
//            self.rearEarringsImageView.hidden = true
//        }
        
        
        if self.currentBottomItem != nil
        {
            currentSelectedItemsArray.append(self.currentBottomItem!)
            self.rearBottomImageView.isHidden = false
        }
        else
        {
            self.rearBottomImageView.isHidden = true
        }
        
        
        if self.currentShoeItem != nil
        {
            currentSelectedItemsArray.append(self.currentShoeItem!)
            self.rearShoeImageView.isHidden = false
        }
        else
        {
            self.rearShoeImageView.isHidden = true
        }
        
        for shoeItem in currentSelectedItemsArray
        {
            let clothingItemImageView = self.getRearImageViewForItem(shoeItem)
            
            clothingItemImageView.xConstraint.constant = self.rearModelSize.width *  shoeItem.assetSizeSpecs.assetBoundsRear.xPos!
            clothingItemImageView.yConstraint.constant = self.rearModelSize.height * shoeItem.assetSizeSpecs.assetBoundsRear.yPos!
            clothingItemImageView.widhtConstraint.constant = self.rearModelSize.width * shoeItem.assetSizeSpecs.assetBoundsRear.width!
            clothingItemImageView.heightConstraint.constant = self.rearModelSize.height * shoeItem.assetSizeSpecs.assetBoundsRear.height!
            
            clothingItemImageView.image = ClothingItemImageView.imageForImageUrl(url:shoeItem.rearItemImageURL!)
            
            
            self.updateDotViewPositionFor(clothItem: shoeItem)
            
        }
        
        
        
        
        rearModelItemImagesContainerView.layoutIfNeeded()

        
        currentSelectedItemsArray.sort(by: { (shoeItem1, shoeItem2) -> Bool in
            
            return shoeItem1.zOrder <= shoeItem2.zOrder
        })
        
        
        
        let view = self.rearTopMainImageView.superview as UIView!
        
        var currentRearTopImageView : ClothingItemImageView!
        for index in (0 ..< currentSelectedItemsArray.count).reversed()
        {
            let imageView = self.getRearImageViewForItem(currentSelectedItemsArray[index])
            if index == currentSelectedItemsArray.count - 1
            {
                view?.bringSubview(toFront: imageView)
            }
            else
            {
                view?.insertSubview(imageView, belowSubview: currentRearTopImageView)
            }
            
            currentRearTopImageView = imageView
            
        }
        
       view?.bringSubview(toFront: self.hairRearImageView)
        
    }
    
    
    
    func shouldRespectTheZOrderSetting(higherZOrderItem highZOrderItem : ShoeItem, lowerZOrderItem lowZOrderItem : ShoeItem) -> Bool
    {
        
        let highZOrderItemRect = CGRect(x: self.frontModelSize.width * highZOrderItem.assetSizeSpecs.assetBoundsFront.xPos!, y: self.frontModelSize.height * highZOrderItem.assetSizeSpecs.assetBoundsFront.yPos!, width: self.frontModelSize.width * highZOrderItem.assetSizeSpecs.assetBoundsFront.width!, height:self.frontModelSize.height * highZOrderItem.assetSizeSpecs.assetBoundsFront.height!)
        let lowZOrderItemRect = CGRect(x: self.frontModelSize.width * lowZOrderItem.assetSizeSpecs.assetBoundsFront.xPos!, y: self.frontModelSize.height * lowZOrderItem.assetSizeSpecs.assetBoundsFront.yPos!, width: self.frontModelSize.width * lowZOrderItem.assetSizeSpecs.assetBoundsFront.width!, height: self.frontModelSize.height * lowZOrderItem.assetSizeSpecs.assetBoundsFront.height!)
        
        let intersectionRect = highZOrderItemRect.intersection(lowZOrderItemRect)
        
        if intersectionRect == CGRect.null
        {
            return true
        }
        
        let highZOrderItemCropRect = CGRect(x: intersectionRect.origin.x - self.frontModelSize.width * highZOrderItem.assetSizeSpecs.assetBoundsFront.xPos!, y: intersectionRect.origin.y - self.frontModelSize.height * highZOrderItem.assetSizeSpecs.assetBoundsFront.yPos!, width: intersectionRect.width, height: intersectionRect.height)
        
        let lowZOrderItemCropRect = CGRect(x: intersectionRect.origin.x - self.frontModelSize.width * lowZOrderItem.assetSizeSpecs.assetBoundsFront.xPos!, y: intersectionRect.origin.y - self.frontModelSize.height * lowZOrderItem.assetSizeSpecs.assetBoundsFront.yPos!, width: intersectionRect.width, height: intersectionRect.height)
        
        
        ///print("intersectionRect \(intersectionRect)")
        
        
        let highZOrderImage = ClothingItemImageView.imageForImageUrl(url: highZOrderItem.itemImageURL!)
        
        let lowZOrderImage = ClothingItemImageView.imageForImageUrl(url: lowZOrderItem.itemImageURL!)
        
        
        //let highZORDERImage = highZOrderImage
        let highZOrderImageFrame = highZOrderImage!.crop(highZOrderItemCropRect).trimmedImageFrame()
        //let lowZORDERImage = lowZOrderImage
        
        let lowZOrderImageFrame = lowZOrderImage!.crop(lowZOrderItemCropRect).trimmedImageFrame()
        
        //if lowZOrderImage width is greater than 105% that of the highZOrderImage at that point
        if lowZOrderImageFrame.size.width > (1 + 0.05) * highZOrderImageFrame.size.width
        {
            return false
        }
        else
        {
            return true
        }
        
        
    }
    
    
    func getDistanceBetween(_ point1 : CGPoint, point2 : CGPoint) -> CGFloat
    {
        let xDist = (point2.x - point1.x);
        let yDist = (point2.y - point1.y);
        let distanceSquare = (xDist * xDist) + (yDist * yDist);
        return sqrt(distanceSquare)
    }
    
    func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
    
    
    // MARK: - Drag Drop Gesture Handler Method
    @objc func longPressGestureRecognized(_ recogniser : UILongPressGestureRecognizer)
    {
        
        switch recogniser.state
        {
            
        case .began:
            
            self.categoryCollectionView.isUserInteractionEnabled = false
            
            ///////////print("touch began")
            
            ///check if the touch began on a clothing item cell
            ///if yes, then -
            /// 1. Fetch the clothing style to know the destination Size
            /// 2. Apply the size constraints constants equal to the touched cell
            /// 3. And then , make alpha = 1.
            
            if self.currentDragMode != DragMode.none
            {
                return
            }
            
            
            self.longPressStartPoint = recogniser.location(in: self.view)
            
            
            if self.productContainerView.frame.contains(self.longPressStartPoint) == true && self.productContainerView.alpha != 0
            {
                self.currentDragMode = DragMode.item_TAG
                
                self.invalidateFadeOutTimer()
                
                self.productContainerView.isHidden = true
                self.loadItemTagDragVC()
                
                let startOrigin = self.productContainerView.frame.origin
                self.itemTagDragVC.startTagDragOrigin = self.view.convert(startOrigin, to: self.itemTagDragVC.view)
                
                if currentItemSelectedForInfoView?.isAddedToWardrobe == true
                {
                    self.itemTagDragVC.wardrobeView.isHidden = true
                }
                
                
            }
            else
            {
                let location = recogniser.location(in: self.clothingItemsTableView)
                
                if let indexPath =  self.clothingItemsTableView.indexPathForRow(at: location)
                {
                    self.unhideDotViews(false)
                    self.invalidateFadeOutTimer()
                    
                    self.currentDragMode = DragMode.clothing_ITEM
                    
                    let cell = self.clothingItemsTableView.cellForRow(at: indexPath) as! ClothingItemCell
                    
                    
                    let imageSizeAspectFit = self.imageSizeAspectFit(cell.itemImageView)
                    let imageFrameOriginX = (cell.itemImageView.bounds.size.width - imageSizeAspectFit.width) / CGFloat(2)
                    let imageFrameOriginY = (cell.itemImageView.bounds.size.height - imageSizeAspectFit.height) / CGFloat(2)
                    let imageFrameAspectFit = CGRect(x: imageFrameOriginX, y: imageFrameOriginY, width: imageSizeAspectFit.width, height: imageSizeAspectFit.height)
                    let absoluteImageFrame = cell.convert(imageFrameAspectFit, to: self.view)
                    
                    
                    
                    let currentItem = self.getCurrentArray().pointee[indexPath.row]
                    
                    let destinationImgViewFrame = CGRect(x: self.frontModelSize.width * currentItem.assetSizeSpecs.assetBoundsFront.xPos!, y: self.frontModelSize.height * currentItem.assetSizeSpecs.assetBoundsFront.yPos!, width: self.frontModelSize.width * currentItem.assetSizeSpecs.assetBoundsFront.width!, height: self.frontModelSize.height * currentItem.assetSizeSpecs.assetBoundsFront.height!)
                    
                    
                    self.dragDropDestinationRect = self.modelItemImagesContainerView.convert(destinationImgViewFrame, to: self.view)
                    
                    
                    self.currentItemDragging = currentItem
                    
                    self.dragDropImageView.image = ClothingItemImageView.imageForImageUrl(url:currentItem.itemImageURL)
                    
                    
                    let effectiveScale = self.computeDragDropScaleAtTransitionalPoint(CGPoint(x: absoluteImageFrame.origin.x, y: absoluteImageFrame.origin.y), betweenOriginFrame: absoluteImageFrame, andDestinationFrame: self.dragDropDestinationRect)
                    
                    self.dragDropOriginRect = CGRect(origin: absoluteImageFrame.origin, size: CGSize(width: effectiveScale * self.dragDropDestinationRect.size.width, height: effectiveScale * self.dragDropDestinationRect.size.height))
                    
                    
                    
                    self.dragImgViewConstraintX.constant = absoluteImageFrame.origin.x
                    self.dragImgViewConstraintY.constant = absoluteImageFrame.origin.y
                    self.dragImgViewConstraintWidth.constant = self.dragDropOriginRect.size.width
                    self.dragImgViewConstraintHeight.constant = self.dragDropOriginRect.size.height
                    
                    
                    self.dragDropImageView.layoutIfNeeded()
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        
                        cell.alpha = 0.3
                        self.dragDropImageView.alpha = 1
                    })
                }
                else
                {
                    
                    let location = recogniser.location(in: self.modelItemImagesContainerView)
                    
                    if let imageView = (self.modelItemImagesContainerView.hitTest(location, with: nil)) as? ClothingItemImageView!
                    {
                        
                        
                        self.unhideDotViews(false)
                        self.invalidateFadeOutTimer()
                        
                        
                        if let currentTappedItem = self.getCurrentItemForClothingType(imageView.clothingType)
                        {
                            self.currentDragMode = DragMode.wardrobe_PUT_BACK
                            
                            var mappedItemsArray = self.getArrayForClothingType(imageView.clothingType)
                            let matchingItemArr = mappedItemsArray.pointee.filter({ (item) -> Bool in
                                
                                return item.itemProductID == currentTappedItem.itemProductID
                            })
                            
                            
                            var tappedItem : ShoeItem!
                            if matchingItemArr.count > 0
                            {
                                tappedItem = matchingItemArr[0];
                            }
                            else
                            {
                                ///item doesn't exist (no mapping) for the current top
                                ///add the item temporarily to the mapped list and use it instead
                                tappedItem = currentTappedItem
                                mappedItemsArray.pointee.insert(tappedItem, at: 0)
                                self.clothingItemsTableView.reloadData()
                                self.clothingItemsTableView.layoutIfNeeded()
                            }
                            
                            let itemIndex = mappedItemsArray.pointee.index(of: tappedItem)
                            
                            
                            let indexPath = IndexPath(row: itemIndex!, section: 0)
                            
                            self.currentClothingTypeForSwap = imageView.clothingType
                            self.setCurrentItem(nil, forClothingType: imageView.clothingType)
                            
                            if clothingItemsTableView.alpha == 1
                            {
                                self.clothingItemsTableView.alpha = 0
                            }
                            
                            
                            self.lastItemReached = false
                            ///reload TableView data
                            self.clothingItemsTableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.none)
                            self.view.layoutIfNeeded()
                            
                            self.clothingItemsTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: false)
                            
                            
                            let cell = self.clothingItemsTableView.cellForRow(at: indexPath) as! ClothingItemCell
                            
                            
                            let imageSizeAspectFit = self.imageSizeAspectFit(cell.itemImageView)
                            let imageFrameOriginX = (cell.itemImageView.bounds.size.width - imageSizeAspectFit.width) / CGFloat(2)
                            let imageFrameOriginY = (cell.itemImageView.bounds.size.height - imageSizeAspectFit.height) / CGFloat(2)
                            let imageFrameAspectFit = CGRect(x: imageFrameOriginX, y: imageFrameOriginY, width: imageSizeAspectFit.width, height: imageSizeAspectFit.height)
                            let absoluteImageFrame = cell.convert(imageFrameAspectFit, to: self.view)
                            
                            
                            
                            let currentItem = self.getCurrentArray().pointee[indexPath.row]
                            
                            let destinationImgViewFrame = CGRect(x: self.frontModelSize.width * currentItem.assetSizeSpecs.assetBoundsFront.xPos!, y: self.frontModelSize.height * currentItem.assetSizeSpecs.assetBoundsFront.yPos!, width: self.frontModelSize.width * currentItem.assetSizeSpecs.assetBoundsFront.width!, height: self.frontModelSize.height * currentItem.assetSizeSpecs.assetBoundsFront.height!)
                            
                            
                            self.dragDropDestinationRect = self.modelItemImagesContainerView.convert(destinationImgViewFrame, to: self.view)
                            
                            
                            self.currentItemDragging = currentItem
                            
                            self.dragDropImageView.image = ClothingItemImageView.imageForImageUrl(url:currentItem.itemImageURL)
                            
                            
                            let effectiveScale = self.computeDragDropScaleAtTransitionalPoint(CGPoint(x: absoluteImageFrame.origin.x, y: absoluteImageFrame.origin.y), betweenOriginFrame: absoluteImageFrame, andDestinationFrame: self.dragDropDestinationRect)
                            
                            self.dragDropOriginRect = CGRect(origin: absoluteImageFrame.origin, size: CGSize(width: effectiveScale * self.dragDropDestinationRect.size.width, height: effectiveScale * self.dragDropDestinationRect.size.height))
                            
                            
                            
                            self.dragImgViewConstraintX.constant = dragDropDestinationRect.origin.x
                            self.dragImgViewConstraintY.constant = dragDropDestinationRect.origin.y
                            self.dragImgViewConstraintWidth.constant = self.dragDropDestinationRect.size.width
                            self.dragImgViewConstraintHeight.constant = self.dragDropDestinationRect.size.height
                            
                            
                            self.dragDropImageView.layoutIfNeeded()
                            
                            self.setCurrentItem(self.currentItemDragging, forClothingType: imageView.clothingType)
                            
                            
                            
                            UIView.animate(withDuration: 0.3, animations: {
                                
                                cell.alpha = 0.3
                               
                                self.dragDropImageView.alpha = 1
                            })
                            
                            
                        }
                        
                    }
                    else
                    {
                        self.currentDragMode = DragMode.none
                    }
                }
            }
            
            
            break
            
            
            
        case .ended, .cancelled :
            
            
            self.categoryCollectionView.isUserInteractionEnabled = true

            
            
            if self.currentDragMode == DragMode.none
            {
                return
            }
            else if self.currentDragMode == DragMode.item_TAG
            {
                
                if self.itemTagDragVC.cartView.frame.contains(self.itemTagDragVC.productContainerView.center) == true
                {
                    ////Cart
                    self.performTagAddedToCartAnimation()
                    
                }
                else if self.itemTagDragVC.wardrobeView.frame.contains(self.itemTagDragVC.productContainerView.center) == true && currentItemSelectedForInfoView?.isAddedToWardrobe == false
                {
                    ////Wardrobe
                    
                    
                    
                    let userSignedIn =   UserDefaults.standard.bool(forKey: Constants.kUserSuccessfullySignedIn)
                    if userSignedIn == false
                    {
                        self.presentSignIn()
                        self.performCancelTagDragAnimation()
                        return
                    }
                    self.performTagAddedToWardrobeAnimation()

                }
                else
                {
                    self.performCancelTagDragAnimation()
                }
                
            }
            else if self.currentDragMode == DragMode.clothing_ITEM
            {
                let OriginDestinationDistance = self.dragDropOriginRect.origin.x - self.dragDropDestinationRect.origin.x
                let currentDistanceFromDestination = fabs(self.dragDropImageView.frame.origin.x - self.dragDropDestinationRect.origin.x)
                
                var itemWillBeSwappped = false
                if currentDistanceFromDestination <=   OriginDestinationDistance / CGFloat(2)
                {
                    self.dragImgViewConstraintX.constant = self.dragDropDestinationRect.origin.x
                    self.dragImgViewConstraintY.constant = self.dragDropDestinationRect.origin.y
                    self.dragImgViewConstraintWidth.constant = self.dragDropDestinationRect.size.width
                    self.dragImgViewConstraintHeight.constant = self.dragDropDestinationRect.size.height
                    
                    itemWillBeSwappped = true
                }
                else
                {
                    self.dragImgViewConstraintX.constant = self.dragDropOriginRect.origin.x
                    self.dragImgViewConstraintY.constant = self.dragDropOriginRect.origin.y
                    self.dragImgViewConstraintWidth.constant = self.dragDropOriginRect.size.width
                    self.dragImgViewConstraintHeight.constant = self.dragDropOriginRect.size.height
                    
                    itemWillBeSwappped = false
                    
                }
                
                
                if itemWillBeSwappped == true
                {

                    let imageView = self.getImageViewForItem(self.currentItemDragging!)
                    
                    
                    
                    UIView.animate(withDuration: 0.6, animations: {
                        
                        self.dragDropImageView.alpha = 0.7
                        self.dragDropImageView.layoutIfNeeded()
                        
                        }, completion: { (finished) in
                            
                            ///apply the dragged item asset to the mannequin
                            ///update arrays in the background if needed
                            ///set currentSelectedItem property appropriately
                            ///reload table view to hide the dropped item
                            
                            let origin = self.view.convert(self.dragDropDestinationRect.origin, to: self.modelItemImagesContainerView)
                            
                            imageView.xConstraint.constant =  origin.x
                            imageView.yConstraint.constant = origin.y
                            imageView.widhtConstraint.constant = self.dragDropDestinationRect.size.width
                            imageView.heightConstraint.constant = self.dragDropDestinationRect.size.height
                            
                            
                            if self.currentItemDragging!.clothingType == ClothingType.bottom
                            {
                                self.autoApplySecondaryItemsIfExistForTheNewTop()
                            }
                            
                            
                            self.setCurrentItem(self.currentItemDragging!, forClothingType: self.currentClothingTypeForSwap!)
                            
                            
                            self.flipButton.isEnabled = false
                            self.perform(#selector(ModelVC.checkRearAssets), with: nil, afterDelay: 0.01)
                            
                            
                            
                            
                            self.reorderImageViewsWithZOrder()
                            self.refreshColorForDotViews()

                            
                            imageView.image = ClothingItemImageView.imageForImageUrl(url:self.currentItemDragging!.itemImageURL)
                            self.view.layoutIfNeeded()
                            self.dragDropImageView.alpha = 0
                            
                            
                            ///reload TableView data
                            
                            let draggedItemIndex = self.getCurrentArray().pointee.index(of: self.currentItemDragging!)
                            let indexPath = IndexPath(row: draggedItemIndex!, section: 0)
                            
                            self.lastItemReached = false
                            
                            self.clothingItemsTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                            
                            
                            UIView.animate(withDuration: 0.5, animations: {
                                
                                for cell in self.clothingItemsTableView.visibleCells
                                {
                                    cell.alpha = 1
                                }
                                
                                }, completion: { (finished) in
                                    
                                    self.unhideDotViews(true)
                                    self.startFadeOutTimer()
                                    
                                    if self.currentClothingTypeForSwap == ClothingType.bottom
                                    {
                                        self.loadSecondaryItemsForTopIndex(draggedItemIndex!)
                                    }
                                    
                                    self.currentItemDragging = nil
                                    
                                    self.currentDragMode = DragMode.none
                                    
                                    self.clothingItemImageViewDidTap(imageView)
                            })
                            
                            
                    })
                }
                else
                {
                    UIView.animate(withDuration: 0.3, animations: {
                        
                        
                        
                        self.dragDropImageView.alpha = 0
                        self.dragDropImageView.layoutIfNeeded()
                        
                        for cell in self.clothingItemsTableView.visibleCells
                        {
                            cell.alpha = 1
                        }
                        
                        }, completion: { (finished) in
                            
                            self.unhideDotViews(true)
                            self.startFadeOutTimer()
                            
                            self.currentItemDragging = nil
                            self.currentDragMode = DragMode.none
                    })
                }
            }
            else if self.currentDragMode == DragMode.wardrobe_PUT_BACK
            {
                self.currentDragMode = DragMode.none
                
                
                let OriginDestinationDistance = self.dragDropOriginRect.origin.x - self.dragDropDestinationRect.origin.x
                let currentDistanceFromDestination = fabs(self.dragDropImageView.frame.origin.x - self.dragDropDestinationRect.origin.x)
                
                var itemWillBeRemoved = false
                if currentDistanceFromDestination <=   OriginDestinationDistance / CGFloat(2)
                {
                    self.dragImgViewConstraintX.constant = self.dragDropDestinationRect.origin.x
                    self.dragImgViewConstraintY.constant = self.dragDropDestinationRect.origin.y
                    self.dragImgViewConstraintWidth.constant = self.dragDropDestinationRect.size.width
                    self.dragImgViewConstraintHeight.constant = self.dragDropDestinationRect.size.height
                    
                    itemWillBeRemoved = false
                }
                else
                {
                    self.dragImgViewConstraintX.constant = self.dragDropOriginRect.origin.x
                    self.dragImgViewConstraintY.constant = self.dragDropOriginRect.origin.y
                    self.dragImgViewConstraintWidth.constant = self.dragDropOriginRect.size.width
                    self.dragImgViewConstraintHeight.constant = self.dragDropOriginRect.size.height
                    
                    itemWillBeRemoved = true
                    
                }
                
                
                if itemWillBeRemoved == false
                {
                    let imageView = self.getImageViewForItem(self.currentItemDragging!)
                    
                    
                    
                    UIView.animate(withDuration: 0.6, animations: {
                        
                        self.dragDropImageView.alpha = 0.7
                        
                        self.dragDropImageView.layoutIfNeeded()
                        
                        }, completion: { (finished) in
                            
                            ///apply the dragged item asset to the mannequin
                            ///update arrays in the background if needed
                            ///set currentSelectedItem property appropriately
                            ///reload table view to hide the dropped item
                            
                            let origin = self.view.convert(self.dragDropDestinationRect.origin, to: self.modelItemImagesContainerView)
                            
                            imageView.xConstraint.constant =  origin.x
                            imageView.yConstraint.constant = origin.y
                            imageView.widhtConstraint.constant = self.dragDropDestinationRect.size.width
                            imageView.heightConstraint.constant = self.dragDropDestinationRect.size.height
                            
                            self.setCurrentItem(self.currentItemDragging!, forClothingType: self.currentClothingTypeForSwap!)
                            
                            
                            
                            self.reorderImageViewsWithZOrder()
                            self.refreshColorForDotViews()
                            
                            
                            imageView.image = ClothingItemImageView.imageForImageUrl(url:self.currentItemDragging!.itemImageURL)
                            self.view.layoutIfNeeded()
                            self.dragDropImageView.alpha = 0
                            
                            
                            ///reload TableView data
                            
                            let draggedItemIndex = self.getCurrentArray().pointee.index(of: self.currentItemDragging!)
                            let indexPath = IndexPath(row: draggedItemIndex!, section: 0)
                            
                            self.lastItemReached = false
                            
                            self.clothingItemsTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                            
                            
                            
                            UIView.animate(withDuration: 0.5, animations: {
                                
                                for cell in self.clothingItemsTableView.visibleCells
                                {
                                    cell.alpha = 1
                                }
                                
                                }, completion: { (finished) in
                                    
                                    
                                    self.unhideDotViews(true)
                                    self.startFadeOutTimer()
                                    
                                    
                                    self.currentItemDragging = nil
                                    
                                    self.currentDragMode = DragMode.none
                                    
                                    self.clothingItemImageViewDidTap(imageView)
                            })
                            
                            
                    })
                }
                else
                {
                    UIView.animate(withDuration: 0.3, animations: {
                        
                        
                        
                        self.dragDropImageView.alpha = 0
                        self.dragDropImageView.layoutIfNeeded()
                        
                        for cell in self.clothingItemsTableView.visibleCells
                        {
                            cell.alpha = 1
                        }
                        
                        }, completion: { (finished) in
                            
                            
                            self.unhideDotViews(true)
                            self.startFadeOutTimer()
                            
                            
                            ///reload TableView data
                            
                            let draggedItemIndex = self.getCurrentArray().pointee.index(of: self.currentItemDragging!)
                            let indexPath = IndexPath(row: draggedItemIndex!, section: 0)
                            
                            self.lastItemReached = false
                            
                            
                            self.setCurrentItem(nil, forClothingType: self.currentClothingTypeForSwap!)
                            
                            
                            
                            
                            self.flipButton.isEnabled = false
                            self.perform(#selector(ModelVC.checkRearAssets), with: nil, afterDelay: 0.01)
                            
                            
                            self.clothingItemsTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                            
                            
                            self.currentItemDragging = nil
                            self.currentDragMode = DragMode.none
                            
                            
                            
                            
                    })
                }
            }

            
            
            ///print("touch Ended")
            
            break
            
            
            
        case.changed:
            
            if self.currentDragMode == DragMode.none
            {
                return
            }
            else if self.currentDragMode == DragMode.item_TAG
            {
                let location = recogniser.location(in: self.view)
                let translatedPoint = CGPoint(x: location.x - self.longPressStartPoint.x, y: location.y - self.longPressStartPoint.y)
                
                
                let newX = self.itemTagDragVC.startTagDragOrigin.x + translatedPoint.x
                let newY = self.itemTagDragVC.startTagDragOrigin.y + translatedPoint.y
                
                let newPoint = CGPoint(x: newX, y: newY)
            

                self.itemTagDragVC.productContainerView_X_Constraint.constant =
                newPoint.x
                
                self.itemTagDragVC.productContainerView_Y_Constraint.constant =
                    newPoint.y
                
                
                ///calculate and apply The percentage of scaling to be applied to the CartView or WardrobeView
                if translatedPoint.y > 0
                {
                    ///WARDROBE

                    
                    let maxPropWidth =  (CGFloat(198) / CGFloat(414))
                    
                    let minPropWidth = (CGFloat(118) / CGFloat(414))
                    
                    let diff = maxPropWidth - minPropWidth
                    
                    let originalDistance = self.getDistanceBetween(self.itemTagDragVC.startWardrobeViewOrigin, point2: self.itemTagDragVC.startTagDragOrigin)
                    
                    let currentDistance = self.getDistanceBetween(self.itemTagDragVC.startWardrobeViewOrigin, point2: newPoint)
                    
                    let applicablePropWidth = minPropWidth +  (( (originalDistance - currentDistance) / originalDistance) * diff)
                    


                    self.itemTagDragVC.wardrobeButtonWidthConstant.constant = applicablePropWidth * self.view.bounds.size.width
                    
                    
                    self.itemTagDragVC.wardrobeView.layer.cornerRadius = self.itemTagDragVC.wardrobeButtonWidthConstant.constant / 2
                    self.itemTagDragVC.checkmarkView.layer.cornerRadius = self.itemTagDragVC.wardrobeView.layer.cornerRadius
                    
                }
                else if translatedPoint.y < 0
                {
                    
                    ///CART
                    
                    let maxPropWidth =  (CGFloat(198) / CGFloat(414))
                    
                    let minPropWidth = (CGFloat(118) / CGFloat(414))
                    
                    let diff = maxPropWidth - minPropWidth
                    
                    let originalDistance = self.getDistanceBetween(self.itemTagDragVC.startCartViewOrigin, point2: self.itemTagDragVC.startTagDragOrigin)
                    
                    let currentDistance = self.getDistanceBetween(self.itemTagDragVC.startCartViewOrigin, point2: newPoint)
                    
                    let applicablePropWidth = minPropWidth +  (( (originalDistance - currentDistance) / originalDistance) * diff)
                    
                    
                    self.itemTagDragVC.cartButtonWidthConstant.constant = applicablePropWidth * self.view.bounds.size.width
                    
                    self.itemTagDragVC.cartView.layer.cornerRadius = self.itemTagDragVC.cartButtonWidthConstant.constant / 2

                    
                }
                else
                {
                    
                }
                
                let dotView =  self.getDotViewForCurrentItem()
                dotView.isHidden = true
                
                
                self.itemTagDragVC.view.layoutIfNeeded()
                
                self.itemTagDragVC.applyOffsetToCornerViews()
                
                self.itemTagDragVC.view.layoutIfNeeded()
                

                if translatedPoint.y > 0
                {
                    self.itemTagDragVC.productContainerView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
                }
                else if translatedPoint.y < 0
                {
                    self.itemTagDragVC.productContainerView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_4))
                }
                else
                {
                    self.itemTagDragVC.productContainerView.transform = CGAffineTransform.identity
                }
                
                
            }
            else if self.currentDragMode == DragMode.clothing_ITEM
            {
                let location = recogniser.location(in: self.view)
                let translatedPoint = CGPoint(x: location.x - self.longPressStartPoint.x, y: location.y - self.longPressStartPoint.y)
                
                let newX = self.dragDropOriginRect.origin.x + translatedPoint.x
                let newY = self.dragDropOriginRect.origin.y + translatedPoint.y
                
                
                let effectiveScale = self.computeDragDropScaleAtTransitionalPoint(CGPoint(x: newX, y: newY), betweenOriginFrame: self.dragDropOriginRect, andDestinationFrame: self.dragDropDestinationRect)
                self.dragImgViewConstraintX.constant = newX
                self.dragImgViewConstraintY.constant = newY
                self.dragImgViewConstraintWidth.constant = effectiveScale *  self.dragDropDestinationRect.size.width
                self.dragImgViewConstraintHeight.constant = effectiveScale *  self.dragDropDestinationRect.size.height
                
                
                self.dragDropImageView.layoutIfNeeded()
            }
            else if self.currentDragMode == DragMode.wardrobe_PUT_BACK
            {
                
                let location = recogniser.location(in: self.view)
                let translatedPoint = CGPoint(x: location.x - self.longPressStartPoint.x, y: location.y - self.longPressStartPoint.y)
                
                
                
//                UIView.animateWithDuration(0.3, animations: {
//                    
//                    self.dragDropImageView.alpha = 1
//                })
                
                if clothingItemsTableView.alpha == 0
                {
                    self.unhideTableView(true)
                }
                self.setCurrentItem(nil, forClothingType: self.currentItemDragging!.clothingType)
                
                self.refreshColorForDotViews()
                
                
                let newX = self.dragDropDestinationRect.origin.x + translatedPoint.x
                let newY = self.dragDropDestinationRect.origin.y + translatedPoint.y
                
                
                let effectiveScale = self.computeDragDropScaleAtTransitionalPoint(CGPoint(x: newX, y: newY), betweenOriginFrame: self.dragDropOriginRect, andDestinationFrame: self.dragDropDestinationRect)
                self.dragImgViewConstraintX.constant = newX
                self.dragImgViewConstraintY.constant = newY
                self.dragImgViewConstraintWidth.constant = effectiveScale *  self.dragDropDestinationRect.size.width
                self.dragImgViewConstraintHeight.constant = effectiveScale *  self.dragDropDestinationRect.size.height
                
                
                self.dragDropImageView.layoutIfNeeded()
            }
            
            break
            
            
        default:
            
            break
        }
    }
    
    
    func autoApplySecondaryItemsIfExistForTheNewTop()
    {
        var autoItems = [ShoeItem]()
        //check earrings
        if self.currentEarringsItem == nil && self.currentItemDragging!.earringsArray.count > 0
        {
            let earringItem = self.currentItemDragging!.earringsArray.first!
            self.currentEarringsItem = earringItem
            autoItems.append(earringItem)
        }
        //check jackets
        if self.currentTopSecItem == nil && self.topsSecArray.count == 0 && self.currentItemDragging!.topSecArray.count > 0
        {
            let topSecItem = self.currentItemDragging!.topSecArray.first!
            self.currentTopSecItem = topSecItem
            autoItems.append(topSecItem)
        }
        //check bottoms
        if self.currentBottomItem == nil && self.currentItemDragging!.bottomsArray.count > 0
        {
            let bottomItem = self.currentItemDragging!.bottomsArray.first!
            self.currentBottomItem = bottomItem
            autoItems.append(bottomItem)
        }
        //check shoes
        if self.currentShoeItem == nil && self.currentItemDragging!.shoesArray.count > 0
        {
            let shoeItem = self.currentItemDragging!.shoesArray.first!
            self.currentShoeItem = shoeItem
            autoItems.append(shoeItem)
        }
        
        for item in autoItems
        {
            let clothingItemImageView = self.getImageViewForItem(item)
            clothingItemImageView.xConstraint.constant = self.frontModelSize.width *  item.assetSizeSpecs.assetBoundsFront.xPos!
            clothingItemImageView.yConstraint.constant = self.frontModelSize.height * item.assetSizeSpecs.assetBoundsFront.yPos!
            clothingItemImageView.widhtConstraint.constant = self.frontModelSize.width * item.assetSizeSpecs.assetBoundsFront.width!
            clothingItemImageView.heightConstraint.constant = self.frontModelSize.height * item.assetSizeSpecs.assetBoundsFront.height!
            
            clothingItemImageView.image = ClothingItemImageView.imageForImageUrl(url: item.itemImageURL!)
            
            self.updateDotViewPositionFor(clothItem: item)

        }

    }
    
    // MARK: - Tap to hide/unhide dots and display info
    @objc func tapGestureRecognized(_ recogniser : UITapGestureRecognizer)
    {
        if interactiveDotsOn == true
        {
            let loc =  recogniser.location(in: self.view)
            
            if self.productContainerView.frame.contains(loc)
            {
                self.displayItemsDetailView()
            }
            else
            {
                self.unhideDotViews(false)
                self.unhideTableView(false)
            }

        }
        else
        {
            if self.clothingItemsTableView.alpha == 1
            {
                self.unhideTableView(false)
            }
            else
            {
                self.unhideDotViews(true)
                self.startFadeOutTimer()
            }
            
        }
    }
    
    
    
    // MARK: - Gesture Recogniser Delegate Methods
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == self.dragDropLongPressGestureRecogniser
        {
            let location = gestureRecognizer.location(in: self.view)
            
            if self.productContainerView.alpha != 0 && self.productContainerView.frame.contains(location) == true
            {
                return true
            }
            else if self.clothingItemsTableView.alpha != 0 && self.clothingItemsTableView.frame.contains(location) == true
            {
                
                return true
            }
            else
            {
               ///// return false    //putting back jacket disabled for now
                
                let loc = gestureRecognizer.location(in: self.modelItemImagesContainerView)
                
                if let imageView = self.modelItemImagesContainerView.hitTest(loc, with: nil) as? ClothingItemImageView
                {
                    return imageView.clothingType == ClothingType.top_SECONDARY
                }
                else
                {
                    return false
                }
                
            }
           
        }
        else if gestureRecognizer == self.tapRecogniser
        {
            
            let location = gestureRecognizer.location(in: self.view)
//            
//            if self.clothingItemsTableView.alpha != 0 && self.clothingItemsTableView.frame.contains(location) == true
//            {
//                return false
//            }
            
            if self.categoryCollectionView.frame.contains(location) == true
            {
                return false
            }
            
        }
        return true
    }
    
    // MARK: - Items Detail VC Delegate Methods
    func itemsDetailVCDidFinish(_ itemsDetailVC: ItemsDetailVC)
    {
        self.itemsDetailsVC?.view.removeFromSuperview()
        self.itemsDetailsVC?.removeFromParentViewController()
        
    }
    
    
    func itemsDetailVC(_ itemsDetailVC: ItemsDetailVC, wardrobeTappedForItem item: ShoeItem, toAdd add: Bool)
    {
        self.addItemToWardrobe(item, add: add)
    }
    
    
    // MARK: - Fade Away Timer Methods
    @objc func fadeOutTimerEnded()
    {
        ///print("fadeOutTimerEnded")
        
        self.unhideDotViews(false)
        //self.unhideTableView(false)

        
    }
    
    func startFadeOutTimer()
    {
        self.invalidateFadeOutTimer()
        
        self.fadeOutTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(fadeOutTimerEnded), userInfo: nil, repeats: false)
    }
    
    func invalidateFadeOutTimer()
    {
        if self.fadeOutTimer != nil
        {
            self.fadeOutTimer?.invalidate()
            
            ///print("fadeOutTimer invalidated")
        }
    }

    
    // MARK: - PinchGesture Methods

    @objc func pinchGestureRecognized(_ recognizer : UIPinchGestureRecognizer)
    {
        switch recognizer.state {
       
        case .began:
            
            
            if self.currentTopMainItem != nil
            {

                
                if viewMode == ViewMode.front
                {
                    self.zoomStarted = true
                    
                    self.modelContainerView.isHidden = true
                    loadZoomVC()
 
                }
                else
                {
                    self.zoomStarted = true
                    
                    self.modelContainerView.isHidden = true
                     loadZoomVcInRearMode()

                }
                
            }
            
            break
         
        case .changed:
            
            if self.zoomStarted == true
            {
                self.zoomVC.view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: recognizer.scale / 2)
                
                self.zoomVC.scrollView.zoomScale = recognizer.scale

            }

            break
        
        case .ended, .cancelled:
            
            if self.zoomStarted == true
            {
                
                if recognizer.scale <= 1
                {
                    self.faZoomVCDidTapClose(self.zoomVC)
                }
                else
                {
                    UIView.animate(withDuration: 0.3, animations: {
                        
                        self.zoomVC.view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                        
                    })
                }
                
                
            }
            
            self.zoomStarted = false

            
            break
            
        default:
            break
        }
    }
    
    // MARK: - ZoomVC
    func loadZoomVC()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle:Bundle(for: Wardrober.self))
        if let zoomController = storyBoard.instantiateViewController(withIdentifier: "ZoomVC") as? FAZoomVC
        {
            self.zoomVC = zoomController
            
            self.zoomVC.delegate = self
            
            let childView = zoomController.view
            childView?.translatesAutoresizingMaskIntoConstraints = false;
            childView?.clipsToBounds = true
            
            self.homeContainerVC.addChildViewController(zoomController)
            zoomController.didMove(toParentViewController: self)
            self.homeContainerVC.view.addSubview(childView!)
            self.homeContainerVC.view.clipsToBounds = true;
            
            
            
            
            zoomController.modelImage.image = self.modelImage.image
            zoomController.modelImageAspectConstraint.constant = self.modelImageAspectConstraint.constant
            
            let modelContainerFrameWrtWindow = self.view.convert(self.modelContainerView.frame, to: self.homeContainerVC.view)
            
            zoomController.modelContainerViewLeadingC.constant = modelContainerFrameWrtWindow.origin.x
            zoomController.modelContainerViewTopC.constant = modelContainerFrameWrtWindow.origin.y
            zoomController.modelContainerViewWidthC.constant = modelContainerFrameWrtWindow.size.width
            zoomController.modelContainerViewHeightC.constant = modelContainerFrameWrtWindow.size.height
            
            
            zoomController.earringsImageView.image = self.earringsImageView.image
            zoomController.topMainImageView.image = self.topMainImageView.image
            zoomController.topSecondaryImageView.image = self.topSecondaryImageView.image
            zoomController.bottomImageView.image = self.bottomImageView.image
            zoomController.shoeImageView.image = self.shoeImageView.image

            ///earrings
            zoomController.earringsImageView.xConstraint.constant = self.earringsImageView.xConstraint.constant
            zoomController.earringsImageView.yConstraint.constant = self.earringsImageView.yConstraint.constant
            zoomController.earringsImageView.widhtConstraint.constant = self.earringsImageView.widhtConstraint.constant
            zoomController.earringsImageView.heightConstraint.constant = self.earringsImageView.heightConstraint.constant

            ///top
            zoomController.topMainImageView.xConstraint.constant = self.topMainImageView.xConstraint.constant
            zoomController.topMainImageView.yConstraint.constant = self.topMainImageView.yConstraint.constant
            zoomController.topMainImageView.widhtConstraint.constant = self.topMainImageView.widhtConstraint.constant
            zoomController.topMainImageView.heightConstraint.constant = self.topMainImageView.heightConstraint.constant
            

            
            ///sec top
            zoomController.topSecondaryImageView.xConstraint.constant = self.topSecondaryImageView.xConstraint.constant
            zoomController.topSecondaryImageView.yConstraint.constant = self.topSecondaryImageView.yConstraint.constant
            zoomController.topSecondaryImageView.widhtConstraint.constant = self.topSecondaryImageView.widhtConstraint.constant
            zoomController.topSecondaryImageView.heightConstraint.constant = self.topSecondaryImageView.heightConstraint.constant
            
            ///bottom
            zoomController.bottomImageView.xConstraint.constant = self.bottomImageView.xConstraint.constant
            zoomController.bottomImageView.yConstraint.constant = self.bottomImageView.yConstraint.constant
            zoomController.bottomImageView.widhtConstraint.constant = self.bottomImageView.widhtConstraint.constant
            zoomController.bottomImageView.heightConstraint.constant = self.bottomImageView.heightConstraint.constant
            
            ///shoes
            zoomController.shoeImageView.xConstraint.constant = self.shoeImageView.xConstraint.constant
            zoomController.shoeImageView.yConstraint.constant = self.shoeImageView.yConstraint.constant
            zoomController.shoeImageView.widhtConstraint.constant = self.shoeImageView.widhtConstraint.constant
            zoomController.shoeImageView.heightConstraint.constant = self.shoeImageView.heightConstraint.constant
            
            
            
            
            ///hide hair layer
            zoomController.hairRearImageView.isHidden = true
            
            zoomController.view.layoutIfNeeded()
            
            
            let leadConstraintZoomScroll = NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0)
//            let topConstraintZoomScroll = NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0)
            
            let topConstraintZoomScroll = NSLayoutConstraint(item: childView!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.homeContainerVC.topLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)

            let trailConstraintZoomScroll = NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0)
            let bottomConstraintZoomScroll = NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)

            self.homeContainerVC.view.addConstraint(leadConstraintZoomScroll)
            self.homeContainerVC.view.addConstraint(topConstraintZoomScroll)
            self.homeContainerVC.view.addConstraint(trailConstraintZoomScroll)
            self.homeContainerVC.view.addConstraint(bottomConstraintZoomScroll)
            
            self.homeContainerVC.view.layoutIfNeeded()
            
            childView?.backgroundColor = UIColor.clear
            
            self.reorderZoomImageViewsWithZOrder()

            
        }

    }
    
    
    func loadZoomVcInRearMode()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle:Bundle(for: Wardrober.self))
        if let zoomController = storyBoard.instantiateViewController(withIdentifier: "ZoomVC") as? FAZoomVC
        {
            self.zoomVC = zoomController
            
            self.zoomVC.delegate = self
            
            let childView = zoomController.view
            childView?.translatesAutoresizingMaskIntoConstraints = false;
            childView?.clipsToBounds = true
            
            self.homeContainerVC.addChildViewController(zoomController)
            zoomController.didMove(toParentViewController: self)
            self.homeContainerVC.view.addSubview(childView!)
            self.homeContainerVC.view.clipsToBounds = true;
            
            let leadConstraintZoomScroll = NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0)
            let topConstraintZoomScroll = NSLayoutConstraint(item: childView!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.homeContainerVC.topLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)

//            let topConstraintZoomScroll = NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0)
            let trailConstraintZoomScroll = NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0)
            let bottomConstraintZoomScroll = NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
            
            self.homeContainerVC.view.addConstraint(leadConstraintZoomScroll)
            self.homeContainerVC.view.addConstraint(topConstraintZoomScroll)
            self.homeContainerVC.view.addConstraint(trailConstraintZoomScroll)
            self.homeContainerVC.view.addConstraint(bottomConstraintZoomScroll)
            
            self.homeContainerVC.view.layoutIfNeeded()
            
            childView?.backgroundColor = UIColor.clear
            
            
            
            
            zoomController.modelImage.image = self.rearModelImage.image
            
            
            let heightConstraint = NSLayoutConstraint(item: zoomController.modelImage, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.rearModelImage.frame.size.height)
            
            let aspectConstraint = NSLayoutConstraint(item: zoomController.modelImage, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: zoomController.modelImage, attribute: NSLayoutAttribute.height, multiplier: self.rearModelImageAspectConstraint.multiplier, constant: 0)
            zoomController.modelContainerView.removeConstraints([zoomController.modelImageLessThanHeightConstraint])
            
            
            zoomController.modelImage.removeConstraints([ zoomController.modelImageAspectConstraint])
            zoomController.modelImage.addConstraints([heightConstraint, aspectConstraint])
            

            
            let modelContainerFrameWrtWindow = self.view.convert(self.modelContainerView.frame, to: self.homeContainerVC.view)
            
            zoomController.modelContainerViewLeadingC.constant = modelContainerFrameWrtWindow.origin.x
            zoomController.modelContainerViewTopC.constant = modelContainerFrameWrtWindow.origin.y
            zoomController.modelContainerViewWidthC.constant = modelContainerFrameWrtWindow.size.width
            zoomController.modelContainerViewHeightC.constant = modelContainerFrameWrtWindow.size.height
            
            
            
            
            if self.currentEarringsItem != nil
            {
                zoomController.earringsImageView.image = self.rearEarringsImageView.image
                zoomController.earringsImageView.isHidden = false
            }
            else
            {
                zoomController.earringsImageView.isHidden = true
            }
            
            if self.currentTopMainItem != nil
            {
                zoomController.topMainImageView.image = self.rearTopMainImageView.image
                
                zoomController.topMainImageView.isHidden = false
            }
            else
            {
                zoomController.topMainImageView.isHidden = true
            }
            
            if self.currentTopSecItem != nil
            {
                zoomController.topSecondaryImageView.image = self.rearTopSecondaryImageView.image
                
                zoomController.topSecondaryImageView.isHidden = false
            }
            else
            {
                zoomController.topSecondaryImageView.isHidden = true
            }
            
            
            if self.currentBottomItem != nil
            {
                zoomController.bottomImageView.image = self.rearBottomImageView.image
                zoomController.bottomImageView.isHidden = false
            }
            else
            {
                zoomController.bottomImageView.isHidden = true
            }
            
            if self.currentShoeItem != nil
            {
                zoomController.shoeImageView.image = self.rearShoeImageView.image
                zoomController.shoeImageView.isHidden = false
            }
            else
            {
                zoomController.shoeImageView.isHidden = true
            }
            

            
            ///earrings
            zoomController.earringsImageView.xConstraint.constant = self.rearEarringsImageView.xConstraint.constant
            zoomController.earringsImageView.yConstraint.constant = self.rearEarringsImageView.yConstraint.constant
            zoomController.earringsImageView.widhtConstraint.constant = self.rearEarringsImageView.widhtConstraint.constant
            zoomController.earringsImageView.heightConstraint.constant = self.rearEarringsImageView.heightConstraint.constant
            
            ///top
            zoomController.topMainImageView.xConstraint.constant = self.rearTopMainImageView.xConstraint.constant
            zoomController.topMainImageView.yConstraint.constant = self.rearTopMainImageView.yConstraint.constant
            zoomController.topMainImageView.widhtConstraint.constant = self.rearTopMainImageView.widhtConstraint.constant
            zoomController.topMainImageView.heightConstraint.constant = self.rearTopMainImageView.heightConstraint.constant
            
            
            
            ///sec top
            zoomController.topSecondaryImageView.xConstraint.constant = self.rearTopSecondaryImageView.xConstraint.constant
            zoomController.topSecondaryImageView.yConstraint.constant = self.rearTopSecondaryImageView.yConstraint.constant
            zoomController.topSecondaryImageView.widhtConstraint.constant = self.rearTopSecondaryImageView.widhtConstraint.constant
            zoomController.topSecondaryImageView.heightConstraint.constant = self.rearTopSecondaryImageView.heightConstraint.constant
            
            ///bottom
            zoomController.bottomImageView.xConstraint.constant = self.rearBottomImageView.xConstraint.constant
            zoomController.bottomImageView.yConstraint.constant = self.rearBottomImageView.yConstraint.constant
            zoomController.bottomImageView.widhtConstraint.constant = self.rearBottomImageView.widhtConstraint.constant
            zoomController.bottomImageView.heightConstraint.constant = self.rearBottomImageView.heightConstraint.constant
            
            ///shoes
            zoomController.shoeImageView.xConstraint.constant = self.rearShoeImageView.xConstraint.constant
            zoomController.shoeImageView.yConstraint.constant = self.rearShoeImageView.yConstraint.constant
            zoomController.shoeImageView.widhtConstraint.constant = self.rearShoeImageView.widhtConstraint.constant
            zoomController.shoeImageView.heightConstraint.constant = self.rearShoeImageView.heightConstraint.constant
            
            
            ////reveal hair layer
            zoomController.hairRearImageView.xConstraint.constant = self.hairRearImageView.frame.origin.x
            zoomController.hairRearImageView.yConstraint.constant = self.hairRearImageView.frame.origin.y
            zoomController.hairRearImageView.widhtConstraint.constant = self.hairRearImageView.widhtConstraint.constant
            zoomController.hairRearImageView.heightConstraint.constant = self.hairRearImageView.heightConstraint.constant
            zoomController.hairRearImageView.isHidden = true
            
            zoomController.view.layoutIfNeeded()
            
            self.reorderZoomImageViewsWithZOrder()

            
            
        }
    }
    
    func reorderZoomImageViewsWithZOrder()
    {
        var currentSelectedItemsArray = [ShoeItem]()
        
        if self.currentTopMainItem != nil
        {
            currentSelectedItemsArray.append(self.currentTopMainItem!)
        }
        if self.currentTopSecItem != nil
        {
            currentSelectedItemsArray.append(self.currentTopSecItem!)
        }
        if self.currentEarringsItem != nil
        {
            currentSelectedItemsArray.append(self.currentEarringsItem!)
        }
        if self.currentBottomItem != nil
        {
            currentSelectedItemsArray.append(self.currentBottomItem!)
        }
        if self.currentShoeItem != nil
        {
            currentSelectedItemsArray.append(self.currentShoeItem!)
        }
        
        
        currentSelectedItemsArray.sort(by: { (shoeItem1, shoeItem2) -> Bool in
            
            return shoeItem1.zOrder <= shoeItem2.zOrder
        })
        
        
        
        let view = zoomVC!.topMainImageView.superview as UIView!
        
        var currentTopImageView : ClothingItemImageView!
        for index in (0 ..< currentSelectedItemsArray.count).reversed()
        {
            let imageView = self.getZoomImageViewForItem(currentSelectedItemsArray[index])
            if index == currentSelectedItemsArray.count - 1
            {
                view?.bringSubview(toFront: imageView)
            }
            else
            {
                view?.insertSubview(imageView, belowSubview: currentTopImageView)
            }
            
            currentTopImageView = imageView
            
        }
        

        view?.bringSubview(toFront: zoomVC.hairRearImageView)
        
    }
    
    
    

    
    
    
    func getZoomImageViewForItem(_ item : ShoeItem) -> ClothingItemImageView
    {
        var imageView : ClothingItemImageView!
        switch item.clothingType!
        {
        case ClothingType.earrings:
            imageView = zoomVC!.earringsImageView
            break
            
        case ClothingType.top_MAIN:
            imageView = zoomVC!.topMainImageView
            break
            
        case ClothingType.top_SECONDARY:
            imageView = zoomVC!.topSecondaryImageView
            break
            
        case ClothingType.bottom:
            imageView = zoomVC!.bottomImageView
            break
            
        case ClothingType.shoes:
            imageView = zoomVC!.shoeImageView
            break
            
        default:
            imageView = zoomVC!.topMainImageView
            break
        }
        
        return imageView
    }
    
    func faZoomVCDidTapClose(_ zoomVC: FAZoomVC) {

        self.zoomVC.view.removeFromSuperview()
        self.zoomVC.removeFromParentViewController()
        self.zoomVC = nil
        
        
        self.modelContainerView.isHidden = false

    }
    
    
    
    // MARK: - Item Tag Drag View
    func loadItemTagDragVC()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle:Bundle(for: Wardrober.self))
        if let dragVC = storyBoard.instantiateViewController(withIdentifier: "TagDragDropVC") as? TagDragDropVC
        {
            self.itemTagDragVC = dragVC
            
            let childView = dragVC.view
            childView?.translatesAutoresizingMaskIntoConstraints = false;
            childView?.clipsToBounds = true

            
            self.homeContainerVC.addChildViewController(dragVC)
            dragVC.didMove(toParentViewController: self)
            self.homeContainerVC.view.addSubview(childView!)
            self.homeContainerVC.view.clipsToBounds = true;
            
            
            /// set the initial Product Container View constraints here
           let productContainerFrameWrtWindow = self.view.convert(self.productContainerView.frame, to: self.homeContainerVC.view)
            
            dragVC.productContainerView_X_Constraint.constant = productContainerFrameWrtWindow.origin.x
            dragVC.productContainerView_Y_Constraint.constant = productContainerFrameWrtWindow.origin.y
            dragVC.productContainerView_W_Constraint.constant = productContainerFrameWrtWindow.size.width
            dragVC.productContainerView_H_Constraint.constant = productContainerFrameWrtWindow.size.height
            
            
            dragVC.infoContainerView_W_Constraint.constant = self.infoContainerView_W_Constraint.constant
            dragVC.infoContainerView_H_Constraint.constant = self.infoContainerView_H_Constraint.constant

            
            
//            dragVC.designerLable_W_Constraint.constant = self.designerLable.frame.size.width
//            dragVC.brandLable_W_Constraint.constant = self.brandLable.frame.size.width
            
            dragVC.view.layoutIfNeeded()
            
            
            dragVC.designerLable.text = self.designerLable.text
            dragVC.brandLable.text = self.brandLable.text
            dragVC.costLable.text = self.costLable.text
            dragVC.designerLable.font = self.designerLable.font
            dragVC.brandLable.font = self.brandLable.font
            dragVC.costLable.font = self.costLable.font
            
            
            dragVC.dotView.backgroundColor = self.dotView.backgroundColor
            dragVC.dotView.layer.borderWidth = self.dotView.layer.borderWidth
            
            dragVC.productContainerView.layer.borderColor = self.productContainerView.layer.borderColor
            
            
            
            let leadConstraintDragView = NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0)
//            let topConstraintDragView = NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0)
            
            let topConstraintDragView = NSLayoutConstraint(item: childView!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.homeContainerVC.topLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)

            let trailConstraintDragView = NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0)
            let bottomConstraintDragView = NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
            
            self.homeContainerVC.view.addConstraint(leadConstraintDragView)
            self.homeContainerVC.view.addConstraint(topConstraintDragView)
            self.homeContainerVC.view.addConstraint(trailConstraintDragView)
            self.homeContainerVC.view.addConstraint(bottomConstraintDragView)
            
            self.homeContainerVC.view.layoutIfNeeded()
            
            childView?.backgroundColor = UIColor.clear
            
            
        }
        
    }
    
    func closeItemTagDragView() {
        
        self.productContainerView.isHidden = false

        UIView.animate(withDuration: 0.3, animations: {
            
            self.itemTagDragVC.view.alpha = 0
            
            }, completion: { (finished) in
                
                self.itemTagDragVC.view.removeFromSuperview()
                self.itemTagDragVC.removeFromParentViewController()
                self.itemTagDragVC = nil
                
        }) 
        
        
    }
    
    func performCancelTagDragAnimation()
    {
        UIView.animate(withDuration: 0.4, animations: {
            
            self.itemTagDragVC.productContainerView_X_Constraint.constant =
                self.itemTagDragVC.startTagDragOrigin.x
            
            self.itemTagDragVC.productContainerView_Y_Constraint.constant =
                self.itemTagDragVC.startTagDragOrigin.y
            self.itemTagDragVC.view.layoutIfNeeded()
            
            
            
            self.itemTagDragVC.bgView.alpha = 0
            
            self.itemTagDragVC.productContainerView.transform = CGAffineTransform.identity
            
            }, completion: { (finished) in
                
                let dotView =  self.getDotViewForCurrentItem()
                dotView.isHidden = false
                
                self.closeItemTagDragView()
                self.currentDragMode = DragMode.none
                
                self.startFadeOutTimer()
                
        })
    }
    
    func performTagAddedToWardrobeAnimation()
    {
        
        UIView.animate(withDuration: 0.4, animations: {
            
            self.itemTagDragVC.productContainerView_X_Constraint.constant =
                self.itemTagDragVC.view.bounds.size.width
            
            self.itemTagDragVC.productContainerView_Y_Constraint.constant =
                self.itemTagDragVC.view.bounds.size.height
            
            self.itemTagDragVC.productContainerView.alpha = 0
            
            self.itemTagDragVC.view.layoutIfNeeded()
            
            }, completion: { (finished) in
                
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.itemTagDragVC.wardrobeView.alpha = 0
                    self.itemTagDragVC.checkmarkView.alpha = 1
                    
                    }, completion: { (finished) in
                        
                        let item = self.getCurrentItemForClothingType(self.currentClothingTypeForSwap!)
                        item?.isAddedToWardrobe = true
                        
                        self.refreshColorForDotViews()
                        self.refreshColorForCurrentInfoView()
                        
                        
                        self.addItemToWardrobe(self.currentItemSelectedForInfoView!, add: true)
                        
                        self.delay(0.3, closure: {
                            
                            let dotView =  self.getDotViewForCurrentItem()
                            dotView.isHidden = false
                            self.closeItemTagDragView()
                            self.currentDragMode = DragMode.none
                            self.startFadeOutTimer()
                        })
                        
                        
                })
                
                
                
        })
    }
    
    
    func performTagAddedToCartAnimation()
    {
        
        UIView.animate(withDuration: 0.4, animations: {
            
            self.itemTagDragVC.productContainerView_X_Constraint.constant =
                self.itemTagDragVC.view.bounds.size.width
            
            self.itemTagDragVC.productContainerView_Y_Constraint.constant =
                -self.itemTagDragVC.productContainerView.bounds.size.height
            
            self.itemTagDragVC.productContainerView.alpha = 0
            
            self.itemTagDragVC.view.layoutIfNeeded()
            
            }, completion: { (finished) in
                
                let dotView =  self.getDotViewForCurrentItem()
                dotView.isHidden = false
                
                
                
                self.closeItemTagDragView()
                self.currentDragMode = DragMode.none
                self.startFadeOutTimer()
                
                self.displayItemsDetailView()
                
                
        })
    }
    
    
    // MARK: - Action Panel IBActions
    @IBAction func wardrobeBtnTapped(_ sender : UIButton)
    {
        let userSignedIn =   UserDefaults.standard.bool(forKey: Constants.kUserSuccessfullySignedIn)
        if userSignedIn == false
        {
            self.presentSignIn()
            return
        }
        let storyBoard = UIStoryboard(name: "Main", bundle:Bundle(for: Wardrober.self))
        if let wardrobeVC = storyBoard.instantiateViewController(withIdentifier: "WardrobeVC") as? WardrobeVC
        {
            wardrobeVC.homeContainerVC = self.homeContainerVC
            self.homeContainerVC.homeNavigationController?.pushViewController(wardrobeVC, animated: true)
            
        }
    }
    
    
    @IBAction func flipBtnTapped(_ sender : UIButton)
    {
        self.flipButton.isEnabled = false
        
        let DURATION = 0.5
        if viewMode == ViewMode.front
        {

            
            self.setAndReorderRearImageViewsWithZOrder()

            self.rearModelImage.alpha = 1
            self.rearModelItemImagesContainerView.alpha = 1
            
            ////disabling rear hair image for now
            //            self.hairRearImageView.isHidden = false
            
            self.hairRearImageView.isHidden = true
            /////////
            
            UIView.transition(from: self.modelImage, to: self.rearModelImage, duration: DURATION, options: [UIViewAnimationOptions.transitionFlipFromRight, UIViewAnimationOptions.showHideTransitionViews]) { (finished) in
                

            }
            UIView.transition(from: self.modelItemImagesContainerView, to: self.rearModelItemImagesContainerView, duration: DURATION, options: [UIViewAnimationOptions.transitionFlipFromRight, UIViewAnimationOptions.showHideTransitionViews]) { (finished) in
                
                self.flipButton.isEnabled = true

            }
            
            viewMode = ViewMode.rear
            
            
            
        }
        else
        {

            self.hairRearImageView.isHidden = true

            UIView.transition(from: self.rearModelImage, to: self.modelImage, duration: DURATION, options: [UIViewAnimationOptions.transitionFlipFromRight, UIViewAnimationOptions.showHideTransitionViews]) { (finished) in
                
                self.rearModelImage.alpha = 0
            }
            UIView.transition(from: self.rearModelItemImagesContainerView, to: self.modelItemImagesContainerView, duration: DURATION, options: [UIViewAnimationOptions.transitionFlipFromRight, UIViewAnimationOptions.showHideTransitionViews]) { (finished) in
                
                self.rearModelItemImagesContainerView.alpha = 0

                self.flipButton.isEnabled = true
                
            }
            
            viewMode = ViewMode.front

        }
    }
    
    
    
    func checkPhotoLibraryPermission() -> (Bool?, String?)
    {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status
        {
        case .authorized:
            //handle authorized status
            return (true, nil)
            
        case .denied, .restricted :
            //handle denied status
            return (false, "You've denied or restricted \'Wardrober\' to access your Photo Library. Please go to Settings on your device and select \'Wardrober\' app for permissions and enable Photo Library by turning the Photo Library switch ON")
            
            
            
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { (status) -> Void in
                switch status {
                case .authorized:
                    
                    self.takeModelScreenShot(nil)
                    
                    break
                    
                case .denied, .restricted:
                    
                    self.takeModelScreenShot(nil)
                    
                    break
                    
                case .notDetermined:
                    
                    self.takeModelScreenShot(nil)
                    
                    break
                }
                
            }
        }
        return (nil, nil)
    }
    
    @IBAction func takeModelScreenShot(_ sender: AnyObject?) {
        
        
        let (permitted, message, model_screenshot) = self.getScreenshotWithWardrobersLogo()
        
        
        if permitted == true
        {
            UIImageWriteToSavedPhotosAlbum(model_screenshot!, self, #selector(ModelVC.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        else
        {
            if let mesg = message
            {
                let alert=UIAlertController(title: "Error" , message: mesg, preferredStyle: UIAlertControllerStyle.alert);
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    
    func getScreenshotWithWardrobersLogo() -> (Bool, String?, UIImage?)
    {
        let (permitted, message) = self.checkPhotoLibraryPermission()
        
        if permitted == true
        {
            
            let layer = UIApplication.shared.keyWindow!.layer
            let scale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
            
            layer.render(in: UIGraphicsGetCurrentContext()!)
            var model_screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let capturedImage = model_screenshot //Captured image
            {
                let overlayImage  = UIImage(named : "wardrober_logo_tm", in: Bundle(for: type(of: self)), compatibleWith: nil)
                
                let newSize = capturedImage.size
                UIGraphicsBeginImageContextWithOptions(newSize, true, 0.0);
                
                let capturedFrame = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
                capturedImage.draw(in: capturedFrame)
                
                let overlayX = self.modelImage.frame.origin.x + self.modelImage.frame.size.width + 10 ////(201.0/375.0) * newSize.width
                let overlayY =  self.homeContainerVC.childContentView.frame.origin.y + self.modelImage.frame.origin.y /////(24.0/667.0) * newSize.height
                let overlayW = CGFloat(150.0)
                let overlayH = (overlayImage!.size.height / overlayImage!.size.width) * overlayW
                let overlayFrame = CGRect(x: overlayX, y: overlayY, width: overlayW, height: overlayH)
                overlayImage?.draw(in: overlayFrame, blendMode: CGBlendMode.normal, alpha: 1)
                
                
                model_screenshot = UIGraphicsGetImageFromCurrentImageContext();
                
                UIGraphicsEndImageContext();
            }
            
            return (true, nil, model_screenshot)
            
        }
        else
        {
            
            return (false, message, nil)
            
        }
    }
    
    
    
    @objc func image(_ image : UIImage, didFinishSavingWithError error : NSError?, contextInfo info : UnsafeMutableRawPointer)
    {
        var title = "Saved"
        var message = "Screenshot saved successfully to your Photo Library"
        
        if error != nil
        {
            title = "Error"
            message = "Screenshot couldn't be saved. \(error!.localizedDescription)"
        }
        let alert=UIAlertController(title: title , message: message, preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func shareModeldetails(_ sender: AnyObject) {
        
        
        let modelItemInfo =  String(format: "%@\n\n", Constants.shareMessageWardrober)
        
        let (permitted, message, modelSharedImage) = self.getScreenshotWithWardrobersLogo()
        
        
        if permitted == false
        {
            
            if let mesg = message
            {
                let alert=UIAlertController(title: "Error" , message: mesg, preferredStyle: UIAlertControllerStyle.alert);
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
                
                self.present(alert, animated: true, completion: nil)
            }
            
            return
        }
        
        switch (Constants.deviceIdiom)
        {
            
        case .pad:
            
            let activityViewController = UIActivityViewController(activityItems: [modelItemInfo,modelSharedImage!], applicationActivities: nil)
            
            let sourceView = sender as! UIView
            
            activityViewController.popoverPresentationController?.sourceView = sourceView
            activityViewController.popoverPresentationController?.sourceRect = sourceView.bounds
            
            self.present(activityViewController, animated: true, completion: nil)
            
        case .phone:
            
            let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [modelItemInfo,modelSharedImage!], applicationActivities: nil)
            
            self.navigationController!.present(activityViewController, animated: true, completion: nil)
            
            activityViewController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                
                // Return if cancelled
                if (!completed)
                {
                    ///print("user clicked cancel")
                    return
                }
                else
                {
                    completed
                }
            }
            
        default: break
            ///print("Unspecified UI idiom")
            
        }
    }
    
    @IBAction func showJacketsTapped()
    {
        if self.clothingItemsTableView.alpha == 0
        {
            self.unhideTableView(true)
        }
        
        self.currentClothingTypeForSwap = ClothingType.top_SECONDARY
        self.lastItemReached = false
        ///reload TableView data
        self.clothingItemsTableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.automatic)
        self.view.layoutIfNeeded()
        
        self.showJacketsButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.showJacketsButton.alpha = 0
            self.productContainerView.alpha = 0
            
        }, completion: { (finished) in
            
            
            self.showJacketsButton.isUserInteractionEnabled = true
            
        }) 
        
    }
    

    @IBAction func popupButtonTapped(_ sender: AnyObject)
    {
    
        var selectedItems = [ShoeItem]()
        
        if let earringsItem = self.getCurrentItemForClothingType(ClothingType.earrings)
        {
            earringsItem.sizeSelected = nil
            selectedItems.append(earringsItem)
        }
        
        if let topSecItem = self.getCurrentItemForClothingType(ClothingType.top_SECONDARY)
        {
            topSecItem.sizeSelected = nil
            selectedItems.append(topSecItem)
        }
        
        
        if let topmainItem = self.getCurrentItemForClothingType(ClothingType.top_MAIN)
        {
            topmainItem.sizeSelected = nil
            selectedItems.append(topmainItem)
        }
        
        
        if let bottomItem = self.getCurrentItemForClothingType(ClothingType.bottom)
        {
            bottomItem.sizeSelected = nil
            selectedItems.append(bottomItem)
        }
        
        
        if let shoeItem = self.getCurrentItemForClothingType(ClothingType.shoes)
        {
            shoeItem.sizeSelected = nil
            selectedItems.append(shoeItem)
        }
        
        if selectedItems.count == 0
        {
            return
        }
       
        self.loadingPopupVC(selectedItems)
    }
    
    func loadingPopupVC(_ selectedItems : [ShoeItem])
    {
        
        for index in 0..<selectedItems.count
        {
            let item = selectedItems[index]
            
            let itemCopy = ShoeItem()
            itemCopy.itemProductID = item.itemProductID
            itemCopy.itemName = item.itemName
            itemCopy.itemType = item.itemType
            itemCopy.itemImageURL = item.itemImageURL
            itemCopy.designerName = item.designerName
            itemCopy.price = item.price
            itemCopy.isAssetDownloading = item.isAssetDownloading
            itemCopy.isAssetDownloaded = item.isAssetDownloaded
            itemCopy.clothingType = item.clothingType
            FACart.sharedCart().addItemToCart(itemCopy)
            
            
            let wrCartItem = WRCartItem()
            wrCartItem.itemProductID = item.itemProductID
            wrCartItem.isAddedToWardrobe = item.isAddedToWardrobe
            wrCartItem.price = item.price
            wrCartItem.sizeSelected = item.sizeSelected?.itemSizeName
            
            
            if let wrDelegate = Wardrober.shared().delegate
            {
                wrDelegate.wardroberAddedAnItemToCart?(item: wrCartItem)
            }
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: WardroberNotifications.ItemAddedToCart, object: wrCartItem)
            }
            

        }
        self.loadShoppingCartView()
        
//        self.shoppingCartController.animateCheckoutButton()

    }

    
    func loadShoppingCartView()
    {
        let storyBoard = UIStoryboard(name: "Checkout", bundle:Bundle(for: Wardrober.self))
        self.shoppingCartController = storyBoard.instantiateViewController(withIdentifier: "ShoppingCart") as? ShoppingCart
        
        shoppingCartController.delegate = self
        
        
        let childView = self.shoppingCartController.view
        childView?.translatesAutoresizingMaskIntoConstraints = false;
        
        self.homeContainerVC.addChildViewController(shoppingCartController)
        shoppingCartController.didMove(toParentViewController: self.homeContainerVC)
        self.homeContainerVC.view.addSubview(childView!)
        self.homeContainerVC.view.clipsToBounds = true
        
        let leadConstraintPopupView = NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: childView , attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0)
        let topConstraintPopupView = NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0)
        let trailConstraintPopupView = NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0)
        let bottomConstraintPopupView = NSLayoutConstraint(item: self.homeContainerVC.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
        
        self.homeContainerVC.view.addConstraint(leadConstraintPopupView)
        self.homeContainerVC.view.addConstraint(topConstraintPopupView)
        self.homeContainerVC.view.addConstraint(trailConstraintPopupView)
        self.homeContainerVC.view.addConstraint(bottomConstraintPopupView)
        
        self.homeContainerVC.view.layoutIfNeeded()

    }
    
    func shoppingCartDidTapBackButton(_ shoppingCart: ShoppingCart!)
    {
        self.shoppingCartController.view.removeFromSuperview()
        self.shoppingCartController.removeFromParentViewController()
        self.shoppingCartController = nil
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }

    
}


extension ModelVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Wardrober.shared().categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FACategoryTitleCell", for: indexPath) as! FACategoryTitleCell
        
        let category = Wardrober.shared().categories[indexPath.row]
        
        cell.categoryNameLabel.text = category.categoryName
        
        if indexPath.row == self.selectedCategoryIndex
        {
            cell.underlineView.alpha = 1
        }
        else
        {
            cell.underlineView.alpha = 0
        }
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let categoryCell = cell as! FACategoryTitleCell
        
        categoryCell.underlineViewWConstraint.constant = categoryCell.categoryNameLabel.intrinsicContentSize.width + 4
        categoryCell.underlineView.layoutIfNeeded()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if viewMode == ViewMode.rear
        {
            self.flipBtnTapped(self.flipButton)
        }
        
        
        self.fadeModelContainerView(0)
        

        
        self.selectedCategoryIndex = indexPath.row
        
        collectionView.reloadData()

        self.slideToCategoryAtIndex(selectedCategoryIndex, animated: true)
        
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
         let category = Wardrober.shared().categories[indexPath.row]
        
        let font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        
        if let categoryName =  category.categoryName
        {
            let height = collectionView.frame.size.height
            let width = categoryName.width(forConstraintedHeight: height, font: font!)
            
            return CGSize(width : width + 6, height : height)
        }
        else
        {
            return CGSize.zero
        }
        
    }
    
}


extension String {
    func width(forConstraintedHeight height : CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.width
    }
}

//
//  ItemsDetailVC.swift
//  Fashion180
//
//  Created by Yogi on 18/10/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//

import UIKit

enum ITEMS_DETAIL_MODE {
    case model_SCENE
    case wardrobe_SCENE
    
}
 
protocol ItemsDetailVcDelegate
{
    func itemsDetailVCDidFinish(_ itemsDetailVC : ItemsDetailVC)
    
    func itemsDetailVC(_ itemsDetailVC : ItemsDetailVC, wardrobeTappedForItem item : ShoeItem, toAdd add : Bool)

}

class ItemsDetailVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ItemDetailCollectionViewCellDelegate, ShoppingCartDelegate, UIGestureRecognizerDelegate
    
{
    
    
    @IBOutlet var bgView : UIView!
    
    var delegate : ItemsDetailVcDelegate!
    
    @IBOutlet var itemsCollectionView : UICollectionView!
    
    
    @IBOutlet var itemsDetailAnimationView : ItemDetailAnimationView!
    
    
    var currentItemIndex : NSInteger? = nil
    
    var shoppingCartController : ShoppingCart!
    var shoppingCartViewLeadingConstraint : NSLayoutConstraint!
    var shoppingCartViewTrailingConstraint : NSLayoutConstraint!
    
    
    @IBOutlet var collectionViewTopConstraint : NSLayoutConstraint!
    @IBOutlet var collectionViewBottomConstraint : NSLayoutConstraint!
    
    var collectionViewTop : CGFloat!
    var collectionViewBottom : CGFloat!
    
    var shouldDetectPanning : Bool = true
    
    var productSizesArray : NSMutableArray = []
    
    
    
    var currentIndexpath : Int!
    
    
    var selectedItems : [ShoeItem] = [ShoeItem]()
    var scrollToCenterItemIndex : NSInteger!
    
    
    var firstLayout = false
    
    var mode : ITEMS_DETAIL_MODE!
    
    var descriptionLabelFontSize : CGFloat!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        switch (Constants.deviceIdiom)
        {
        case .pad:
            self.descriptionLabelFontSize = 15
            
        case .phone:
            self.descriptionLabelFontSize = 10
        default: break
            ///print("Unspecified UI idiom")
            
        }

        
        self.currentIndexpath = 0
        
        
        let panGestureRecogr = UIPanGestureRecognizer(target: self, action: #selector(ItemsDetailVC.panGestureRecognized))
        panGestureRecogr.delegate = self
        self.view.addGestureRecognizer(panGestureRecogr)
        
        currentItemIndex  = 0
        
        self.itemsDetailAnimationView.layer.shadowColor = UIColor.black.cgColor
        self.itemsDetailAnimationView.layer.shadowOffset = CGSize(width: -10, height: -10)
        self.itemsDetailAnimationView.layer.shadowOpacity = 0.4
        self.itemsDetailAnimationView.layer.shadowRadius = 6
        
        
        collectionViewTop = self.collectionViewTopConstraint.constant
        collectionViewBottom = self.collectionViewBottomConstraint.constant
        
        
        self.loadShoppingCartView()

        NotificationCenter.default.addObserver(self, selector: #selector(ItemsDetailVC.anItemWasAddedToWardrobe), name: NSNotification.Name(rawValue: Constants.kAddedToWardrobeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ItemsDetailVC.anItemWasDeletedFromWardrobe), name: NSNotification.Name(rawValue: Constants.kRemovedFromWardrobeNotification), object: nil)

        
    }
    
    // MARK: - wardrobe NSNotification Handling

    @objc func anItemWasAddedToWardrobe()
    {
        self.itemsCollectionView.reloadData()
        self.itemsCollectionView.layoutIfNeeded()
        
        self.handleScrollViewScrolling()
    }
    
    @objc func anItemWasDeletedFromWardrobe()
    {
        
        
        if self.mode == ITEMS_DETAIL_MODE.wardrobe_SCENE
        {
            var itemsDeleted = [ShoeItem]()
            
            for item in self.selectedItems
            {
                if item.isAddedToWardrobe == false
                {
                    itemsDeleted.append(item)
                }
            }
            
            for item in itemsDeleted
            {
                if self.selectedItems.contains(item)
                {
                    self.selectedItems.remove(at: self.selectedItems.index(of: item)!)
                }
            }
            
            
            
            if self.selectedItems.count > 0
            {
                
                self.itemsCollectionView.performBatchUpdates({
                    
                    self.itemsCollectionView.reloadSections(IndexSet(integer: 0))
                    
                    }, completion: { (finished) in
                        
                        self.itemsCollectionView.layoutIfNeeded()
                        
                        self.handleScrollViewScrolling()

                })
            }
            else
            {
                shouldDetectPanning = false
                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    
                    self.bgView.alpha = 0
                    
                    self.collectionViewTopConstraint.constant =  self.view.bounds.size.height
                    self.collectionViewBottomConstraint.constant = -self.view.bounds.size.height
                    
                    
                    self.view.layoutIfNeeded()
                    
                    }, completion: { (finished) in
                        
                        
                        self.delegate.itemsDetailVCDidFinish(self)
                        
                        
                })
            }
        }
        else
        {
            self.itemsCollectionView.reloadData()
            self.itemsCollectionView.layoutIfNeeded()
            
            self.handleScrollViewScrolling()
        }
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
      
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

//        if firstLayout == true
//        {
//            firstLayout = false
//            self.itemsCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: self.scrollToCenterItemIndex, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
//        }
        self.handleScrollViewScrolling()

    }
    
    
    func loadItemSizesForItem(_ shoeItem : ShoeItem)
    {
        if shoeItem.isSizesDownloading == true
        {
            return
        }
        
        shoeItem.isSizesDownloading = true
        
        let url = String(format: "%@/%@/%@", arguments: [Wardrober.shared().serviceMainUrl!,Urls.GetItemSizesByProductID,shoeItem.itemProductID]);
        
        FAServiceHelper().get(url: url, completion : { (success : Bool?, message : String?, responseObject : AnyObject?) in
            
            guard success == true else
            {
                return
            }
            
            guard responseObject == nil else
            {
                let sizesArray =  ItemSizeHelper.productItemParsing(responseObject! as AnyObject?)
                
                shoeItem.itemSizes = sizesArray
                shoeItem.isSizesDownloaded = true
                shoeItem.isSizesDownloading = false
                
                let visibleCells = self.itemsCollectionView.visibleCells as! [ItemDetailCollectionViewCell]
                
                var isCellVisible = false
                for cell in visibleCells
                {
                    let indexPath = self.itemsCollectionView.indexPath(for: cell)
                    
                    if indexPath!.row == self.selectedItems.index(of: shoeItem)!
                    {
                        isCellVisible = true
                        break
                    }
                }
                
                if isCellVisible == true
                {
                    self.itemsCollectionView.reloadData()
                    self.itemsCollectionView.reloadItems(at: [IndexPath(item:self.selectedItems.index(of: shoeItem)!, section: 0)])
                    
                    self.itemsCollectionView.layoutIfNeeded()
                    
                    self.handleScrollViewScrolling()
                }
                
                return
            }
        })
        
    }
    
    
    func loadShoppingCartView()
    {
        let storyBoard = UIStoryboard(name: "Checkout", bundle:Bundle(for: Wardrober.self))
        self.shoppingCartController = storyBoard.instantiateViewController(withIdentifier: "ShoppingCart") as? ShoppingCart
        
        let childView = self.shoppingCartController!.view
        childView?.translatesAutoresizingMaskIntoConstraints = false;
        
        self.addChildViewController(shoppingCartController)
        shoppingCartController!.didMove(toParentViewController: self)
        self.view.addSubview(childView!)
        self.view.clipsToBounds = true;
        
        
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0.0))
        self.shoppingCartViewLeadingConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0)
        self.view.addConstraint(shoppingCartViewLeadingConstraint)
        
        self.shoppingCartViewTrailingConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0)
        self.view.addConstraint(shoppingCartViewTrailingConstraint)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
        
        self.view.layoutIfNeeded()
        
        self.shoppingCartController.view.isHidden = true
    }
    
    
    func shoppingCartDidTapBackButton(_ shoppingCart: ShoppingCart!)
    {
        
        
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.shoppingCartViewLeadingConstraint.constant = self.view.bounds.size.width
            self.shoppingCartViewTrailingConstraint.constant = self.view.bounds.size.width
            
            self.view.layoutIfNeeded()
            
        }) { (finished) in
            
            self.shoppingCartController.view.isHidden  = true
            self.shoppingCartViewLeadingConstraint.constant = 0
            self.shoppingCartViewTrailingConstraint.constant = 0
            
            self.itemsCollectionView.reloadData()
            
            self.itemsCollectionView.layoutIfNeeded()
            
            self.handleScrollViewScrolling()
            
        }
        
    }
    
    func swipeDetectorViewSwipedDown()
    {
        ///print("swipeDetectorViewSwiped right")
        
        
        let cells = self.itemsCollectionView.visibleCells
        
        for cell in cells
        {
            
            var rotationAndPerspectiveTransform = CATransform3DIdentity;
            rotationAndPerspectiveTransform.m34 = 1.0 / -500;
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, (89 * CGFloat(M_PI)) / 180.0, 0.0, 1.0, 0.0);
            cell.contentView.alpha = 0.8;
            cell.contentView.layer.transform = rotationAndPerspectiveTransform;
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.bgView.alpha = 0
                
                
                cell.contentView.layer.transform = CATransform3DIdentity;
                cell.contentView.alpha = 0;
                
            }) { (finished) in
                
                self.delegate.itemsDetailVCDidFinish(self)
                
            }
        }
        
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        
        let recogniser = gestureRecognizer as? UIPanGestureRecognizer
        let velocity = recogniser!.velocity(in: self.view)
        
        return fabs(velocity.y) > fabs(velocity.x)
        
    }
    
    @objc func panGestureRecognized(_ recogniser : UIPanGestureRecognizer)
    {
        
        
        if shouldDetectPanning == false
        {
            return
        }
        
        let translatedPoint =  recogniser.translation(in: self.view)
        
        //print("touch changed = \(translatedPoint.x) \(translatedPoint.y)")
        
        
        switch recogniser.state
        {
            
        case .began:
            
            //print("touch began")
            
            break
            
        case .ended:
            
            let velocity = recogniser.velocity(in: self.view)
            ///print("velocity.y \(velocity.y)")
            if velocity.y > 200
            {
                shouldDetectPanning = false
                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    
                    self.bgView.alpha = 0
                    
                    self.collectionViewTopConstraint.constant =  self.view.bounds.size.height
                    self.collectionViewBottomConstraint.constant = -self.view.bounds.size.height
                    
                    
                    self.view.layoutIfNeeded()
                    
                    }, completion: { (finished) in
                        
                        
                        self.delegate.itemsDetailVCDidFinish(self)
                        
                        
                })
            }
                
            else if translatedPoint.y < 200
            {
                
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    
                    self.collectionViewTopConstraint.constant =  self.collectionViewTop
                    self.collectionViewBottomConstraint.constant = self.collectionViewBottom
                    
                    self.view.layoutIfNeeded()
                    
                    }, completion: { (finished) in
                        
                })
                
            }
            
            ///print("touch Ended")
            
            break
            
        case.changed:
            
            
            if translatedPoint.y < 200
            {
                UIView.animate(withDuration: 0.03, animations: {
                    
                    self.collectionViewTopConstraint.constant =  self.collectionViewTop + translatedPoint.y
                    self.collectionViewBottomConstraint.constant = self.collectionViewBottom - translatedPoint.y
                    
                    self.view.layoutIfNeeded()
                    
                })
            }
            else
            {
                
                shouldDetectPanning = false
                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    
                    self.bgView.alpha = 0
                    
                    self.collectionViewTopConstraint.constant =  self.view.bounds.size.height
                    self.collectionViewBottomConstraint.constant = -self.view.bounds.size.height
                    
                    self.view.layoutIfNeeded()
                    
                    }, completion: { (finished) in
                        
                        
                        self.delegate.itemsDetailVCDidFinish(self)
                        
                })
                
            }
            
            break
            
        case .cancelled:
            
            break
            
            
        default:
            
            break
            
        }
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Collection View methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        
        return 1
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return self.selectedItems.count
        
    }
    
    
    @objc func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: collectionView.bounds.size.width * (340.0 / 414.0), height: collectionView.bounds.size.height)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemDetailCollectionViewCell", for: indexPath) as! ItemDetailCollectionViewCell
        
        cell.buttonAddToBag.tag = indexPath.row
        cell.buttonCheckout.tag = indexPath.row
        cell.wardrobeBtn.tag = indexPath.row

        cell.collectionView = self.itemsCollectionView
        
        cell.messageLabel.text = ""
        cell.delegate = self
        
        
        //cell.productSizeView.delegate = cell
        
        let item = selectedItems[indexPath.row]
        
        let cartCount = FACart.sharedCart().getCartCount()
        var btnTitleStr = "(\(FACart.sharedCart().getCartCount())) ADD TO BAG"
        if cartCount == 0
        {
            btnTitleStr = "ADD TO BAG"
        }
        
        cell.buttonAddToBag.setTitle(btnTitleStr, for: UIControlState())
        
        
        let itemSizeNames = NSMutableArray()
        let itemSizeCounts = NSMutableArray()
        
        for itemSize in item.itemSizes
        {
            itemSizeNames.add(itemSize.itemSizeName)
            itemSizeCounts.add(NSNumber(value: Int32(itemSize.itemAvailability) as Int32))
        }
        
        ///print("the ItemsSizeNames \(itemSizeNames)")
        
        if item.isSizesDownloaded == true
        {
            
            cell.customView.itemSizeNamesArray = itemSizeNames
            cell.customView.itemsSizesCountArray = itemSizeCounts
            
            //cell.productSizeView.tags = itemSizeNames
            //cell.productSizeView.itemsSizes = itemSizeCounts
            
            if let selectedSize = item.sizeSelected as ItemSize?
            {
                cell.customView.selectedIndex = (item.itemSizes.index(of: selectedSize)!)
            }
            else
            {
                cell.customView.selectedIndex = -1
            }
            
            
        }
        else
        {
            //cell.productSizeView.selectedIndex = -1
            //cell.productSizeView.tags  = NSMutableArray()
            //cell.productSizeView.itemsSizes  = NSMutableArray()
            
            cell.customView.itemSizeNamesArray = NSMutableArray()
            if item.isSizesDownloading == false
            {
                
                self.loadItemSizesForItem(item)
            }
            
        }
        
        
        let sizeCollectionView = cell.customView.productsCollectionView
        sizeCollectionView?.reloadData()
        cell.customView.layoutIfNeeded()
        
        
        
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 2.0
        
        
        if(item.isAddedToWardrobe == true)
        {
            
            cell.layer.borderColor = Constants.dotSelectedColor.cgColor
            cell.dotView.backgroundColor = Constants.dotSelectedColor
            cell.wardrobeBtn.isSelected = true
            
        }
        else
        {
            
            cell.layer.borderColor = Constants.productBlackColor.cgColor
            cell.dotView.backgroundColor = Constants.dotUnselectedColor
            cell.wardrobeBtn.isSelected = false

        }
        
        if cell.wardrobeBtn.isSelected == true
        {
            cell.wardrobeBtn.backgroundColor = Constants.wardrobeButtonSelectedColor
        }
        else
        {
            cell.wardrobeBtn.backgroundColor = UIColor.white
        }
        
        
        if item.sizeSelected == nil
        {
            cell.buttonAddToBag.alpha = 0.5
            cell.buttonAddToBag.isEnabled = false
        }
        else
        {
            cell.buttonAddToBag.alpha = 1
            cell.buttonAddToBag.isEnabled = true
        }
        
        
        var itemOptions = [String]()
        var itemOptionsString = item.itemOptions
        itemOptions = (itemOptionsString?.components(separatedBy: ","))!
        var trimmedItemOptions = [String]()
        for str in itemOptions
        {
            let trimmedStr  =  str.trimmingCharacters(in: CharacterSet.whitespaces)
            trimmedItemOptions.append(trimmedStr)
        }
        
        itemOptionsString = itemOptions.joined(separator: "\n")
        
        cell.productDescriptionLble.text =  item.itemOptions
        
        cell.itemNameLable.text = item.itemName
        cell.priceLable.text = item.price
        
        cell.designerNameLable.text = item.designerName
        
        cell.productImageView.image = ClothingItemImageView.imageForImageUrl(url: item.itemImageURL)
        
        cell.productDescriptionLble.font = UIFont(name: "HelveticaNeue", size: self.descriptionLabelFontSize)
        
        switch (Constants.deviceIdiom)
        {
            
        case .pad:
            
            cell.vzImageTopConstaint.constant = 50
            cell.topHalfView.layoutIfNeeded()
            
            cell.checkoutBtn_H_Constraint.constant = 50
            
            cell.customViewTopContrainT.constant = 100
            cell.bottomHalfView.layoutIfNeeded()
            
            
            
        default: break
            
            ///print("Unspecified UI idiom")
            
        }

        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        
        
//        _ = CATransform3DIdentity;
//        cell.contentView.alpha = 0.8;
//        
//        let scaleTransform = CATransform3DScale(CATransform3DIdentity, 0.8, 0.8, 1)
//        
//        cell.layer.transform = scaleTransform;
//        
//        cell.layer.cornerRadius = 20.0 * 0.8
//        
//        UIView.animateWithDuration(0.4, animations: {
//            
//            cell.layer.transform = CATransform3DIdentity;
//            cell.contentView.alpha = 1;
//            
//            cell.layer.cornerRadius = 20.0
//            
//            
//        }) { (finished) in
//            
//            
//        }
        
    }
    
    func handleScrollViewScrolling()
    {
        let cells = itemsCollectionView.visibleCells
        
        let MIN_SCALE = CGFloat(0.9)
        
        let center = itemsCollectionView.center
        
        for cell in cells
        {
            let absoluteCellCenter = itemsCollectionView.convert(cell.center, to: self.view)
            let cellCenterOffset = abs(center.x - absoluteCellCenter.x)
            
            let scaleApplicable =  1 - (((1 - MIN_SCALE) / cell.bounds.size.width) * cellCenterOffset)
            
            let scaleTransform = CATransform3DScale(CATransform3DIdentity, scaleApplicable, scaleApplicable, 1)
            
            cell.layer.transform = scaleTransform;
            cell.layer.cornerRadius = 20.0 * scaleApplicable
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        // let scrollVelocity = scrollView.panGestureRecognizer.velocityInView(self.view)
        // ///print("scrollvelocity x= \(scrollVelocity.x) y= \(scrollVelocity.y)")
        
        self.handleScrollViewScrolling()
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        self.scrollAnimate(scrollView)
        
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        
        if decelerate == false
        {
            self.scrollAnimate(scrollView)
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        
        
        //        let cells = self.itemsCollectionView.visibleCells()
        //
        //        for cell in cells
        //        {
        //            var rotationAndPerspectiveTransform = CATransform3DIdentity;
        //            rotationAndPerspectiveTransform.m34 = 1.0 / -500;
        //            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, (30.0 * CGFloat(M_PI)) / 180.0, 0.0, 1.0, 0.0);
        //            cell.contentView.alpha = 0.8;
        //            cell.contentView.layer.transform = rotationAndPerspectiveTransform;
        //
        //            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
        //
        //                cell.contentView.layer.transform = CATransform3DIdentity;
        //                cell.contentView.alpha = 1;
        //
        //            }) { (finished) in
        //
        //            }
        //        }
        
        
    }
    
    func scrollAnimate(_ scrollView : UIScrollView!)
    {
        var visibleRect = CGRect()
        visibleRect.origin = scrollView.contentOffset
        visibleRect.size = scrollView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        var destinationIndexPath : IndexPath!
        if let vIndexPath =  itemsCollectionView.indexPathForItem(at: visiblePoint)
        {
            destinationIndexPath = IndexPath(item: vIndexPath.row, section: 0)
            currentItemIndex = destinationIndexPath.row
            self.itemsCollectionView.scrollToItem(at: destinationIndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        }
        else
        {
            let cells = itemsCollectionView.visibleCells
            var closerToMiddleCell : UICollectionViewCell? = nil
            for cell in cells
            {
                if closerToMiddleCell == nil
                {
                    closerToMiddleCell = cell
                }
                else
                {
                    let center = itemsCollectionView.center
                    let absoluteCellCenter = itemsCollectionView.convert(cell.center, to: self.view)
                    let closerToMiddleCellCenter = itemsCollectionView.convert(closerToMiddleCell!.center, to: self.view)

                    
                    let cellCenterOffset = abs(center.x - absoluteCellCenter.x)
                    let closerToMiddleCellCenterOffset = abs(center.x - closerToMiddleCellCenter.x)
                    if cellCenterOffset <= closerToMiddleCellCenterOffset
                    {
                        closerToMiddleCell = cell
                    }
                    
                }
                
            }
            let destinationIndexPath = self.itemsCollectionView.indexPath(for: closerToMiddleCell!)

            self.itemsCollectionView.scrollToItem(at: destinationIndexPath!, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            
        }
    }
    
    
    
    // MARK: - ItemDetailCollectionViewCell Delegate methods
    
    
    func itemDetailCell(_ cell: ItemDetailCollectionViewCell!, addToBagTappedForItemAtIndex index: Int)
    {
        let sizeArrayIndex = Int(cell.customView.selectedIndex)
        
        if sizeArrayIndex >= 0
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
            itemCopy.sizeSelected = item.itemSizes[sizeArrayIndex]
            itemCopy.itemSizes = item.itemSizes
            
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
        
        
        
        let cartCount = FACart.sharedCart().getCartCount()
        var btnTitleStr = "(\(FACart.sharedCart().getCartCount())) ADD TO BAG"
        if cartCount == 0
        {
            btnTitleStr = "ADD TO BAG"
        }
        
        let cartItemsCountDict: [String: Any] = ["cartItemsCount": cartCount, "Notif": "Notif"]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kItemsPresentInCartNotification), object: nil, userInfo: cartItemsCountDict)
        
        cell.buttonAddToBag.setTitle(btnTitleStr, for: UIControlState())
        
        
        let visibleCells = itemsCollectionView.visibleCells as! [ItemDetailCollectionViewCell]
        
        for cell in visibleCells
        {
            cell.buttonAddToBag.setTitle(btnTitleStr, for: UIControlState())
        }
        
        
        cell.messageLabel.alpha = 0
        
        cell.messageLabel.text = "This item has been added to your bag"
        UIView.animate(withDuration: 0.3, animations: {
            cell.messageLabel.alpha = 1
            
            
        }, completion: { (finished) in
            
            UIView.animate(withDuration: 0.3, delay: 1, options: UIViewAnimationOptions.curveLinear, animations: {
                cell.messageLabel.alpha = 0
                
                }, completion: { (finished) in
                    
            })
            
            
            
        }) 
        
        
        
    }
    
    func itemDetailCell(_ cell: ItemDetailCollectionViewCell!, checkOutTappedForItemAtIndex index: Int)
    {
        currentItemIndex = index
        
        let indexPath = IndexPath(item: currentItemIndex!, section: 0)
        let visibleCells  =  self.itemsCollectionView.visibleCells
        
        ///print("visibleCells count \(visibleCells.count)")
        
        var selectedCell : ItemDetailCollectionViewCell!
        for visibleCell in visibleCells
        {
            if self.itemsCollectionView.indexPath(for: visibleCell) == indexPath
            {
                selectedCell = visibleCell as! ItemDetailCollectionViewCell
            }
        }
        
        
        let cellRect = selectedCell.convert(selectedCell.bounds, to: self.view)
        
        
        
        self.itemsDetailAnimationView.leadingConstraint.constant = cellRect.origin.x
        self.itemsDetailAnimationView.topConstraint.constant = cellRect.origin.y
        self.itemsDetailAnimationView.widthConstraint.constant = cellRect.size.width
        self.itemsDetailAnimationView.heightConstraint.constant = cellRect.size.height
        
        self.view.layoutIfNeeded()
        
        let cellCenter = CGPoint(x: selectedCell.bounds.width / 2.0, y: selectedCell.bounds.height / 2.0)
        
        
        let addToBagRect = selectedCell.buttonAddToBag.frame
        let checkoutRect = selectedCell.wardrobeBtn.frame
        
        let buttonCheckoutCenter = selectedCell.wardrobeBtn.center
        let buttonAddToBagCenter = selectedCell.buttonAddToBag.center
        
        self.itemsDetailAnimationView.centerConstraintAddToBag.constant = buttonAddToBagCenter.x - cellCenter.x
        self.itemsDetailAnimationView.bottomConstraintAddToBag.constant = selectedCell.bounds.size.height -  (addToBagRect.origin.y + addToBagRect.size.height)
        self.itemsDetailAnimationView.widthConstraintAddToBag.constant = addToBagRect.size.width
        self.itemsDetailAnimationView.heightConstraintAddToBag.constant = addToBagRect.size.height
        
        
        
        self.itemsDetailAnimationView.centerConstraintCheckout.constant = buttonCheckoutCenter.x - cellCenter.x
        self.itemsDetailAnimationView.bottomConstraintCheckout.constant = selectedCell.bounds.size.height -  (checkoutRect.origin.y + checkoutRect.size.height)
        self.itemsDetailAnimationView.widthConstraintCheckout.constant = checkoutRect.size.width
        self.itemsDetailAnimationView.heightConstraintCheckout.constant = checkoutRect.size.height
        
        
        self.view.layoutIfNeeded()
        
        
        
        self.perform(#selector(ItemsDetailVC.captureComponentsFromCellAndAnimate(_:)), with: cell, afterDelay: 0.1)
        
        ////  self.performSelector(#selector(ItemsDetailVC.animateInShoppingCart), withObject: nil, afterDelay: 0.4)
        
        
        
    }
    
    func itemDetailCell(_ cell: ItemDetailCollectionViewCell!, sizeButtonTappedForShoeItemAtIndex shoeItemIndex: Int, atSizeArrayIndex sizeArrayIndex: Int)
    {
        
        ///print("sizeButtonTappedForShoeItemAtIndex \(shoeItemIndex)  at index \(sizeArrayIndex)")
        
        
        
        let item = selectedItems[shoeItemIndex]
        item.sizeSelected = item.itemSizes[sizeArrayIndex]
        
        
        if item.sizeSelected == nil
        {
            cell.buttonAddToBag.alpha = 0.5
            cell.buttonAddToBag.isEnabled = false
        }
        else
        {
            cell.buttonAddToBag.alpha = 1
            cell.buttonAddToBag.isEnabled = true
        }
        
        
        if item.itemSizes[sizeArrayIndex].itemAvailability <= 3
        {
            cell.messageLabel.alpha = 0
            
            cell.messageLabel.text = "Only \(item.itemSizes[sizeArrayIndex].itemAvailability) left!"
            
            self.itemsCollectionView.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.3, animations: {
                
                cell.messageLabel.alpha = 1
                
                }, completion: { (finished) in
                    
                    UIView.animate(withDuration: 0.3, delay: 0.3, options: UIViewAnimationOptions.curveEaseIn, animations: {
                        
                        cell.messageLabel.alpha = 0
                        
                        
                        }, completion: { (finished) in
                            
                            self.itemsCollectionView.isUserInteractionEnabled = true
                            
                            
                    })
            })
            
            
        }
        
        
    }
    
    func itemDetailCell(_ cell: ItemDetailCollectionViewCell!, sizeButton : UIButton, tappedForItemAtIndex index: Int)
    {
        
        let tag = sizeButton.tag
        
        cell.messageLabel.alpha = 0
        
        switch tag {
            
        case 4:
            cell.messageLabel.text = "Only 2 left!"
            
        case 8:
            cell.messageLabel.text = "Only 3 left"
        default:
            cell.messageLabel.text = ""
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            cell.messageLabel.alpha = 1
            
            sizeButton.backgroundColor = UIColor.black
            sizeButton.setTitleColor(UIColor.white, for: UIControlState())
            
            for view in (sizeButton.superview?.superview?.subviews)!
            {
                let subviews = view.subviews as! [UIButton]
                let button = subviews[0]
                
                if button != sizeButton
                {
                    button.backgroundColor = UIColor.white
                    button.setTitleColor(UIColor.black, for: UIControlState())
                }
            }
            
            
        }, completion: { (finished) in
            
            UIView.animate(withDuration: 0.3, delay: 1, options: UIViewAnimationOptions.curveLinear, animations: {
                cell.messageLabel.alpha = 0
                
                }, completion: { (finished) in
                    
            })
            
        }) 
        
        
    }
    
    func itemDetailCell(_ cell: ItemDetailCollectionViewCell!, wardrobeTappedForItemAtIndex index: Int)
    {
        
        cell.wardrobeBtn.isSelected = !cell.wardrobeBtn.isSelected
        
        if cell.wardrobeBtn.isSelected == true
        {
            cell.wardrobeBtn.backgroundColor = Constants.wardrobeButtonSelectedColor
        }
        else
        {
            cell.wardrobeBtn.backgroundColor = UIColor.white
        }
        
        
        self.delegate.itemsDetailVC(self, wardrobeTappedForItem: selectedItems[index], toAdd: cell.wardrobeBtn.isSelected)
        
    }
    
    func itemDetailCellNeedsLogin(_ cell: ItemDetailCollectionViewCell!)
    {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kUserNotSignedInFromItemDetailVC), object: nil, userInfo: nil)
    }
    
    func shareBtnTapped(sender : Any)
    {
        
        ////We Need to pass model information like Designer Name ETC
        let modelItemInfo =  String(format: "%@ %@ %@ \n\n", "Fashion180","Sharing","ModelImage");
        
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let modelSharedImage:UIImage
        
        modelSharedImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        switch (Constants.deviceIdiom)
        {
            
        case .pad:
            
            let activityViewController = UIActivityViewController(activityItems: [modelItemInfo,modelSharedImage], applicationActivities: nil)
            
            let sourceView = sender as! UIView
            
            activityViewController.popoverPresentationController?.sourceView = sourceView
            activityViewController.popoverPresentationController?.sourceRect = sourceView.bounds
            
            self.present(activityViewController, animated: true, completion: nil)
            
        case .phone:
            
            let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [modelItemInfo,modelSharedImage], applicationActivities: nil)
            
            self.present(activityViewController, animated: true, completion: nil)
            
            activityViewController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                
                // Return if cancelled
                if (!completed)
                {
                    ///print("user clicked cancel")
                    return
                }
                else
                {
                   // completed
                }
            }
            
        default: break
            ///print("Unspecified UI idiom")
            
        }

    }
    
    func itemDetailCell(_ cell: ItemDetailCollectionViewCell!, checkoutSelected: Bool)
    {
        
        var checkoutState = "0"
        if checkoutSelected == true
        {
            checkoutState = "1"
        }
        else
        {
            checkoutState = "0"
            
        }
        
        let selectedIndexPath = self.itemsCollectionView.indexPath(for: cell)
        
        let currentItemSelectedForInfoView = selectedItems[selectedIndexPath!.row]
        
        let custID = CommonHelper.getCustomerID()
        
        let url = String(format: "%@/%@", arguments: [Wardrober.shared().serviceMainUrl!,Urls.AddWardrobeinfo]);
        
        let requestDict = WardrobeHelper.getRequestDictForAddToWardrobeService(custID, ProductItemID: (currentItemSelectedForInfoView.itemProductID)!, AddOrRemove: checkoutState)
        
        FAServiceHelper().post(url: url, parameters: requestDict as NSDictionary  , completion : { (success : Bool?, message : String?, responseObject : AnyObject?) in
            
            guard success == true else
            {
                currentItemSelectedForInfoView.isAddedToWardrobe = false
                
                return
            }
            
            guard responseObject == nil else
            {
                let (success, errorMsg) = WardrobeHelper.parseAddToWardrobeResponse(responseObject as AnyObject?)
                
                if success == true
                {
                    currentItemSelectedForInfoView.isAddedToWardrobe = true
                }
                else
                {
                    ///print("add to Wishlist failed : \(errorMsg)")
                    currentItemSelectedForInfoView.isAddedToWardrobe = false
                }
                
                return
            }
            
        })
        
    }
    
    
    @objc func captureComponentsFromCellAndAnimate(_ cell : ItemDetailCollectionViewCell!)
    {
        var image = UIImage(view: cell.topHalfView)
        self.itemsDetailAnimationView.topHalfImageView.image = image
        
        image = UIImage(view: cell.bottomHalfView)
        self.itemsDetailAnimationView.bottomHalfImageView.image = image
        
        image = UIImage(view: cell.buttonAddToBag)
        self.itemsDetailAnimationView.AddToBagImageView.image = image
        
        image = UIImage(view: cell.buttonCheckout)
        self.itemsDetailAnimationView.checkoutImageView.image = image
        
        
        
        self.itemsDetailAnimationView.isHidden = false
        
        
        self.itemsDetailAnimationView.AddToBagImageView.clipsToBounds = true
        self.itemsDetailAnimationView.checkoutImageView.clipsToBounds = true
        
        ///print("animationview frame = \(self.itemsDetailAnimationView.frame)")
        
        ///print("checkout button frame = \(self.itemsDetailAnimationView.checkoutImageView.frame)")
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
            
            self.itemsDetailAnimationView.topConstraint.constant = 0
            self.itemsDetailAnimationView.leadingConstraint.constant = 0
            self.itemsDetailAnimationView.widthConstraint.constant = self.view.bounds.size.width
            self.itemsDetailAnimationView.heightConstraint.constant = self.view.bounds.size.height
            
            self.view.layoutIfNeeded()
            
        }) { (finished) in
            
            
            
        }
        
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIViewAnimationOptions.curveEaseIn, animations:
            {
                
                self.itemsDetailAnimationView.topHalfImageView.alpha = 0.1
                self.itemsDetailAnimationView.bottomHalfImageView.alpha = 0.1
                
                
                
                self.itemsDetailAnimationView.topConstraintTopHalfView.constant = -self.itemsDetailAnimationView.topHalfImageView.bounds.size.height - 200
                
                self.itemsDetailAnimationView.bottomConstraintBottomHalfView.constant = self.itemsDetailAnimationView.bottomHalfImageView.bounds.size.height + 200
                
                
                self.itemsDetailAnimationView.centerConstraintAddToBag.constant = 0
                self.itemsDetailAnimationView.centerConstraintCheckout.constant = 0
                
                
                self.itemsDetailAnimationView.topHalfImageView.alpha = 0.2
                self.itemsDetailAnimationView.bottomHalfImageView.alpha = 0.2
                
                self.itemsDetailAnimationView.layoutIfNeeded()
                
        }) { (finished) in
            
            
            self.itemsDetailAnimationView.isHidden = true
            
            self.itemsDetailAnimationView.topHalfImageView.alpha = 1
            self.itemsDetailAnimationView.bottomHalfImageView.alpha = 1
            self.itemsDetailAnimationView.topConstraintTopHalfView.constant = 0
            self.itemsDetailAnimationView.bottomConstraintBottomHalfView.constant = 0
            
            self.itemsDetailAnimationView.layoutIfNeeded()
            
        }
        
        self.perform(#selector(ItemsDetailVC.animateInShoppingCart), with: nil, afterDelay: 0.4)
        
    }
    
    
    @objc func animateInShoppingCart()
    {
        
        var checkoutBtnPreAnimValues = [String : CGFloat]()
        checkoutBtnPreAnimValues["leading"] = self.itemsDetailAnimationView.checkoutImageView.frame.origin.x
        checkoutBtnPreAnimValues["trailing"] = self.itemsDetailAnimationView.bounds.size.width - ( self.itemsDetailAnimationView.checkoutImageView.frame.origin.x + self.itemsDetailAnimationView.checkoutImageView.frame.size.width)
        checkoutBtnPreAnimValues["bottom"] = self.itemsDetailAnimationView.bottomConstraintCheckout.constant
        checkoutBtnPreAnimValues["height"] = self.itemsDetailAnimationView.checkoutImageView.frame.size.height
        
        self.shoppingCartController.checkoutBtnPreAnimationValues = checkoutBtnPreAnimValues
        self.shoppingCartController.delegate = self
        self.shoppingCartController.view.isHidden = false
        self.shoppingCartController.animateCheckoutButton()
    }
    
    
    // MARK: - Collection View Delegate Flow Layout methods
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let edgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        return edgeInsets
    }
    
    

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func showAlertView(_ AlertTitle: NSString, AlertMessage:NSString, AlertButtonTitle:NSString)
    {
        
        let alert=UIAlertController(title: AlertTitle as String, message: AlertMessage as String, preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: AlertButtonTitle as String, style: UIAlertActionStyle.cancel, handler: nil));
        self.present(alert, animated: true, completion: nil)
    }
    
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}





extension UIImage
{
    convenience init(view: UIView)
    {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}

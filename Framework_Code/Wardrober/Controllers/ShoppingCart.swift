//
//  ShoppingCart.swift
//  Fashion180
//
//  Created by Srinivas Peddinti on 10/13/16.
//  Copyright © 2016 MobiwareInc. All rights reserved.
//

import UIKit

protocol ShoppingCartDelegate
{
    func shoppingCartDidTapBackButton(_ shoppingCart : ShoppingCart!)
}

class ShoppingCart: UIViewController, CheckoutCellDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate
{

    @IBOutlet weak var checkoutBtn : UIButton!
    
    @IBOutlet weak var backBtn : UIButton!
    
    @IBOutlet weak  var userAccountBtn : UIButton!
    
    @IBOutlet weak var cartBtn : UIButton!
    
    @IBOutlet weak var checkoutBottomView : UIView!
    
    @IBOutlet weak var cartItemsListTableView : UITableView!
    
    
    var totalItemsListArray:NSMutableArray! = NSMutableArray()

    //  vertical align contraint
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!

    let cartTableviewCell : CheckoutCell! = nil
    
    @IBOutlet weak var emptyCartView : UIView!
    
    @IBOutlet weak var orderTotolLble : UILabel!

    @IBOutlet weak var totolCostLble : UILabel!

    @IBOutlet weak var shippingEstLble : UILabel!

    var totolCostOfCheckOutItemsList : Int!

    var shoppingEstimateValue : Int!
    
    var selectedIndexSizeBtn = 1000
    var selectedIndexAtInnerCollectionView = 1000
    var sizeValue : String?
    
    var checkoutBtnPreAnimationValues : [String : CGFloat]!
    @IBOutlet var bottomConstraintFinalCheckoutBtn : NSLayoutConstraint!
    @IBOutlet var leadingConstraintFinalCheckoutBtn : NSLayoutConstraint!
    @IBOutlet var trailingConstraintFinalCheckoutBtn : NSLayoutConstraint!
    @IBOutlet var heightConstraintFinalCheckoutBtn : NSLayoutConstraint!
    var delegate : ShoppingCartDelegate!
    
    @IBOutlet var bottomConstraintBottomCheckoutView : NSLayoutConstraint!
    @IBOutlet var heightConstraintBottomCheckoutView : NSLayoutConstraint!

    @IBOutlet var topConstraintNavBar : NSLayoutConstraint!

    //var myView : UIView! = nil
    
    //var selectedSizesArray : [String]!
    var isSelectionDone : Bool! = false
    let sizeBtnColor = UIColor(red: CGFloat(111)/CGFloat(255), green: CGFloat(113)/CGFloat(255), blue: CGFloat(121)/CGFloat(255), alpha: 1)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.emptyCartView.isHidden = true
        
        self.totolCostOfCheckOutItemsList = 0
        self.shoppingEstimateValue = 10
        
        
        checkoutBtn.layer.masksToBounds = true
        checkoutBtn.layer.cornerRadius = 20.0

       //Naveen
       var titleStr : String!
        
       titleStr = NSString(format: "CHECKOUT (%d)",FACart.sharedCart().getCartCount()) as String
       
       checkoutBtn.setTitle(titleStr, for: UIControlState())
        
       let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.tapEdit(_:)))
       cartItemsListTableView.addGestureRecognizer(tapRecogniser)
       tapRecogniser.delegate = self
       tapRecogniser.cancelsTouchesInView = false

       /*NotificationCenter.default.addObserver(self, selector: #selector(ShoppingCart.selectedAddressSuccessful(_:)), name: NSNotification.Name(rawValue: Constants.kAddressSelectedSuccessNotification), object: nil)*/
        
        NotificationCenter.default.addObserver(self, selector: #selector(ShoppingCart.soldOutAlert), name: NSNotification.Name(rawValue: "SoldoutAlert"), object: nil)

        
    }
    
    @objc func soldOutAlert()
    {
        self.showAlertView("Error", AlertMessage: "Sold Out", AlertButtonTitle: "OK")
    }
    
    /*@objc func selectedAddressSuccessful(_ notification : Notification)
    {
        if let dict = notification.userInfo as! [String : Any]!
        {
            let deliveryAddress = dict["selectedDeliveryAddress"]
        }
    }*/
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //selectedSizesArray = Array(repeating: "a", count: FACart.sharedCart().getCartCount())
        //print("selectedSizesArray in viewWillAppear:\(selectedSizesArray)")
        
        if self.navigationController != nil
        {
            self.topConstraintNavBar.constant = -60

            //presented from Model VC using navigationController
            var checkoutBtnPreAnimValues = [String : CGFloat]()
            checkoutBtnPreAnimValues["leading"] = 100
            checkoutBtnPreAnimValues["trailing"] = 100
            checkoutBtnPreAnimValues["bottom"] = 30
            checkoutBtnPreAnimValues["height"] = 50
            
            self.checkoutBtnPreAnimationValues = checkoutBtnPreAnimValues

            self.animateCheckoutButton()
        }
        else
        {
            self.topConstraintNavBar.constant = 0
            self.calculateShoppingCartItems()
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        
    }
    
    @IBAction func backButtonTapped(_ sender : UIButton!)
    {
        self.delegate.shoppingCartDidTapBackButton(self)
    }
    
    func animateCheckoutButton()
    {
        
        if FACart.sharedCart().getCartCount() > 0
        {
            self.emptyCartView.isHidden = true
            self.cartItemsListTableView.isHidden = false
            self.calculateShoppingCartItems()
            
        }
        else
        {
            self.emptyCartView.isHidden = false
            self.cartItemsListTableView.isHidden = true
        }
        
        self.cartItemsListTableView.reloadData()
        
        
        self.bottomConstraintBottomCheckoutView.constant = self.heightConstraintBottomCheckoutView.constant
        
        
        if FACart.sharedCart().getCartCount() > 0
        {
            self.checkoutBtn.alpha = 0.2

        }
        else
        {
            self.checkoutBtn.alpha = 0

        }
        
        self.leadingConstraintFinalCheckoutBtn.constant = checkoutBtnPreAnimationValues["leading"]!
        self.trailingConstraintFinalCheckoutBtn.constant = checkoutBtnPreAnimationValues["trailing"]!
        self.bottomConstraintFinalCheckoutBtn.constant = checkoutBtnPreAnimationValues["bottom"]!
        self.heightConstraintFinalCheckoutBtn.constant = checkoutBtnPreAnimationValues["height"]!
        self.view.layoutIfNeeded()
        
        
        self.view.bringSubview(toFront: self.checkoutBtn)

        let duration : TimeInterval = 1
        
        
        UIView.animate(withDuration: duration * Double((50.0 / 100.0)), delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            if FACart.sharedCart().getCartCount() > 0
            {
                self.bottomConstraintBottomCheckoutView.constant = 0

            }
            
            self.view.layoutIfNeeded()
            
        }) { (finished) in
            
        }
        
        UIView.animate(withDuration: duration, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: {
        
            if FACart.sharedCart().getCartCount() > 0
            {
                self.checkoutBtn.alpha = 1
            }
      
            self.leadingConstraintFinalCheckoutBtn.constant = 38
            self.trailingConstraintFinalCheckoutBtn.constant = 38
            self.bottomConstraintFinalCheckoutBtn.constant = 23
            self.heightConstraintFinalCheckoutBtn.constant = 50
            
            self.view.layoutIfNeeded()
            
            
            }, completion: { (finished) in
                
                if FACart.sharedCart().getCartCount() == 0
                {
                    self.checkOutViewAnimatingToBottom()
                    self.showEmptyCartWithAnimation()

                }
        })
        
        let durationPerCell = duration * Double((50.0 / 100.0)) / Double(self.cartItemsListTableView.visibleCells.count)
        let delay = duration / Double(4)
        let i = Double(0)
        for cell in self.cartItemsListTableView.visibleCells as! [CheckoutCell]
        {
            cell.itemDeletedView.isHidden = true
            
            cell.separatorViewLeadingConstraint.constant = cell.bounds.size.width
            cell.separatorViewTrailingConstraint.constant = cell.bounds.size.width
            
            cell.itemInfoViewLeadingConstraint.constant =  -cell.bounds.size.width
            cell.itemInfoViewTrailingConstraint.constant = -cell.bounds.size.width
            cell.layoutIfNeeded()
            
            UIView.animate(withDuration: durationPerCell, delay: i * delay, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                cell.separatorViewLeadingConstraint.constant = 16
                cell.separatorViewTrailingConstraint.constant = 0
                
                cell.itemInfoViewLeadingConstraint.constant =  0
                cell.itemInfoViewTrailingConstraint.constant = 0
                
                cell.layoutIfNeeded()
                
                }, completion: { (finished) in
                    
                    cell.itemDeletedView.isHidden = false
            })
            
        }
    }
    
    func loadCartlistTableViewWithAnimation()
    {
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.fillMode = kCAFillModeForwards
        transition.duration = 1.0
        transition.subtype = kCATransitionFromLeft
        self.cartItemsListTableView.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
    }
    
    
    func checkOutViewAnimatingToBottom()
    {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1,
        initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                                    
           self.bottomConstraintBottomCheckoutView.constant = self.checkoutBottomView.bounds.size.height
                                    
        }, completion: nil)
    }
    
    func showEmptyCartWithAnimation()
    {
        self.emptyCartView.isHidden=false
        self.cartItemsListTableView.isHidden = true
        self.emptyCartView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1,
        initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                                    
            self.emptyCartView.alpha = 1
            self.checkoutBtn.alpha = 0
            
        }, completion: nil)
    }
    
    
    func removeCartItem(_ sender:AnyObject)
    {
            let rowSelected = sender.tag
            let selectedIndexPath = IndexPath(row: rowSelected!, section: 0)
        
            if let cell = self.cartItemsListTableView.cellForRow(at: selectedIndexPath) as? CheckoutCell
            {
                
                cell.isUserInteractionEnabled = false
                
                
                cell.itemDeletedView.alpha = 0
                cell.itemDeletedViewLeadingConstraint.constant = 0
                cell.itemDeletedViewTrailingConstraint.constant = 0
                cell.layoutIfNeeded()
                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    
                    cell.itemDeletedView.alpha = 1
                    cell.itemInfoViewLeadingConstraint.constant = -cell.bounds.size.width
                    cell.itemInfoViewTrailingConstraint.constant = cell.bounds.size.width
                    cell.layoutIfNeeded()
                    }, completion: { (finished) in
                        
                        let timeInSeconds = 0.5
                        let timeInMilliseconds : UInt64 = UInt64(timeInSeconds * 1000)
                        let time = DispatchTime.now() + Double(Int64(NSEC_PER_MSEC * timeInMilliseconds)) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: time) {
                            
                            
                            self.cartItemsListTableView.beginUpdates()
                            
                            if selectedIndexPath.row < FACart.sharedCart().getCartCount()
                            {
                                FACart.sharedCart().removeCartItem(FACart.sharedCart().getCartItems()[selectedIndexPath.row])
                                
                                self.cartItemsListTableView.deleteRows(at: [selectedIndexPath], with: .top)
                            }
                            
                            
                            self.cartItemsListTableView.endUpdates()
                            
                            var totoalItemsCost : Float = 0
                            
                            
                            for item in FACart.sharedCart().getCartItems()
                            {
                                var price = item.price
                                price = price?.trimmingCharacters(in: CharacterSet(charactersIn: "$"))
                                let newnumberStr:Float = ceil(Float(price!)!)
                                totoalItemsCost += newnumberStr
                            }
                            
                            
                            self.totolCostLble.text = NSString(format: "$%.2f",floor(totoalItemsCost)) as String
                            self.orderTotolLble.text = NSString(format: "$%.2f",floor(totoalItemsCost+10)) as String
                            
                            
                            //Naveen
                        
                            var titleStr : String!
                           
                            titleStr = NSString(format: "CHECKOUT (%d)",FACart.sharedCart().getCartCount()) as String
                            
                            self.checkoutBtn.setTitle(titleStr, for: UIControlState())
                            
                            let cartItemsCountDict: [String: Any] = ["cartItemsCount": FACart.sharedCart().getCartCount(), "Notif": "Notif"]
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kItemsPresentInCartNotification), object: nil, userInfo: cartItemsCountDict)
                            
                            if FACart.sharedCart().getCartCount() == 0
                            {
                                self.checkOutViewAnimatingToBottom()
                                self.showEmptyCartWithAnimation()
                            }
                            
                            cell.isUserInteractionEnabled = true
                            
                        }
                })
                
            }
    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
       return FACart.sharedCart().getCartCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       return 160
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "CheckOutidentifier"
        
        //let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CheckoutCell!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CheckoutCell
        
        cell.sizeBtn.alpha = 1
        cell.innerBGView.alpha = 0

        cell.sizeBtn.tag = indexPath.row
        cell.innerBGView.tag = indexPath.row
        cell.innerBGView.sizesCollectioViewInInnerView.tag = indexPath.row
        
        cell.itemDeletedView.alpha = 0
        cell.itemInfoViewLeadingConstraint.constant = 0
        cell.itemInfoViewTrailingConstraint.constant = 0
        cell.layoutIfNeeded()
        
        let item = FACart.sharedCart().getCartItems()[indexPath.row]
        
        cell.itemImageView?.image = ClothingItemImageView.imageForImageUrl(url:item.itemImageURL)
        cell.designerNameLble?.text = item.designerName
        cell.itemNameLble?.text = item.itemName
        cell.priceLble?.text = item.price
        cell.itemInfoView.tag = indexPath.row + 100
        cell.itemDeletedView.tag = indexPath.row + 200
        
        cell.delegate = self
        cell.removeBtn.isEnabled = true
        
        cell.innerBGView.selectedIndexOfInnerCollectionView = item
        if item.sizeSelected != nil
        {
            cell.innerBGView.itemSizes = item.itemSizes
            
            cell.sizeBtn.setTitle(item.sizeSelected?.itemSizeName, for: UIControlState.normal)
            cell.sizeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 8)
            cell.sizeBtn.backgroundColor = Constants.dotSelectedColor
            cell.sizeLble?.text = "SELECTED SIZE"
        }
            
        else
        {
            if item.isSizesDownloaded == true
            {
                if item.itemSizes.count > 0
                {
                    cell.innerBGView.itemSizes = item.itemSizes
                    //item.itemSizes[0].itemAvailability = 0
                    if item.itemSizes[0].itemAvailability == 0
                    {
                        cell.sizeBtn.setTitle("+", for: UIControlState())
                        cell.sizeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                        cell.sizeBtn.backgroundColor = UIColor.gray
                        cell.sizeLble?.text = "SIZE NOT AVAILABLE"
                    }
                    else
                    {
                        item.sizeSelected = item.itemSizes[0]
                        
                        cell.sizeBtn.setTitle(item.sizeSelected?.itemSizeName, for: UIControlState.normal)
                        cell.sizeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 8)
                        cell.sizeBtn.backgroundColor = Constants.dotSelectedColor
                        cell.sizeLble?.text = "SELECTED SIZE"
                    }
                }
            }
            else
            {
                if item.isSizesDownloading == false
                {
                    self.loadItemSizesForItem(item)
                }
            }
            
        }
       
        
        //Button click
        if selectedIndexSizeBtn == indexPath.row
            
        {
            cell.sizeBtn.alpha = 0
            cell.innerBGView.alpha = 1
            selectedIndexSizeBtn = 1000
            cell.innerBGView.itemSizes = item.itemSizes
            
            if item.itemSizes.count == 1
            {
                cell.sizeLble?.text = "NO OTHER SIZES AVIAILABLE"
            }
            else
            {
                cell.sizeLble?.text = "CHOOSE DIFFERENT SIZE"
            }

            
        }
        
        //Specific Cell click
        if selectedIndexAtInnerCollectionView == indexPath.row
        {
            cell.sizeBtn.alpha = 1
            cell.innerBGView.alpha = 0
            cell.sizeLble?.text = "SELECTED SIZE"
            selectedIndexAtInnerCollectionView = 1000
        }

        let sizesCollectionView = cell.innerBGView.sizesCollectioViewInInnerView
        sizesCollectionView?.reloadData()
        cell.innerBGView.layoutIfNeeded()
        
        return cell
    }
    
    @objc func tapEdit(_ recognizer: UITapGestureRecognizer)
    {
        if recognizer.state == UIGestureRecognizerState.ended
        {
            let tapLocation = recognizer.location(in: self.cartItemsListTableView)
            
            if let tapIndexPath = self.cartItemsListTableView.indexPathForRow(at: tapLocation)
            {
                if let tappedCell = self.cartItemsListTableView.cellForRow(at: tapIndexPath) as? CheckoutCell
                {
                    tappedCell.sizeBtn.alpha = 1
                    tappedCell.innerBGView.alpha = 0
                    tappedCell.sizeLble?.text = "SELECTED SIZE"
                    
                }
            }
        }
    }
    
    
    /*func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isDescendant(of: UICollectionViewCell()))!
        {
            return false
        }
        
        return true
    }*/

    
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
                ///print("Response of SubCollectionview\(responseObject)")
                
                let sizesArray =  ItemSizeHelper.productItemParsing(responseObject! as AnyObject?)
                ///print("sizesArray of SubCollectionview\(sizesArray)")
                shoeItem.itemSizes = sizesArray
                shoeItem.isSizesDownloaded = true
                shoeItem.isSizesDownloading = false
                
                self.cartItemsListTableView.reloadData()
                
                
                return
            }
            
        })
        
    }

    
    func tableView(_ tableView:UITableView, didSelectRowAt indexPath:IndexPath)
    {
        
        
    }

    
    func calculateShoppingCartItems()
    {
        //Naveen
        var titleStr : String!
        
        titleStr = NSString(format: "CHECKOUT (%d)",FACart.sharedCart().getCartCount()) as String
        
        self.checkoutBtn.setTitle(titleStr, for: UIControlState())
        
        var totoalItemsCost : Float = 0
        
        for item in FACart.sharedCart().getCartItems()
        {
            var price = item.price
            price = price?.trimmingCharacters(in: CharacterSet(charactersIn: "$"))
            let newnumberStr:Float = ceil(Float(price!)!)
            totoalItemsCost += newnumberStr
        }
        
        self.totolCostLble.text = NSString(format: "$%.2f",floor(totoalItemsCost)) as String
        self.orderTotolLble.text = NSString(format: "$%.2f",floor(totoalItemsCost+10)) as String
        
        let cartItemsCountDict: [String: Any] = ["cartItemsCount": FACart.sharedCart().getCartCount(), "Notif": "Notif"]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kItemsPresentInCartNotification), object: nil, userInfo: cartItemsCountDict)
    }
    

    func checkoutCellRemoveButtonTapped(_ cell: CheckoutCell)
    {
        
        let selectedIndexPath = self.cartItemsListTableView.indexPath(for: cell)
        
        cell.removeBtn.isEnabled = false
        
        cell.itemDeletedView.alpha = 0
        cell.itemDeletedViewLeadingConstraint.constant = 0
        cell.itemDeletedViewTrailingConstraint.constant = 0
        cell.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            cell.itemDeletedView.alpha = 1
            cell.itemInfoViewLeadingConstraint.constant = -cell.bounds.size.width
            cell.itemInfoViewTrailingConstraint.constant = cell.bounds.size.width
            cell.layoutIfNeeded()
            }, completion: { (finished) in
                
    
                let timeInSeconds = 0.5
                let timeInMilliseconds : UInt64 = UInt64(timeInSeconds * 1000)
                let time = DispatchTime.now() + Double(Int64(NSEC_PER_MSEC * timeInMilliseconds)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time) {
                    
                    
                    self.cartItemsListTableView.beginUpdates()
                    
                    if selectedIndexPath!.row < FACart.sharedCart().getCartCount()
                    {
                        let item = FACart.sharedCart().getCartItems()[selectedIndexPath!.row]
                        FACart.sharedCart().removeCartItem(item)
                        
                        self.cartItemsListTableView.deleteRows(at: [selectedIndexPath!], with: .top)
                        
                        
                        let wrCartItem = WRCartItem()
                        wrCartItem.itemProductID = item.itemProductID
                        wrCartItem.isAddedToWardrobe = item.isAddedToWardrobe
                        wrCartItem.price = item.price
                        wrCartItem.sizeSelected = item.sizeSelected?.itemSizeName
                        
                        
                        if let wrDelegate = Wardrober.shared().delegate
                        {
                            wrDelegate.wardroberRemovedAnItemFromCart?(item: wrCartItem)
                        }
                        
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: WardroberNotifications.ItemRemovedFromCart, object: wrCartItem)
                        }
                        
                    }
                    
                    self.cartItemsListTableView.reloadData()
                    
                    self.cartItemsListTableView.endUpdates()
                    
                    var totoalItemsCost : Float = 0
                    
                    
                    for item in FACart.sharedCart().getCartItems()
                    {
                        var price = item.price
                        price = price?.trimmingCharacters(in: CharacterSet(charactersIn: "$"))
                        let newnumberStr:Float = ceil(Float(price!)!)
                        totoalItemsCost += newnumberStr
                    }
                    
                    
                    self.totolCostLble.text = NSString(format: "$%.2f",floor(totoalItemsCost)) as String
                    self.orderTotolLble.text = NSString(format: "$%.2f",floor(totoalItemsCost+10)) as String
                    
                    
                    //Naveen
                    var titleStr : String!
                    
                    titleStr = NSString(format: "CHECKOUT (%d)",FACart.sharedCart().getCartCount()) as String
                    
                    self.checkoutBtn.setTitle(titleStr, for: UIControlState())
                    
                    
                    let cartItemsCountDict: [String: Any] = ["cartItemsCount": FACart.sharedCart().getCartCount(), "Notif": "Notif"]
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kItemsPresentInCartNotification), object: nil, userInfo: cartItemsCountDict)
                    
                    if FACart.sharedCart().getCartCount() == 0
                    {
                        self.checkOutViewAnimatingToBottom()
                        self.showEmptyCartWithAnimation()
                        
                    }
                    
                    cell.removeBtn.isEnabled = true
                }
                
        })
    }
    
    func checkoutCellSizeButtonTapped(_ value : Int)
    {
        ///print("IndexOf Selected Size Button\(value)")
        
        selectedIndexSizeBtn = value
        
        let indexPath = NSIndexPath(item: selectedIndexSizeBtn, section: 0)
        
        self.cartItemsListTableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        
    }
    
    
    func checkOutCell(cell: CheckoutCell!, sizeButtonTappedForShoeItemAtIndex shoeItemIndex: Int, atValueAtIndex shoeItemValue: Int)
    {
        
        selectedIndexAtInnerCollectionView = shoeItemIndex
        
        let item = FACart.sharedCart().getCartItems()[selectedIndexAtInnerCollectionView]
        item.sizeSelected = item.itemSizes[shoeItemValue]
        
        ///print("IndexOf Selected CollectionView==>\(selectedIndexAtInnerCollectionView)")

        let indexPath = NSIndexPath(item: selectedIndexAtInnerCollectionView, section: 0)
        
        self.cartItemsListTableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        
    }
    
    
    @IBAction func checkoutBtnTapped()
    {
    
        let amount_addressDict : [String: String] = ["Total_Amount": self.orderTotolLble.text!]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kCheckOutBtnTappedNotif), object: nil, userInfo: amount_addressDict)
        
        
        /*var wrCartItems = [WRCartItem]()
        for item in FACart.sharedCart().getCartItems()
        {
            let wrCartItem = WRCartItem()
            wrCartItem.itemProductID = item.itemProductID
            wrCartItem.isAddedToWardrobe = item.isAddedToWardrobe
            wrCartItem.price = item.price
            wrCartItem.sizeSelected = item.sizeSelected?.itemSizeName
            
            wrCartItems.append(wrCartItem)
        }
        
        print ("after prepared cart items")

        if let wrDelegate = Wardrober.shared().delegate
        {
            ///print("calling wardroberCheckoutTappedWithCartItems from Wardrober")
            wrDelegate.wardroberCheckoutTappedWithCartItems?(items: wrCartItems)
        }
        else
        {
            print ("wrDelegate is nil")

        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: WardroberNotifications.CheckoutTapped, object: wrCartItems)
        }
        
        
        Wardrober.exit()*/

    }
    
    func showAlertView(_ AlertTitle: NSString, AlertMessage:NSString, AlertButtonTitle:NSString)
    {
        let alert=UIAlertController(title: AlertTitle as String, message: AlertMessage as String, preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: AlertButtonTitle as String, style: UIAlertActionStyle.cancel, handler: nil));
        self.present(alert, animated: true, completion: nil)
    }
    
   

}

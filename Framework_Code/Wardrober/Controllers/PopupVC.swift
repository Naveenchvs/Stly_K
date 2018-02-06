//
//  PopupVC.swift
//  Fashion180
//
//  Created by Saraschandra on 06/04/17.
//  Copyright © 2017 Mobiware. All rights reserved.
//

import UIKit

protocol PopupVCDelegate
{
    func popupDidTapClose(_ popupVC : PopupVC)
}
class PopupVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ShoppingCartDelegate
{

    @IBOutlet weak var aCollectionView: UICollectionView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var popupView: UIView!
    
    var sizeValue : String?
    
    @IBOutlet var dotView: UIView!
    
    var selectedIndexBtnAtCustomView = 1000
    
    var selectedIndexAtCollectionView = 1000
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet var checkoutBtn: UIButton!
    var delegate : PopupVCDelegate!
    
    var selectedItems : [ShoeItem] = [ShoeItem]()
    
    var shoppingCartController : ShoppingCart!
    var shoppingCartViewLeadingConstraint : NSLayoutConstraint!
    var shoppingCartViewTrailingConstraint : NSLayoutConstraint!
    
    
    var cell : PopupCell!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        aCollectionView.showsHorizontalScrollIndicator = false
        aCollectionView.showsVerticalScrollIndicator = false

        self.dotView.layer.masksToBounds = true
        self.dotView.layer.cornerRadius = dotView.frame.width/2
        self.dotView.backgroundColor = Constants.dotSelectedColor
        
        self.closeBtn.layer.masksToBounds = true
        self.closeBtn.layer.borderWidth = 1.0
        self.closeBtn.layer.borderColor = UIColor.black.cgColor
        self.closeBtn.layer.cornerRadius = closeBtn.frame.width/2
        
        self.popupView.layer.masksToBounds = true
        self.popupView.layer.borderWidth = 1.0
        
        self.popupView.layer.borderColor = Constants.dotSelectedColor.cgColor
        self.popupView.layer.cornerRadius = 20
        
        self.checkoutBtn.layer.masksToBounds = true
        self.checkoutBtn.layer.cornerRadius = 14
        
        self.aCollectionView.delegate = self
        self.aCollectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(PopupVC.btnSelectedCellAtIndexpath(_:)), name:NSNotification.Name(rawValue: "SELECTEDBUTTONATINDEXPATH"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PopupVC.collectionViewSelectedCellAtIndexpath(_:)), name:NSNotification.Name(rawValue: "HIDESIZESCOLLECTIONVIEW"), object: nil)
        
         self.loadShoppingCartView()
        
        
        
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.selectedItems.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        cell = aCollectionView.dequeueReusableCell(withReuseIdentifier: "PopupCollectionViewCell", for: indexPath) as! PopupCell
        
        cell.customView.sizeButton.tag = indexPath.row
        cell.customView.sizesCollectioView.tag = indexPath.row

        let item = selectedItems[indexPath.row]
        
        cell.designerLabel.text = item.designerName
        cell.priceLabel.text = item.price
        cell.itemNameLabel.text = item.itemName
        cell.itemImageView.image = ClothingItemImageView.imageForImageUrl(url:item.itemImageURL)
        
        if selectedIndexBtnAtCustomView == indexPath.item
        {
            cell.customView.sizesCollectioView.alpha = 1
            cell.customView.sizeButton.alpha = 0
            cell.customView.selectOrUnselectLabel.alpha = 0
            selectedIndexBtnAtCustomView = 1000
            
        }
        else
        {
            cell.customView.sizesCollectioView.alpha = 0
            cell.customView.sizeButton.alpha = 1
            cell.customView.selectOrUnselectLabel.alpha = 1
        }
        
        let itemSizeNames = NSMutableArray()
        let itemSizeCounts = NSMutableArray()

        for itemSize in item.itemSizes
        {
            itemSizeNames.add(itemSize.itemSizeName)
            itemSizeCounts.add(NSNumber(value: Int32(itemSize.itemAvailability) as Int32))
        }
        
        if item.isSizesDownloaded == true
        {
            cell.customView.itemSizeNamesArray = itemSizeNames
            cell.customView.itemsSizesCountArray = itemSizeCounts
        }
        else
        {
            cell.customView.itemSizeNamesArray = NSMutableArray()
            if item.isSizesDownloading == false
            {
                self.loadItemSizesForItem(item)
            }
        }
        
        if itemSizeCounts.count > 0
        {
          let count2 : Int = (itemSizeCounts[0] as! NSNumber).intValue
          if(count2 == 0)
          {
            cell.customView.sizeButton.backgroundColor = UIColor.gray
            cell.customView.sizeButton.setTitle(nil, for: UIControlState())
            let image = UIImage(named: "no_Sizes", in: Bundle(for: type(of: self)), compatibleWith: nil) as UIImage?
            cell.customView.sizeButton.setImage(image, for: UIControlState())
          }
          else
          {
            cell.customView.sizeButton.backgroundColor = Constants.dotSelectedColor
            let buttonTitleValue = itemSizeNames[0]
            cell.customView.sizeButton.setTitle(buttonTitleValue as? String, for: UIControlState())
          }
        }
        
        if selectedIndexAtCollectionView == indexPath.item
        {
            cell.customView.sizesCollectioView.alpha = 0
            cell.customView.sizeButton.alpha = 1
            selectedIndexAtCollectionView = 1000
            
            cell.customView.sizeButton.backgroundColor = Constants.dotSelectedColor
            cell.customView.sizeButton.setTitle(sizeValue, for: UIControlState())
        }

        
        let sizesCollectionView = cell.customView.sizesCollectioView
        sizesCollectionView?.reloadData()
        cell.customView.layoutIfNeeded()

        return cell
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
          return CGSize(width:aCollectionView.frame.width,height:100)
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
                ///print("sizesArray of SubCollectionview\(sizesArray)")
                shoeItem.itemSizes = sizesArray
                shoeItem.isSizesDownloaded = true
                shoeItem.isSizesDownloading = false
                
                self.aCollectionView.reloadData()
                
                return
            }
        })
    }
    
    @objc func btnSelectedCellAtIndexpath(_ notification: Notification)
    {
        
        selectedIndexBtnAtCustomView = (notification.object as? Int)!
        
        let selectedIndexBtnAtCustomViewIndex = selectedItems[selectedIndexBtnAtCustomView]
        
        self.aCollectionView.reloadItems(at: [IndexPath(item:self.selectedItems.index(of: selectedIndexBtnAtCustomViewIndex)!, section: 0)])
    }
    
    
    @objc func collectionViewSelectedCellAtIndexpath(_ notification: Notification)
    {
        let dict = (notification.object as? NSDictionary)!
        sizeValue = (dict["sizeValue"] as? String)!
        selectedIndexAtCollectionView = (dict["sizesCollectioViewTag"] as? Int)!
        
        let selectedIndexAtCollectionViewIndex = selectedItems[selectedIndexAtCollectionView]
        
        self.aCollectionView.reloadItems(at: [IndexPath(item:self.selectedItems.index(of: selectedIndexAtCollectionViewIndex)!, section: 0)])
        
    }
    

  
    @IBAction func closeBtnTapped(_ sender: AnyObject)
    {
        self.delegate.popupDidTapClose(self)
    }
    
    @IBAction func checkoutBtnTapped(_ sender: AnyObject)
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
            
            if item.itemSizes.count > 0
            {
                itemCopy.sizeSelected = item.itemSizes[0]
            }
            else
            {
                itemCopy.sizeSelected = nil

            }
            
            FACart.sharedCart().addItemToCart(itemCopy)
        }
        
        self.shoppingCartController.delegate = self
        self.shoppingCartController.view.isHidden = false
        
        self.shoppingCartController.animateCheckoutButton()
    
    }
    
    func shoppingCartDidTapBackButton(_ shoppingCart: ShoppingCart!)
    {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        self.view = nil
    }
}

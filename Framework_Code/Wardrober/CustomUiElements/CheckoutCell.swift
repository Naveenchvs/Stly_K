//
//  CheckoutCell.swift
//  Fashion180
//
//  Created by Srinivas Peddinti on 10/13/16.
//  Copyright © 2016 MobiwareInc. All rights reserved.
//

import UIKit

@objc protocol CheckoutCellDelegate
{
    
    func checkoutCellRemoveButtonTapped(_ cell : CheckoutCell)
    
    func checkoutCellSizeButtonTapped(_ sizeTag : Int)
    
    @objc optional func checkOutCell(cell : CheckoutCell!, sizeButtonTappedForShoeItemAtIndex shoeItemIndex : Int, atValueAtIndex shoeItemValue : Int )
}

class CheckoutCell: UITableViewCell,CartInnerViewDelegate
{

    @IBOutlet weak var itemImageView : UIImageView!

    @IBOutlet weak var removeBtn : UIButton!
    
    @IBOutlet weak var designerNameLble : UILabel!
    
    @IBOutlet weak var itemNameLble : UILabel!
    
    @IBOutlet weak var colorInfo : UILabel!
    
    @IBOutlet weak var sizeLble : UILabel!
    
    @IBOutlet var sizeBtn: UIButton!
    
    @IBOutlet weak var priceLble : UILabel!
    
    @IBOutlet var innerBGView: CartInnerView!
    
    //var collectionView : UICollectionView!
    
    var delegate : CheckoutCellDelegate? = nil
    
    @IBOutlet weak var itemInfoView : UIView!
    @IBOutlet weak var itemDeletedView : UIView!
    @IBOutlet weak var separatorView : UIView!

    @IBOutlet weak var separatorViewLeadingConstraint : NSLayoutConstraint!
    @IBOutlet weak var separatorViewTrailingConstraint : NSLayoutConstraint!
    @IBOutlet weak var itemInfoViewLeadingConstraint : NSLayoutConstraint!
    @IBOutlet weak var itemInfoViewTrailingConstraint : NSLayoutConstraint!
    @IBOutlet weak var itemDeletedViewLeadingConstraint : NSLayoutConstraint!
    @IBOutlet weak var itemDeletedViewTrailingConstraint : NSLayoutConstraint!
    
    
    @IBOutlet var designerLabel_W_Constraint: NSLayoutConstraint!
    
    //let screenSize: CGRect = UIScreen.main.bounds
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        innerBGView.delegate = self
        
        sizeBtn.layer.masksToBounds = true
        sizeBtn.layer.cornerRadius = sizeBtn.frame.width/2
        sizeBtn.clipsToBounds = true
        
    }


    @IBAction func removeTapped(_ sender : UIButton)
    {
        if let del = self.delegate
        {
            del.checkoutCellRemoveButtonTapped(self)
        }
    }
    
    @IBAction func sizeBtnTapped(_ sender: UIButton)
    {
        if let del = self.delegate
        {
            del.checkoutCellSizeButtonTapped(sizeBtn.tag)
        }
    }
    
    
    // MARK: - CUSTOM COLLECTIONVIEW DELEGATE
    
    func selectedSizeAtIndexpath(_ cell: CartInnerView, selectedInnerCollectionViewIndex: Int, selectedValueIndexOfInnerCollectionView: Int)
    {

        cell.selectedIndexOfInnerCollectionView = FACart.sharedCart().getCartItems()[selectedInnerCollectionViewIndex]
        cell.sizesCollectioViewInInnerView.reloadData()
        
        self.delegate?.checkOutCell!(cell: self, sizeButtonTappedForShoeItemAtIndex: selectedInnerCollectionViewIndex, atValueAtIndex: selectedValueIndexOfInnerCollectionView)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

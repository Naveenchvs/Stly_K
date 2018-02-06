//
//  CartCustomView.swift
//  Fashion180
//
//  Created by Saraschandra on 14/04/17.
//  Copyright © 2017 Mobiware. All rights reserved.
//

import UIKit

protocol CartInnerViewDelegate
{
   func selectedSizeAtIndexpath(_ cell : CartInnerView, selectedInnerCollectionViewIndex : Int, selectedValueIndexOfInnerCollectionView : Int)
}
class CartInnerView: UIView,UICollectionViewDataSource,UICollectionViewDelegate
{
    @IBOutlet weak var sizesCollectioViewInInnerView : UICollectionView!
    
    
    var itemSizes = [ItemSize]()

    var delegate : CartInnerViewDelegate?
    
    var selectedIndexOfInnerCollectionView : ShoeItem!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return itemSizes.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizesCellIdentifierInInnerView", for: indexPath) as! CartInnerViewCell
        
        let itemName = self.itemSizes[indexPath.item].itemSizeName
        
        cell.sizeLabel.text = itemName
        
        
        
        let count : Int = self.itemSizes[indexPath.item].itemAvailability
        
        if(count == 0)
        {
            cell.noSizesAvilableImageView.isHidden = false
            cell.sizeLabel.isHidden = true
            
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = UIColor.gray
        }
        else
        {
            cell.noSizesAvilableImageView.isHidden = true
            cell.sizeLabel.isHidden = false
            cell.isUserInteractionEnabled = true
            if(selectedIndexOfInnerCollectionView.sizeSelected?.itemSizeName == itemName)
            {
                cell.backgroundColor = Constants.dotSelectedColor
                
            }
            else
            {
                cell.backgroundColor = UIColor.gray
                
            }
        }
        
        
        /*if selectedIndexOfInnerCollectionView == indexPath.item
        {
            cell.backgroundColor = UIColor.gray
        }
        else
        {
             cell.backgroundColor = Constants.dotSelectedColor
        }*/
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = cell.frame.width/2
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let _ =  collectionView.cellForItem(at: indexPath) as! CartInnerViewCell
        
        let _ =  self.itemSizes[indexPath.item].itemSizeName
        
        //selectedCell.backgroundColor = Constants.productBlackColor
        
        if(delegate != nil)
        {
            delegate?.selectedSizeAtIndexpath(self, selectedInnerCollectionViewIndex: sizesCollectioViewInInnerView.tag, selectedValueIndexOfInnerCollectionView : indexPath.row)
        }
        
    }
    
}
    

    


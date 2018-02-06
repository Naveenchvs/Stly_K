//
//  CustomView.swift
//  Fashion180
//
//  Created by Saraschandra on 07/04/17.
//  Copyright © 2017 Mobiware. All rights reserved.
//

import UIKit

//protocol customSizeViewDelegate {
//    
//    func selectedCellAtIndexpath(cell : CustomSizesView, selectedIndexBtn : Int)
//}
class CustomSizesView: UIView,UICollectionViewDataSource,UICollectionViewDelegate
{
    var itemsSizesCountArray : NSMutableArray!
    
    var itemSizeNamesArray : NSMutableArray!
    var selectedIndex : Int = 1000
    
    var cell : SizesCell!
    
    //var delegate : customSizeViewDelegate!

    @IBOutlet weak var sizesCollectioView : UICollectionView!
    @IBOutlet weak var sizeButton : UIButton!
    @IBOutlet weak var selectOrUnselectLabel : UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        sizeButton.layer.masksToBounds = true
        sizeButton.layer.cornerRadius = sizeButton.frame.width/2
        sizeButton.clipsToBounds = true
        
        
    }
    
   func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return self.itemSizeNamesArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizesCellIdentifier", for: indexPath) as! SizesCell
        
        let itemName = self.itemSizeNamesArray[indexPath.item]
        cell.sizesInfoLabel.text = itemName as? String
        ///print("ItemAtIndexPath \(itemName as? String)")
        
        let count : Int = (self.itemsSizesCountArray[indexPath.item] as! NSNumber).intValue
        if(count == 0)
        {
            cell.noSizesAvailableImageView.isHidden = false
            cell.sizesInfoLabel.isHidden = true
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = UIColor.gray
        }
        else
        {
            cell.noSizesAvailableImageView.isHidden = true
            cell.sizesInfoLabel.isHidden = false
            cell.isUserInteractionEnabled = true
            cell.backgroundColor = Constants.dotSelectedColor
        }
        
        /*let count2 : Int = (self.itemsSizesCountArray[0] as! NSNumber).integerValue
        if(count2 == 0)
        {
            sizeButton.setTitle(nil, forState: UIControlState.Normal)
            let image = UIImage(named: "no_Sizes", in: Bundle(for: type(of: self)), compatibleWith: nil) as UIImage?
            sizeButton.setImage(image, forState: .Normal)
        }
        else
        {
            sizeButton.backgroundColor = Constants.dotSelectedColor
            let buttonTitleValue = self.itemSizeNamesArray[0]
            sizeButton.setTitle(buttonTitleValue as? String, forState: UIControlState.Normal)
        }*/
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = cell.frame.width/2
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let sizeValue =  self.itemSizeNamesArray[indexPath.item]
        //sizeButton.setTitle(sizeValue as? String, forState: UIControlState.Normal)
        
        let myDict = [ "sizeValue": sizeValue, "sizesCollectioViewTag":sizesCollectioView.tag]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "HIDESIZESCOLLECTIONVIEW"), object:myDict)
    
    }
    
     @IBAction func sizeButtonTapped(_ sender : UIButton!)
     {
       ///print(sizeButton.tag)
        
       NotificationCenter.default.post(name: Notification.Name(rawValue: "SELECTEDBUTTONATINDEXPATH"), object:sizeButton.tag)
        
     }

}

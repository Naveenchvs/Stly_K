//
//  CustomCollectionView.swift
//  Fashion180
//
//  Created by Srinivas Peddinti on 12/15/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//

import UIKit

protocol customCollectionViewDelegate {
    
    func selectedSizeAtIndexpath(_ cell : CustomCollectionView, selectedIndex : Int)
}

class CustomCollectionView: UIView , UICollectionViewDataSource, UICollectionViewDelegate {

    var itemsSizesCountArray : NSMutableArray!
    
    var itemSizeNamesArray : NSMutableArray!

    @IBOutlet var productsCollectionView : UICollectionView!

    var delegate : customCollectionViewDelegate?
    
    var selectedIndex : Int = 1000
    
    // MARK: - Collection View methods
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    var cellSize : CGFloat = 0
    
    var minimumInterSpacing : CGFloat = 5.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
   
        switch (Constants.deviceIdiom)
        {
            
        case .pad:
            
            cellSize = 50
            
        case .phone:
            
            if(screenSize.size.height <= 480){
                
                cellSize = 32
            }
            else{
                
                cellSize = 38
            }
            
        default: break
            ///print("Unspecified UI idiom")
            
        }

        
        
    }


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellSize, height: cellSize)
        
    }


    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        var totalNoOfCellsPossibleInOneRow : Int = 0
        switch (Constants.deviceIdiom)
        {
        case .pad:
            
            totalNoOfCellsPossibleInOneRow = 10
            
        case .phone:
            
            if screenSize.width <= 480
            {
                totalNoOfCellsPossibleInOneRow = 5
            }
            else{
                
                totalNoOfCellsPossibleInOneRow = 6
                
            }
        default:
            
            totalNoOfCellsPossibleInOneRow = 6
            
        }
        
        if(self.itemSizeNamesArray.count <= totalNoOfCellsPossibleInOneRow)
        {
            
            let totalCellWidth = cellSize * CGFloat(self.itemSizeNamesArray.count)
            ///print("totalCellWidth \(totalCellWidth)")
            let totalSpacingWidth = minimumInterSpacing * max(CGFloat(self.itemSizeNamesArray.count - 1), 0)
            ///print("totalSpacingWidth \(totalSpacingWidth)")

            ///print("self.productsCollectionView.frame.size.width \(self.productsCollectionView.frame.size.width) ")
            
            let leftInset = (self.productsCollectionView.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            
            ///print("leftInset \(leftInset)")

            
            let rightInset = leftInset
            
            let topInset = (self.productsCollectionView.frame.size.height - cellSize) / 2
            
            let bottomInset = topInset
            
                return UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset)
        }
        else
        {
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    //Use for interspacing
    @objc func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return minimumInterSpacing
    }

    @objc func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return minimumInterSpacing
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.itemSizeNamesArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductSizesCellIdentifier", for: indexPath) as! ProductSizesCell
        
        let itemName = self.itemSizeNamesArray[indexPath.item]
        
        cell.sizeInfoLable.text =  itemName as? String

        ///print("ItemAtIndexPath \(itemName as? String)")
        

            
        let count : Int = (self.itemsSizesCountArray[indexPath.item] as! NSNumber).intValue
        
        if(count == 0)
        {
            
            cell.noSizesAvailableImgView.isHidden = false
            cell.sizeInfoLable.isHidden = true
            cell.isUserInteractionEnabled = false
            cell.layer.borderColor = Constants.productNoAvailableColor.cgColor

        }
        else
        {
            cell.noSizesAvailableImgView.isHidden = true
            cell.sizeInfoLable.isHidden = false
            cell.isUserInteractionEnabled = true
            cell.layer.borderColor = Constants.productBlackColor.cgColor

        }
        

        if(selectedIndex == indexPath.row){
            
            cell.backgroundColor = Constants.productBlackColor
            cell.sizeInfoLable.textColor = Constants.productWhiteColor
            
        }
        else{
            
            cell.backgroundColor = Constants.productWhiteColor
            cell.sizeInfoLable.textColor = Constants.productBlackColor
            
        }

        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5.0
        cell.layer.borderWidth = 2.0

        return cell
        
    }
    func checkIntOrString(_ receivedValue : String) -> String{
        
        let checkIntValue = Int(receivedValue)
        
        if checkIntValue != nil {
            
            return "Integer"
        }
        else{
            
            return "String"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let selectedCell =  collectionView.cellForItem(at: indexPath) as! ProductSizesCell
     
        selectedCell.backgroundColor = Constants.productBlackColor
        
        selectedCell.sizeInfoLable.textColor = Constants.productWhiteColor
        
        if(delegate != nil)
        {
            delegate?.selectedSizeAtIndexpath(self, selectedIndex: indexPath.row)
        }
    }

}

//
//  ItemSizeHelper.swift
//  Fashion180
//
//  Created by Yogi on 16/11/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//

import UIKit

class ItemSizeHelper: NSObject {

    
    class func productItemParsing(_ responseObj:AnyObject?) -> [ItemSize]
    {
        let ProductDict = responseObj!["GetItemSizesByProductIDResult"] as! NSDictionary
        
        var itemSizes : [ItemSize] =  [ItemSize]()
        
        let success = ProductDict["Success"] as! Bool
        
        if success == true
        {
            if let _ = ProductDict["Error"] as? NSNull
            {
                if let resultsArray = ProductDict["Results"] as? NSArray
                {
                    
                    let letters = CharacterSet.letters
                    var containsLetters = false
                    for dict in resultsArray
                    {
                        
                        let itemSize = ItemSize()
                        
                        let itemCountStr = (dict as AnyObject).object(forKey: "Qty") as! String
                        
                        itemSize.itemSizeName = (dict as AnyObject).object(forKey: "ProductItemSize") as! String
                        
                        itemSize.itemAvailability = ClothingItemsHelper.getIntFromString(itemCountStr)
                        
                        itemSizes.append(itemSize)
                        
                        if itemSize.itemSizeName.rangeOfCharacter(from: letters) != nil
                        {
                            containsLetters = true
                        }
                        
                        
                    }
                    
                    if containsLetters == false
                    {
                        itemSizes.sort(by: { (size1, size2) -> Bool in
                            
                            return size1.itemSizeName.localizedStandardCompare(size2.itemSizeName) == ComparisonResult.orderedAscending
                        })
                    }
                    
                    return itemSizes
                }
            }
        }
        
        return itemSizes
    }

    
}

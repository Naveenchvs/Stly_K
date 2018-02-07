//
//  AvailabilityHelper.swift
//  Wardrober
//
//  Created by Saraschandra on 07/02/18.
//  Copyright © 2018 Mobiware. All rights reserved.
//

import UIKit

class AvailabilityHelper: NSObject
{
    class func  getAvailabilityHelper(_ responseObj:AnyObject?) -> [CheckAvailablityItems]?
    {
        var checkAvailablityItems : [CheckAvailablityItems] =  [CheckAvailablityItems]()
        
        if let resultsArray = responseObj!["Results"] as? [NSDictionary]
        {
            for dict in resultsArray
            {
                let checkAvailablityItem = CheckAvailablityItems()
                            
                checkAvailablityItem.productItemID = dict.object(forKey: "ProductItemID") as! Int
                checkAvailablityItem.size = dict.object(forKey: "Size") as! String
                checkAvailablityItem.avilability = dict.object(forKey: "Availability") as! Bool
                checkAvailablityItem.price = dict.object(forKey: "Price") as! String
                
                checkAvailablityItems.append(checkAvailablityItem)
                            
            }
            return checkAvailablityItems
        }
        return checkAvailablityItems
    }
    
}

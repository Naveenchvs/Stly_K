//
//  WishListHelper.swift
//  Fashion180
//
//  Created by Yogi on 16/11/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//

import UIKit

class WardrobeHelper: NSObject
{

    // MARK: - Add To Wardrobe Service

    class func getRequestDictForAddToWardrobeService(_ CustomerID : String, ProductItemID : String, AddOrRemove : String) -> Dictionary<String,String>
    {
        var requestDict:Dictionary<String,String> = Dictionary<String,String>()

        requestDict["CustomerID"] = CustomerID;
        
        requestDict["ProductItemID"] = ProductItemID
        
        requestDict["AddOrRemove"] = AddOrRemove
        
        return requestDict
    }
    
    
    class func parseAddToWardrobeResponse(_ responseObject:AnyObject?) -> (success : Bool?, errorString : String?)
    {
        let success = responseObject!["Success"] as! Bool
        
        var errorStr : String? = nil
        
        if  success == false
        {
            //failure
            
            if let resultArray = responseObject!["Results"] as! [NSDictionary]!
            {
                if resultArray.count > 0
                {
                    let statusDict = resultArray[0]
                    
                    errorStr = statusDict["StatusMsg"] as! String!
                }
                else
                {
                    errorStr = "Unknown Error"
                }
            }
            
        }
        
        return (success, errorStr)
    }
    
    
    
    // MARK: - Get Wardrobe Service

    
    class func getRequestDictForGetWardrobeService(_ customerID : String, startIndex : String, pageSize : String) -> Dictionary<String,String>{
        var requestDict:Dictionary<String,String> = Dictionary<String,String>()
        
        let scaleSize : String!
        if UIScreen.main.scale >= CGFloat(3)
        {
            scaleSize = "3"
        }
        else if UIScreen.main.scale >= CGFloat(2)
        {
            scaleSize = "2"
            
        }
        else
        {
            scaleSize = "1"
            
        }
        
        
        requestDict["CustomerID"] = customerID  ///for isAddedToWardrobe Status
        
        requestDict["AssetSize"] = scaleSize
        
        requestDict["StartIndex"] = startIndex
        
        requestDict["PageSize"] = pageSize
        
        
        
        return requestDict
    }
    
    
    class func parseFetchWardrobeResponse(_ responseObject:AnyObject?) -> (wardrobe : FAWardrobe?, errorString : String?)
    {
        let success = responseObject!["Success"] as! Bool
        
        if  success == true
        {
            //success
            
            let wardrobe: FAWardrobe = FAWardrobe()
            
            if let resultArray = responseObject!["Results"] as! [NSDictionary]!
            {
                if resultArray.count > 0
                {
                    let dict : NSDictionary = resultArray.first!

                    
                        var mainTopArray = [ShoeItem]()
                        var secTopArray = [ShoeItem]()
                        var earringsArray = [ShoeItem]()
                        var bottomsArray = [ShoeItem]()
                        var shoesArray = [ShoeItem]()
                        
                        var assetsArray = [ItemAssetImage]()
                        var assetSizeSpecsArray = [ItemAssetSpecs]()
                        
                        
                        /// Item Assets
                        if let assArray = dict.object(forKey: "AssetsInfo") as? NSArray
                        {
                            for assetDict in (assArray as? [[String:Any]])!
                            {
                                let itemAssetImage = ItemAssetImage()
                                
                                if let productID = assetDict["ProductID"] as? String{
                                    
                                    itemAssetImage.productID = productID
                                }
                                if let assetUrl = assetDict["AssetURL"] as? String{
                                    
                                    itemAssetImage.assetUrl = assetUrl
                                }
                                if let assetUrl = assetDict["BackAssetURL"] as? String{
                                    
                                    itemAssetImage.rearAssetUrl = assetUrl
                                }
                                if let assetSize = assetDict["AssetSize"] as? String{
                                    
                                    itemAssetImage.assetSize = assetSize
                                }
                                
                                assetsArray.append(itemAssetImage)
                                
                            }
                        }
                        
                        
                        ///Item Asset size Specs
                        if let assetSpecsArray = dict.object(forKey: "ProductItemAxisInfo") as? NSArray
                        {
                            for assetSpecsDict in (assetSpecsArray as? [[String:Any]])!
                            {
                                let itemAssetSpecs =  ItemAssetSpecs()
                                
                                let productID = assetSpecsDict["ProductID"] as! String
                                itemAssetSpecs.productID = productID
                                
                                if let assetFrontBoundsArray = assetSpecsDict["FrontAxisInfo"] as? NSArray
                                {
                                    let assetFrontBoundsDict = assetFrontBoundsArray.firstObject as! NSDictionary
                                    
                                    let itemAssetBoundsFront = ItemAssetBounds()
                                    
                                    if let x_pos = assetFrontBoundsDict["X"] as? String
                                    {
                                        itemAssetBoundsFront.xPos = ClothingItemsHelper.getCGFloatFromString(x_pos)
                                    }
                                    else
                                    {
                                        itemAssetBoundsFront.xPos = nil
                                    }
                                    
                                    
                                    
                                    if let y_pos = assetFrontBoundsDict["Y"] as? String
                                    {
                                        itemAssetBoundsFront.yPos = ClothingItemsHelper.getCGFloatFromString(y_pos)
                                    }
                                    else
                                    {
                                        itemAssetBoundsFront.yPos = nil
                                    }
                                    
                                    if let width = assetFrontBoundsDict["W"] as? String
                                    {
                                        itemAssetBoundsFront.width = ClothingItemsHelper.getCGFloatFromString(width)
                                        
                                    }
                                    else
                                    {
                                        itemAssetBoundsFront.width = nil
                                    }
                                    
                                    if let height = assetFrontBoundsDict["H"] as? String
                                    {
                                        itemAssetBoundsFront.height = ClothingItemsHelper.getCGFloatFromString(height)
                                    }
                                    else
                                    {
                                        itemAssetBoundsFront.height = nil
                                    }
                                    
                                    if let dotCenterX = assetFrontBoundsDict["DotX"] as? String
                                    {
                                        itemAssetBoundsFront.dotCenterX = ClothingItemsHelper.getCGFloatFromString(dotCenterX)
                                    }
                                    else
                                    {
                                        itemAssetBoundsFront.dotCenterX = nil
                                    }
                                    
                                    if let dotCenterY = assetFrontBoundsDict["DotY"] as? String
                                    {
                                        itemAssetBoundsFront.dotCenterY = ClothingItemsHelper.getCGFloatFromString(dotCenterY)
                                    }
                                    else
                                    {
                                        itemAssetBoundsFront.dotCenterY = nil
                                    }

                                    
                                    itemAssetSpecs.assetBoundsFront = itemAssetBoundsFront
                                }
                                
                                if let assetRearBoundsArray = assetSpecsDict["BackAxisInfo"] as? NSArray
                                {
                                    
                                    let assetRearBoundsDict = assetRearBoundsArray.firstObject as! NSDictionary
                                    
                                    let itemAssetBoundsRear = ItemAssetBounds()
                                    
                                    if let x_pos = assetRearBoundsDict["X"] as? String
                                    {
                                        itemAssetBoundsRear.xPos = ClothingItemsHelper.getCGFloatFromString(x_pos)
                                    }
                                    else
                                    {
                                        itemAssetBoundsRear.xPos = nil
                                    }
                                    
                                    
                                    if let y_pos = assetRearBoundsDict["Y"] as? String
                                    {
                                        itemAssetBoundsRear.yPos = ClothingItemsHelper.getCGFloatFromString(y_pos)
                                    }
                                    else
                                    {
                                        itemAssetBoundsRear.yPos = nil
                                    }
                                    
                                    
                                    if let width = assetRearBoundsDict["W"] as? String
                                    {
                                        itemAssetBoundsRear.width = ClothingItemsHelper.getCGFloatFromString(width)
                                        
                                    }
                                    else
                                    {
                                        itemAssetBoundsRear.width = nil
                                    }
                                    
                                    if let height = assetRearBoundsDict["H"] as? String
                                    {
                                        itemAssetBoundsRear.height = ClothingItemsHelper.getCGFloatFromString(height)
                                        
                                    }
                                    else
                                    {
                                        itemAssetBoundsRear.height = nil
                                    }
                                    
                                    if let dotCenterX = assetRearBoundsDict["DotX"] as? String
                                    {
                                        itemAssetBoundsRear.dotCenterX = ClothingItemsHelper.getCGFloatFromString(dotCenterX)
                                    }
                                    else
                                    {
                                        itemAssetBoundsRear.dotCenterX = nil
                                    }
                                    
                                    if let dotCenterY = assetRearBoundsDict["DotY"] as? String
                                    {
                                        itemAssetBoundsRear.dotCenterY = ClothingItemsHelper.getCGFloatFromString(dotCenterY)
                                    }
                                    else
                                    {
                                        itemAssetBoundsRear.dotCenterY = nil
                                    }
                                    
                                    itemAssetSpecs.assetBoundsRear = itemAssetBoundsRear
                                }
                                
                                let overridesDefaultZOrder = assetSpecsDict["OverrridesDefaultZOrder"] as! String
                                itemAssetSpecs.overridesDefaultZOrder = ClothingItemsHelper.getBoolFromString(overridesDefaultZOrder)
                                
                                assetSizeSpecsArray.append(itemAssetSpecs)
                            }
                        }
                        
                    
                        
                        /// Main Top
                        if let TMArray = dict.object(forKey: "TopProductItemDetailsinfo") as? NSArray
                        {
                            if TMArray.count > 0
                            {
                                for tsItemDict in (TMArray as? [[String:Any]])!
                                {
                                    let item = ShoeItem()
                                    ///default sec top Z order
                                    item.zOrder = 3
                                    
                                    if let productID = tsItemDict["ProductID"] as? String{
                                        
                                        item.itemProductID = productID
                                    }
                                    if let productName = tsItemDict["ProductName"] as? String{
                                        
                                        item.itemName = productName
                                    }
                                    else
                                    {
                                        item.itemName = ""
                                    }
                                    if let bodyCategoryName = tsItemDict["ItemType"] as? String{
                                        
                                        item.itemType = bodyCategoryName
                                    }
                                    else
                                    {
                                        item.itemType = ""
                                    }
                                    if let designerName = tsItemDict["DesignerName"] as? String{
                                        
                                        item.designerName = designerName
                                    }
                                    else
                                    {
                                        item.designerName = ""
                                    }
                                    if let price = tsItemDict["Price"] as? String{
                                        
                                        item.price = price
                                    }
                                    else
                                    {
                                        item.price = ""
                                    }
                                    
                                    
                                    if let options = tsItemDict["Options"] as? String{
                                        
                                        item.itemOptions = options
                                    }
                                    else
                                    {
                                        item.itemOptions = ""
                                    }
                                    
                                    //// Is Added to Wardrobe
                                    if let isWardrobed = tsItemDict["IsWardobItem"] as? Int{
                                        
                                        item.isAddedToWardrobe = ClothingItemsHelper.getBoolFromString("\(isWardrobed)")
                                    }
                                    else
                                    {
                                        item.isAddedToWardrobe = false
                                    }
                                    
                                    
                                    
                                    item.isPrimaryItem = true
                                    item.clothingType = ClothingType.top_MAIN
                                    
                                    let assets =   assetsArray.filter({ (itemAsset) -> Bool in
                                        
                                        return itemAsset.productID == item.itemProductID
                                        
                                    })
                                    
                                    if assets.count > 0
                                    {
                                        let itemAsset = assets[0]
                                        item.itemImageURL = itemAsset.assetUrl
                                        item.rearItemImageURL = itemAsset.rearAssetUrl

                                    }
                                    
                                    
                                    let itemAssetSizeSpecs =   assetSizeSpecsArray.filter({ (itemAsset) -> Bool in
                                        
                                        return itemAsset.productID == item.itemProductID
                                        
                                    })
                                    
                                    if itemAssetSizeSpecs.count > 0
                                    {
                                        let itemAssetBoundsInfo = itemAssetSizeSpecs[0]
                                        
                                        item.assetSizeSpecs = itemAssetBoundsInfo
                                    }
                                    
                                    
                                    mainTopArray.append(item)

                                    
                                }
                                
                                
                            }
                        }
                        
                        
                        /// Secondary Tops
                        if let TSArray = dict.object(forKey: "TopAccessoriesProductItemDetailsinfo") as? NSArray
                        {
                            if TSArray.count > 0
                            {
                                for tsItemDict in (TSArray as? [[String:Any]])!
                                {
                                    let item = ShoeItem()
                                    
                                    ///default sec top Z order
                                    item.zOrder = 4
                                    
                                    if let productID = tsItemDict["ProductID"] as? String{
                                        
                                        item.itemProductID = productID
                                    }
                                    if let productName = tsItemDict["ProductName"] as? String{
                                        
                                        item.itemName = productName
                                    }
                                    else
                                    {
                                        item.itemName = ""
                                    }
                                    if let bodyCategoryName = tsItemDict["ItemType"] as? String{
                                        
                                        item.itemType = bodyCategoryName
                                    }
                                    else
                                    {
                                        item.itemType = ""
                                    }
                                    if let designerName = tsItemDict["DesignerName"] as? String{
                                        
                                        item.designerName = designerName
                                    }
                                    else
                                    {
                                        item.designerName = ""
                                    }
                                    if let price = tsItemDict["Price"] as? String{
                                        
                                        item.price = price
                                    }
                                    else
                                    {
                                        item.price = ""
                                    }
                                    
                                    
                                    if let options = tsItemDict["Options"] as? String{
                                        
                                        item.itemOptions = options
                                    }
                                    else
                                    {
                                        item.itemOptions = ""
                                    }
                                    
                                    //// Is Added to Wardrobe
                                    if let isWardrobed = tsItemDict["IsWardobItem"] as? Int{
                                        
                                        item.isAddedToWardrobe = ClothingItemsHelper.getBoolFromString("\(isWardrobed)")
                                    }
                                    else
                                    {
                                        item.isAddedToWardrobe = false
                                    }
                                    
                                    
                                    
                                    item.isPrimaryItem = false
                                    item.clothingType = ClothingType.top_SECONDARY
                                    
                                    let assets =   assetsArray.filter({ (itemAsset) -> Bool in
                                        
                                        return itemAsset.productID == item.itemProductID
                                        
                                    })
                                    
                                    if assets.count > 0
                                    {
                                        let itemAsset = assets[0]
                                        item.itemImageURL = itemAsset.assetUrl
                                        item.rearItemImageURL = itemAsset.rearAssetUrl

                                    }
                                    
                                    
                                    let itemAssetSizeSpecs =   assetSizeSpecsArray.filter({ (itemAsset) -> Bool in
                                        
                                        return itemAsset.productID == item.itemProductID
                                        
                                    })
                                    
                                    if itemAssetSizeSpecs.count > 0
                                    {
                                        let itemAssetBoundsInfo = itemAssetSizeSpecs[0]
                                        
                                        item.assetSizeSpecs = itemAssetBoundsInfo
                                    }
                                    
                                    
                                    secTopArray.append(item)
                                    
                                }
                                
                                
                                
                            }
                        }
                        
                        
                        
                        /// Earrings
                        if let TSArray = dict.object(forKey: "EarProductItemDetailsinfo") as? NSArray
                        {
                            if TSArray.count > 0
                            {
                                for tsItemDict in (TSArray as? [[String:Any]])!
                                {
                                    let item = ShoeItem()
                                    
                                    ///default earrings Z order
                                    item.zOrder = 5
                                    
                                    if let productID = tsItemDict["ProductID"] as? String{
                                        
                                        item.itemProductID = productID
                                    }
                                    if let productName = tsItemDict["ProductName"] as? String{
                                        
                                        item.itemName = productName
                                    }
                                    else
                                    {
                                        item.itemName = ""
                                    }
                                    if let bodyCategoryName = tsItemDict["ItemType"] as? String{
                                        
                                        item.itemType = bodyCategoryName
                                    }
                                    else
                                    {
                                        item.itemType = ""
                                    }
                                    if let designerName = tsItemDict["DesignerName"] as? String{
                                        
                                        item.designerName = designerName
                                    }
                                    else
                                    {
                                        item.designerName = ""
                                    }
                                    if let price = tsItemDict["Price"] as? String{
                                        
                                        item.price = price
                                    }
                                    else
                                    {
                                        item.price = ""
                                    }
                                    
                                    
                                    if let options = tsItemDict["Options"] as? String{
                                        
                                        item.itemOptions = options
                                    }
                                    else
                                    {
                                        item.itemOptions = ""
                                    }
                                    
                                    
                                    
                                    //// Is Added to Wardrobe
                                    if let isWardrobed = tsItemDict["IsWardobItem"] as? Int{
                                        
                                        item.isAddedToWardrobe = ClothingItemsHelper.getBoolFromString("\(isWardrobed)")
                                    }
                                    else
                                    {
                                        item.isAddedToWardrobe = false
                                    }
                                    
                                    
                                    
                                    item.isPrimaryItem = false
                                    item.clothingType = ClothingType.earrings
                                    
                                    
                                    let assets =   assetsArray.filter({ (itemAsset) -> Bool in
                                        
                                        return itemAsset.productID == item.itemProductID
                                        
                                    })
                                    
                                    if assets.count > 0
                                    {
                                        let itemAsset = assets[0]
                                        item.itemImageURL = itemAsset.assetUrl
                                        item.rearItemImageURL = itemAsset.rearAssetUrl

                                    }
                                    
                                    
                                    let itemAssetSizeSpecs =   assetSizeSpecsArray.filter({ (itemAsset) -> Bool in
                                        
                                        return itemAsset.productID == item.itemProductID
                                        
                                    })
                                    
                                    if itemAssetSizeSpecs.count > 0
                                    {
                                        let itemAssetBoundsInfo = itemAssetSizeSpecs[0]
                                        
                                        item.assetSizeSpecs = itemAssetBoundsInfo
                                    }
                                    
                                    earringsArray.append(item)
                                    
                                }
                                
                                
                                
                            }
                        }
                        
                        
                        
                        /// Bottoms
                        if let TSArray = dict.object(forKey: "BottomProductItemDetailsinfo") as? NSArray
                        {
                            if TSArray.count > 0
                            {
                                for tsItemDict in (TSArray as? [[String:Any]])!
                                {
                                    let item = ShoeItem()
                                    
                                    ///default bottoms Z order
                                    item.zOrder = 2
                                    
                                    if let productID = tsItemDict["ProductID"] as? String{
                                        
                                        item.itemProductID = productID
                                    }
                                    if let productName = tsItemDict["ProductName"] as? String{
                                        
                                        item.itemName = productName
                                    }
                                    else
                                    {
                                        item.itemName = ""
                                    }
                                    if let bodyCategoryName = tsItemDict["ItemType"] as? String{
                                        
                                        item.itemType = bodyCategoryName
                                    }
                                    else
                                    {
                                        item.itemType = ""
                                    }
                                    if let designerName = tsItemDict["DesignerName"] as? String{
                                        
                                        item.designerName = designerName
                                    }
                                    else
                                    {
                                        item.designerName = ""
                                    }
                                    if let price = tsItemDict["Price"] as? String{
                                        
                                        item.price = price
                                    }
                                    else
                                    {
                                        item.price = ""
                                    }
                                    
                                    
                                    if let options = tsItemDict["Options"] as? String{
                                        
                                        item.itemOptions = options
                                    }
                                    else
                                    {
                                        item.itemOptions = ""
                                    }
                                    
                                    
                                    //// Is Added to Wardrobe
                                    if let isWardrobed = tsItemDict["IsWardobItem"] as? Int{
                                        
                                        item.isAddedToWardrobe = ClothingItemsHelper.getBoolFromString("\(isWardrobed)")
                                    }
                                    else
                                    {
                                        item.isAddedToWardrobe = false
                                    }
                                    
                                    
                                    
                                    item.isPrimaryItem = false
                                    item.clothingType = ClothingType.bottom
                                    
                                    
                                    let assets =   assetsArray.filter({ (itemAsset) -> Bool in
                                        
                                        return itemAsset.productID == item.itemProductID
                                        
                                    })
                                    
                                    if assets.count > 0
                                    {
                                        let itemAsset = assets[0]
                                        item.itemImageURL = itemAsset.assetUrl
                                        item.rearItemImageURL = itemAsset.rearAssetUrl

                                    }
                                    
                                    
                                    let itemAssetSizeSpecs =   assetSizeSpecsArray.filter({ (itemAsset) -> Bool in
                                        
                                        return itemAsset.productID == item.itemProductID
                                        
                                    })
                                    
                                    if itemAssetSizeSpecs.count > 0
                                    {
                                        let itemAssetBoundsInfo = itemAssetSizeSpecs[0]
                                        
                                        item.assetSizeSpecs = itemAssetBoundsInfo
                                    }
                                    
                                    bottomsArray.append(item)
                                    
                                }
                                
                                
                                
                            }
                        }
                        
                        
                        /// Shoes
                        if let TSArray = dict.object(forKey: "ShoeProductItemDetailsinfo") as? NSArray
                        {
                            if TSArray.count > 0
                            {
                                for tsItemDict in (TSArray as? [[String:Any]])!
                                {
                                    let item = ShoeItem()
                                    
                                    ///default shoes Z order
                                    item.zOrder = 1
                                    
                                    if let productID = tsItemDict["ProductID"] as? String{
                                        
                                        item.itemProductID = productID
                                    }
                                    if let productName = tsItemDict["ProductName"] as? String{
                                        
                                        item.itemName = productName
                                    }
                                    else
                                    {
                                        item.itemName = ""
                                    }
                                    if let bodyCategoryName = tsItemDict["ItemType"] as? String{
                                        
                                        item.itemType = bodyCategoryName
                                    }
                                    else
                                    {
                                        item.itemType = ""
                                    }
                                    if let designerName = tsItemDict["DesignerName"] as? String{
                                        
                                        item.designerName = designerName
                                    }
                                    else
                                    {
                                        item.designerName = ""
                                    }
                                    if let price = tsItemDict["Price"] as? String{
                                        
                                        item.price = price
                                    }
                                    else
                                    {
                                        item.price = ""
                                    }
                                    
                                    
                                    if let options = tsItemDict["Options"] as? String{
                                        
                                        item.itemOptions = options
                                    }
                                    else
                                    {
                                        item.itemOptions = ""
                                    }
                                    
                                    
                                    
                                    //// Is Added to Wardrobe
                                    if let isWardrobed = tsItemDict["IsWardobItem"] as? Int{
                                        
                                        item.isAddedToWardrobe = ClothingItemsHelper.getBoolFromString("\(isWardrobed)")
                                    }
                                    else
                                    {
                                        item.isAddedToWardrobe = false
                                    }
                                    
                                    
                                    
                                    
                                    item.isPrimaryItem = false
                                    item.clothingType = ClothingType.shoes
                                    
                                    
                                    let assets =   assetsArray.filter({ (itemAsset) -> Bool in
                                        
                                        return itemAsset.productID == item.itemProductID
                                        
                                    })
                                    
                                    if assets.count > 0
                                    {
                                        let itemAsset = assets[0]
                                        item.itemImageURL = itemAsset.assetUrl
                                        item.rearItemImageURL = itemAsset.rearAssetUrl

                                    }
                                    
                                    
                                    let itemAssetSizeSpecs =   assetSizeSpecsArray.filter({ (itemAsset) -> Bool in
                                        
                                        return itemAsset.productID == item.itemProductID
                                        
                                    })
                                    
                                    if itemAssetSizeSpecs.count > 0
                                    {
                                        let itemAssetBoundsInfo = itemAssetSizeSpecs[0]
                                        
                                        item.assetSizeSpecs = itemAssetBoundsInfo
                                    }
                                    
                                    shoesArray.append(item)
                                    
                                }
                                
                            }
                        }
                    
                    
                    
                        ////Main Tops Count
                        if let totalMainTopsCount = dict["TotalTopsCount"] as? String{
                            
                            wardrobe.totalMainTopsCount = ClothingItemsHelper.getIntFromString(totalMainTopsCount)
                        }
                        else
                        {
                            wardrobe.totalMainTopsCount = 0
                        }
                        
                        ////Earrings Count
                        if let totalEarringsCount = dict["TotalEarRingsCount"] as? String{
                            
                            wardrobe.totalEarringsCount = ClothingItemsHelper.getIntFromString(totalEarringsCount)
                        }
                        else
                        {
                            wardrobe.totalEarringsCount = 0
                        }
                        
                        ////Jackets Count
                        if let totalJacketsCount = dict["TotalJacketsRingsCount"] as? String{
                            
                            wardrobe.totalJackectsCount = ClothingItemsHelper.getIntFromString(totalJacketsCount)
                        }
                        else
                        {
                            wardrobe.totalJackectsCount = 0
                        }
                        
                        ////Bottoms Count
                        if let totalBottomsCount = dict["TotalBottomsCount"] as? String{
                            
                            wardrobe.totalBottomsCount = ClothingItemsHelper.getIntFromString(totalBottomsCount)
                        }
                        else
                        {
                            wardrobe.totalBottomsCount = 0
                        }
                        
                        
                        ////Shoes Count
                        if let totalShoesCount = dict["TotalShoesCount"] as? String{
                            
                            wardrobe.totalShoesCount = ClothingItemsHelper.getIntFromString(totalShoesCount)
                        }
                        else
                        {
                            wardrobe.totalShoesCount = 0
                        }
                    
                        wardrobe.topsMainArray = mainTopArray
                        wardrobe.topsSecArray = secTopArray
                        wardrobe.earringsArray = earringsArray
                        wardrobe.bottomsArray = bottomsArray
                        wardrobe.shoeArray = shoesArray
                    
                }
                
                
                
                return (wardrobe, nil)
                
            }
            else
            {
                //failure
                let genericErrorMsg = "Failed to fetch items. Please try again later."
                if let errorDict = responseObject!["Error"] as! NSDictionary!
                {
                    if let errorMessage = errorDict["Message"] as? String
                    {
                        return (nil, errorMessage)
                        
                    }
                    else
                    {
                        return (nil, genericErrorMsg)
                    }
                    
                }
                else
                {
                    return (nil, genericErrorMsg)
                }
                
                
            }
            
        }
        
        return (nil, nil)
    }
    
    
    // MARK: - Get More Wardrobe Items
    
    class func getRequestDictForFetchMoreWardrobeItems(_ customerID : String, startIndex : String, pageSize : String) -> Dictionary<String,String>{
        var requestDict:Dictionary<String,String> = Dictionary<String,String>()
        
        
        
        let scaleSize : String!
        if UIScreen.main.scale >= CGFloat(3)
        {
            scaleSize = "3"
        }
        else if UIScreen.main.scale >= CGFloat(2)
        {
            scaleSize = "2"
            
        }
        else
        {
            scaleSize = "1"
            
        }
        
        //        "CustomerID":"String content",
        //        "StartIndex":2147483647,
        //        "PageSize":2147483647,
        //        "AssetSize":2147483647
        
        
        requestDict["CustomerID"] = customerID  ///for isAddedToWardrobe Status
        
        requestDict["AssetSize"] = scaleSize
        
        requestDict["StartIndex"] = startIndex
        
        requestDict["PageSize"] = pageSize
        
        
        return requestDict
    }
    
    
    class func parseFetchMoreWardrobeItemsResponse(_ responseObject:AnyObject?, forItemType itemType: ClothingType) -> (clothingItems : [ShoeItem]?, errorString : String?)
    {
        let success = responseObject!["Success"] as! Bool
        
        if  success == true
        {
            //success
            
            
            var itemsArray = [ShoeItem]()
            
            if let resultArray = responseObject!["Results"] as! [NSDictionary]!
            {
                if resultArray.count > 0
                {
                    let dict = resultArray.first as NSDictionary!
                    
                    var assetsArray = [ItemAssetImage]()
                    var assetSizeSpecsArray = [ItemAssetSpecs]()
                    
                    /// Item Assets
                    if let assArray = dict?.object(forKey: "AssetsInfo") as? NSArray
                    {
                        for assetDict in (assArray as? [[String:Any]])!
                        {
                            let itemAssetImage = ItemAssetImage()
                            
                            if let productID = assetDict["ProductID"] as? String{
                                
                                itemAssetImage.productID = productID
                            }
                            if let assetUrl = assetDict["AssetURL"] as? String{
                                
                                itemAssetImage.assetUrl = assetUrl
                            }
                            if let assetUrl = assetDict["BackAssetURL"] as? String{
                                
                                itemAssetImage.rearAssetUrl = assetUrl
                            }
                            if let assetSize = assetDict["AssetSize"] as? String{
                                
                                itemAssetImage.assetSize = assetSize
                            }
                            
                            assetsArray.append(itemAssetImage)
                            
                        }
                    }
                    
                    
                    ///Item Asset size Specs
                    if let assetSpecsArray = dict?.object(forKey: "ProductItemAxisInfo") as? NSArray
                    {
                        for assetSpecsDict in (assetSpecsArray as? [[String:Any]])!
                        {
                            let itemAssetSpecs =  ItemAssetSpecs()
                            
                            let productID = assetSpecsDict["ProductID"] as! String
                            itemAssetSpecs.productID = productID
                            
                            if let assetFrontBoundsArray = assetSpecsDict["FrontAxisInfo"] as? NSArray
                            {
                                let assetFrontBoundsDict = assetFrontBoundsArray.firstObject as! NSDictionary
                                
                                let itemAssetBoundsFront = ItemAssetBounds()
                                
                                if let x_pos = assetFrontBoundsDict["X"] as? String
                                {
                                    itemAssetBoundsFront.xPos = ClothingItemsHelper.getCGFloatFromString(x_pos)
                                }
                                else
                                {
                                    itemAssetBoundsFront.xPos = nil
                                }
                                
                                
                                
                                if let y_pos = assetFrontBoundsDict["Y"] as? String
                                {
                                    itemAssetBoundsFront.yPos = ClothingItemsHelper.getCGFloatFromString(y_pos)
                                }
                                else
                                {
                                    itemAssetBoundsFront.yPos = nil
                                }
                                
                                if let width = assetFrontBoundsDict["W"] as? String
                                {
                                    itemAssetBoundsFront.width = ClothingItemsHelper.getCGFloatFromString(width)
                                    
                                }
                                else
                                {
                                    itemAssetBoundsFront.width = nil
                                }
                                
                                if let height = assetFrontBoundsDict["H"] as? String
                                {
                                    itemAssetBoundsFront.height = ClothingItemsHelper.getCGFloatFromString(height)
                                }
                                else
                                {
                                    itemAssetBoundsFront.height = nil
                                }
                                
                                if let dotCenterX = assetFrontBoundsDict["DotX"] as? String
                                {
                                    itemAssetBoundsFront.dotCenterX = ClothingItemsHelper.getCGFloatFromString(dotCenterX)
                                }
                                else
                                {
                                    itemAssetBoundsFront.dotCenterX = nil
                                }
                                
                                if let dotCenterY = assetFrontBoundsDict["DotY"] as? String
                                {
                                    itemAssetBoundsFront.dotCenterY = ClothingItemsHelper.getCGFloatFromString(dotCenterY)
                                }
                                else
                                {
                                    itemAssetBoundsFront.dotCenterY = nil
                                }

                                
                                itemAssetSpecs.assetBoundsFront = itemAssetBoundsFront
                            }
                            
                            if let assetRearBoundsArray = assetSpecsDict["BackAxisInfo"] as? NSArray
                            {
                                
                                let assetRearBoundsDict = assetRearBoundsArray.firstObject as! NSDictionary
                                
                                let itemAssetBoundsRear = ItemAssetBounds()
                                
                                if let x_pos = assetRearBoundsDict["X"] as? String
                                {
                                    itemAssetBoundsRear.xPos = ClothingItemsHelper.getCGFloatFromString(x_pos)
                                }
                                else
                                {
                                    itemAssetBoundsRear.xPos = nil
                                }
                                
                                
                                if let y_pos = assetRearBoundsDict["Y"] as? String
                                {
                                    itemAssetBoundsRear.yPos = ClothingItemsHelper.getCGFloatFromString(y_pos)
                                }
                                else
                                {
                                    itemAssetBoundsRear.yPos = nil
                                }
                                
                                
                                if let width = assetRearBoundsDict["W"] as? String
                                {
                                    itemAssetBoundsRear.width = ClothingItemsHelper.getCGFloatFromString(width)
                                    
                                }
                                else
                                {
                                    itemAssetBoundsRear.width = nil
                                }
                                
                                if let height = assetRearBoundsDict["H"] as? String
                                {
                                    itemAssetBoundsRear.height = ClothingItemsHelper.getCGFloatFromString(height)
                                    
                                }
                                else
                                {
                                    itemAssetBoundsRear.height = nil
                                }
                                
                                if let dotCenterX = assetRearBoundsDict["DotX"] as? String
                                {
                                    itemAssetBoundsRear.dotCenterX = ClothingItemsHelper.getCGFloatFromString(dotCenterX)
                                }
                                else
                                {
                                    itemAssetBoundsRear.dotCenterX = nil
                                }
                                
                                if let dotCenterY = assetRearBoundsDict["DotY"] as? String
                                {
                                    itemAssetBoundsRear.dotCenterY = ClothingItemsHelper.getCGFloatFromString(dotCenterY)
                                }
                                else
                                {
                                    itemAssetBoundsRear.dotCenterY = nil
                                }

                                
                                itemAssetSpecs.assetBoundsRear = itemAssetBoundsRear
                            }
                            
                            let overridesDefaultZOrder = assetSpecsDict["OverrridesDefaultZOrder"] as! String
                            itemAssetSpecs.overridesDefaultZOrder = ClothingItemsHelper.getBoolFromString(overridesDefaultZOrder)
                            
                            assetSizeSpecsArray.append(itemAssetSpecs)
                        }
                    }
                    
                    
                    var keyStringForItemsInResponse = ""
                    var defaultZOrder = 0
                    
                    switch itemType {
                        
                    case ClothingType.earrings:
                        
                        keyStringForItemsInResponse = "EarProductItemDetailsinfo"
                        defaultZOrder = 5
                        
                        break
                        
                    case ClothingType.top_SECONDARY:
                        keyStringForItemsInResponse = "TopAccessoriesProductItemDetailsinfo"
                        defaultZOrder = 4
                        break
                        
                    case ClothingType.top_MAIN:
                        
                        keyStringForItemsInResponse = "TopProductItemDetailsinfo"
                        defaultZOrder = 3
                        
                        break
                        
                        
                    case ClothingType.bottom:
                        keyStringForItemsInResponse = "BottomProductItemDetailsinfo"
                        defaultZOrder = 2
                        break
                        
                    case ClothingType.shoes:
                        keyStringForItemsInResponse = "ShoeProductItemDetailsinfo"
                        defaultZOrder = 1
                        break
                        
                    default:
                        break
                    }
                    
                    
                    
                    
                    //// Items
                    if let TSArray = dict?.object(forKey: keyStringForItemsInResponse) as? NSArray
                    {
                        if TSArray.count > 0
                        {
                            for tsItemDict in (TSArray as? [[String:Any]])!
                            {
                                let item = ShoeItem()
                                
                                ///item default Z order
                                item.zOrder = defaultZOrder
                                
                                if let productID = tsItemDict["ProductID"] as? String{
                                    
                                    item.itemProductID = productID
                                }
                                if let productName = tsItemDict["ProductName"] as? String{
                                    
                                    item.itemName = productName
                                }
                                else
                                {
                                    item.itemName = ""
                                }
                                if let bodyCategoryName = tsItemDict["ItemType"] as? String{
                                    
                                    item.itemType = bodyCategoryName
                                }
                                else
                                {
                                    item.itemType = ""
                                }
                                if let designerName = tsItemDict["DesignerName"] as? String{
                                    
                                    item.designerName = designerName
                                }
                                else
                                {
                                    item.designerName = ""
                                }
                                if let price = tsItemDict["Price"] as? String{
                                    
                                    item.price = price
                                }
                                else
                                {
                                    item.price = ""
                                }
                                
                                
                                if let options = tsItemDict["Options"] as? String{
                                    
                                    item.itemOptions = options
                                }
                                else
                                {
                                    item.itemOptions = ""
                                }
                                
                                
                                //// Is Added to Wardrobe
                                if let isWardrobed = tsItemDict["IsWardobItem"] as? Int{
                                    
                                    item.isAddedToWardrobe = ClothingItemsHelper.getBoolFromString("\(isWardrobed)")
                                }
                                else
                                {
                                    item.isAddedToWardrobe = false
                                }
                                
                                
                                
                                item.isPrimaryItem = false
                                item.clothingType = itemType
                                
                                
                                let assets =   assetsArray.filter({ (itemAsset) -> Bool in
                                    
                                    return itemAsset.productID == item.itemProductID
                                    
                                })
                                
                                if assets.count > 0
                                {
                                    let itemAsset = assets[0]
                                    item.itemImageURL = itemAsset.assetUrl
                                    item.rearItemImageURL = itemAsset.rearAssetUrl

                                }
                                
                                
                                let itemAssetSizeSpecs =   assetSizeSpecsArray.filter({ (itemAsset) -> Bool in
                                    
                                    return itemAsset.productID == item.itemProductID
                                    
                                })
                                
                                if itemAssetSizeSpecs.count > 0
                                {
                                    let itemAssetBoundsInfo = itemAssetSizeSpecs[0]
                                    
                                    item.assetSizeSpecs = itemAssetBoundsInfo
                                }
                                
                                itemsArray.append(item)
                                
                            }
                            
                            
                            
                        }
                    }

                    
                }
                
                return (itemsArray, nil)
                
            }
            else
            {
                //failure
                let genericErrorMsg = "Failed to fetch items. Please try again later."
                if let errorDict = responseObject!["Error"] as! NSDictionary!
                {
                    if let errorMessage = errorDict["Message"] as? String
                    {
                        return (nil, errorMessage)
                        
                    }
                    else
                    {
                        return (nil, genericErrorMsg)
                    }
                    
                }
                else
                {
                    return (nil, genericErrorMsg)
                }
                
                
            }
            
        }
        
        return (nil, nil)
    }

    
}

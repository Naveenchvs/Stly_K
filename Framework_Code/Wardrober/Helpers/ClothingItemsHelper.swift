//
//  ClothingItemsHelper.swift
//  Fashion180
//
//  Created by Yogi on 07/11/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//

import UIKit

class ClothingItemsHelper: NSObject {

    
    // MARK: - GetCatalogServiceV2
    
    class func getRequestDictForGetCatalogServiceV2(_ categoryID : String, customerID : String, startIndex : String, pageSize : String, secondaryItemsPageSize : String) -> Dictionary<String,String>{
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
        
        requestDict["ProductCategoryID"] = categoryID;
        
        requestDict["CustomerID"] = customerID  ///for isAddedToWardrobe Status

        requestDict["AssetSize"] = scaleSize
        
        requestDict["StartIndex"] = startIndex
        
        requestDict["PageSize"] = pageSize
        
        requestDict["SecoundaryPageSize"] = secondaryItemsPageSize

        
        return requestDict
    }
    
    
    class func parseFetchCatalogV2Response(_ responseObject:AnyObject?) -> (clothingItems : [ShoeItem]?, totalCount : Int?, errorString : String?)
    {
        let success = responseObject!["Success"] as! Bool
        
        let count = responseObject!["Count"] as! Int
        
        if  success == true
        {
            //success
            
            
            var totalItemsArray:[ShoeItem] = [ShoeItem]()
            
            if let resultArray = responseObject!["Results"] as! [NSDictionary]!
            {
                if resultArray.count > 0
                {
                    
                    for dict:NSDictionary  in resultArray
                    {
                        
                        var mainTopItem : ShoeItem! = nil
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
                                        itemAssetBoundsFront.xPos = self.getCGFloatFromString(x_pos)
                                    }
                                    else
                                    {
                                        itemAssetBoundsFront.xPos = nil
                                    }
                                    
                                    
                                    
                                    if let y_pos = assetFrontBoundsDict["Y"] as? String
                                    {
                                        itemAssetBoundsFront.yPos = self.getCGFloatFromString(y_pos)
                                    }
                                    else
                                    {
                                        itemAssetBoundsFront.yPos = nil
                                    }
                                    
                                    if let width = assetFrontBoundsDict["W"] as? String
                                    {
                                        itemAssetBoundsFront.width = self.getCGFloatFromString(width)

                                    }
                                    else
                                    {
                                        itemAssetBoundsFront.width = nil
                                    }
                                    
                                    if let height = assetFrontBoundsDict["H"] as? String
                                    {
                                                                            itemAssetBoundsFront.height = self.getCGFloatFromString(height)
                                    }
                                    else
                                    {
                                        itemAssetBoundsFront.height = nil
                                    }
                                    
                                    
                                    if let dotCenterX = assetFrontBoundsDict["DotX"] as? String
                                    {
                                        itemAssetBoundsFront.dotCenterX = self.getCGFloatFromString(dotCenterX)
                                    }
                                    else
                                    {
                                        itemAssetBoundsFront.dotCenterX = nil
                                    }
                                    
                                    if let dotCenterY = assetFrontBoundsDict["DotY"] as? String
                                    {
                                        itemAssetBoundsFront.dotCenterY = self.getCGFloatFromString(dotCenterY)
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
                                        itemAssetBoundsRear.xPos = self.getCGFloatFromString(x_pos)
                                    }
                                    else
                                    {
                                        itemAssetBoundsRear.xPos = nil
                                    }
                                    
                                    
                                    if let y_pos = assetRearBoundsDict["Y"] as? String
                                    {
                                        itemAssetBoundsRear.yPos = self.getCGFloatFromString(y_pos)
                                    }
                                    else
                                    {
                                        itemAssetBoundsRear.yPos = nil
                                    }
                                    
                                    
                                    if let width = assetRearBoundsDict["W"] as? String
                                    {
                                        itemAssetBoundsRear.width = self.getCGFloatFromString(width)

                                    }
                                    else
                                    {
                                        itemAssetBoundsRear.width = nil
                                    }
                                    
                                    if let height = assetRearBoundsDict["H"] as? String
                                    {
                                        itemAssetBoundsRear.height = self.getCGFloatFromString(height)

                                    }
                                    else
                                    {
                                       itemAssetBoundsRear.height = nil
                                    }
                                    
                                    if let dotCenterX = assetRearBoundsDict["DotX"] as? String
                                    {
                                        itemAssetBoundsRear.dotCenterX = self.getCGFloatFromString(dotCenterX)
                                    }
                                    else
                                    {
                                        itemAssetBoundsRear.dotCenterX = nil
                                    }
                                    
                                    if let dotCenterY = assetRearBoundsDict["DotY"] as? String
                                    {
                                        itemAssetBoundsRear.dotCenterY = self.getCGFloatFromString(dotCenterY)
                                    }
                                    else
                                    {
                                        itemAssetBoundsRear.dotCenterY = nil
                                    }
                                    
                                    
                                    
                                    itemAssetSpecs.assetBoundsRear = itemAssetBoundsRear
                                }
                                
                                let overridesDefaultZOrder = assetSpecsDict["OverrridesDefaultZOrder"] as! String
                                itemAssetSpecs.overridesDefaultZOrder = self.getBoolFromString(overridesDefaultZOrder)
                                
                                assetSizeSpecsArray.append(itemAssetSpecs)
                            }
                        }
                        
                        
                        
                        /// Main Top
                        if let TMArray = dict.object(forKey: "BottomProductItemDetailsinfo") as? NSArray
                        {
                            if TMArray.count > 0
                            {
                                mainTopItem = ShoeItem()
                                
                                let mainTopDict = TMArray[0] as! NSDictionary
                                
                                ///default main top Z order
                                mainTopItem.zOrder = 2

                                
                                if let productID = mainTopDict["ProductID"] as? String{
                                    
                                    mainTopItem.itemProductID = productID
                                }
                                if let productName = mainTopDict["ProductName"] as? String{
                                    
                                    mainTopItem.itemName = productName
                                }
                                else
                                {
                                    mainTopItem.itemName = ""
                                }
                                if let designerName = mainTopDict["DesignerName"] as? String{
                                    
                                    mainTopItem.designerName = designerName
                                }
                                else
                                {
                                    mainTopItem.designerName = ""
                                }
                                
                                if let bodyCategoryName = mainTopDict["ItemType"] as? String{
                                    
                                    mainTopItem.itemType = bodyCategoryName
                                }
                                else
                                {
                                    mainTopItem.itemType = ""
                                }
                                if let price = mainTopDict["Price"] as? String{
                                    
                                    mainTopItem.price = price
                                }
                                else
                                {
                                    mainTopItem.price = ""
                                }
                                
                                
                                if let options = mainTopDict["Options"] as? String{
                                    
                                    mainTopItem.itemOptions = options
                                }
                                else
                                {
                                    mainTopItem.itemOptions = ""
                                }
                                
                                
                                
                                //// Is Added to Wardrobe
                                if let isWardrobed = mainTopDict["IsWardobItem"] as? Int{
                                    
                                    mainTopItem.isAddedToWardrobe = self.getBoolFromString("\(isWardrobed)")
                                }
                                else
                                {
                                    mainTopItem.isAddedToWardrobe = false
                                }
                                
                                ////Earrings Count
                                if let totalEarringsCount = dict["TotalEarRingsCount"] as? String{
                                    
                                    mainTopItem.totalEarringsCount = self.getIntFromString(totalEarringsCount)
                                }
                                else
                                {
                                    mainTopItem.totalEarringsCount = 0
                                }
                                
                                ///Jacket Count
                                if let totalJacketsCount = dict["TotalJacketsRingsCount"] as? String{
                                    
                                    mainTopItem.totalJackectsCount = self.getIntFromString(totalJacketsCount)
                                }
                                else
                                {
                                    mainTopItem.totalJackectsCount = 0
                                }
                                
                                
                                ///Bottoms Count
                                if let totalBottomsCount = dict["TotalTopsCount"] as? String{
                                    
                                    mainTopItem.totalBottomsCount = self.getIntFromString(totalBottomsCount)
                                }
                                else
                                {
                                    mainTopItem.totalBottomsCount = 0
                                }
                                
                                
                                ///Shoes Count
                                if let totalShoesCount = dict["TotalShoesCount"] as? String{
                                    
                                    mainTopItem.totalShoesCount = self.getIntFromString(totalShoesCount)
                                }
                                else
                                {
                                    mainTopItem.totalShoesCount = 0
                                }

                                
                                
                                
                                mainTopItem.isPrimaryItem = true
                                mainTopItem.clothingType = ClothingType.bottom
                                
                                
                                let assets =   assetsArray.filter({ (itemAsset) -> Bool in
                                    
                                    return itemAsset.productID == mainTopItem.itemProductID
                                    
                                })
                                
                                if assets.count > 0
                                {
                                    let itemAsset = assets[0]
                                    mainTopItem.itemImageURL = itemAsset.assetUrl
                                    mainTopItem.rearItemImageURL = itemAsset.rearAssetUrl

                                }
                                
                                
                                let itemAssetSizeSpecs =   assetSizeSpecsArray.filter({ (itemAsset) -> Bool in
                                    
                                    return itemAsset.productID == mainTopItem.itemProductID
                                    
                                })
                                
                                if itemAssetSizeSpecs.count > 0
                                {
                                    let itemAssetBoundsInfo = itemAssetSizeSpecs[0]
                                    
                                    mainTopItem.assetSizeSpecs = itemAssetBoundsInfo
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
                                        
                                        item.isAddedToWardrobe = self.getBoolFromString("\(isWardrobed)")
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
                                        
                                        item.isAddedToWardrobe = self.getBoolFromString("\(isWardrobed)")
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
                        if let TSArray = dict.object(forKey: "TopProductItemDetailsinfo") as? NSArray
                        {
                            if TSArray.count > 0
                            {
                                for tsItemDict in (TSArray as? [[String:Any]])!
                                {
                                    let item = ShoeItem()
                                    
                                    ///default bottoms Z order
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
                                        
                                        item.isAddedToWardrobe = self.getBoolFromString("\(isWardrobed)")
                                    }
                                    else
                                    {
                                        item.isAddedToWardrobe = false
                                    }
                                    

                                    
                                    item.isPrimaryItem = false
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
                                        
                                        item.isAddedToWardrobe = self.getBoolFromString("\(isWardrobed)")
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
                        
                        mainTopItem.topSecArray = secTopArray
                        mainTopItem.earringsArray = earringsArray
                        mainTopItem.bottomsArray = bottomsArray
                        mainTopItem.shoesArray = shoesArray
                        
                        
                        
                        
                        totalItemsArray.append(mainTopItem)
                        
                        
                    }
                }
                
                
                
                return (totalItemsArray, count, nil)
                
            }
            else
            {
                //failure
                let genericErrorMsg = "Failed to fetch items. Please try again later."
                if let errorDict = responseObject!["Error"] as! NSDictionary!
                {
                    if let errorMessage = errorDict["Message"] as? String
                    {
                        return (nil, nil, errorMessage)
                        
                    }
                    else
                    {
                        return (nil, nil, genericErrorMsg)
                    }
                    
                }
                else
                {
                    return (nil, nil, genericErrorMsg)
                }
                
                
            }
            
        }
        
        return (nil, nil, nil)
    }

    
    
    // MARK: - Get More Secondary Items
    
    class func getRequestDictForFetchMoreSecondaryItems(_ mainTopID : String, customerID : String, startIndex : String, pageSize : String) -> Dictionary<String,String>{
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
        
//        "ProductTopItemID":"String content",
//        "CustomerID":"String content",
//        "StartIndex":2147483647,
//        "PageSize":2147483647,
//        "AssetSize":2147483647
        
        requestDict["ProductTopItemID"] = mainTopID;
        
        requestDict["CustomerID"] = customerID  ///for isAddedToWardrobe Status
        
        requestDict["AssetSize"] = scaleSize
        
        requestDict["StartIndex"] = startIndex
        
        requestDict["PageSize"] = pageSize
        
        
        return requestDict
    }
    
    
    // MARK: - Parse More Secondary Items Response
    class func parseFetchMoreSecondaryItemsResponse(_ responseObject:AnyObject?, forItemType itemType: ClothingType) -> (clothingItems : [ShoeItem]?, mainTopItemID : String?, errorString : String?)
    {
        let success = responseObject!["Success"] as! Bool
        
        var mainTopID : String!
        
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
                            
                            [assetsArray.append(itemAssetImage)]
                            
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
                                    itemAssetBoundsFront.xPos = self.getCGFloatFromString(x_pos)
                                }
                                else
                                {
                                    itemAssetBoundsFront.xPos = nil
                                }
                                
                                
                                
                                if let y_pos = assetFrontBoundsDict["Y"] as? String
                                {
                                    itemAssetBoundsFront.yPos = self.getCGFloatFromString(y_pos)
                                }
                                else
                                {
                                    itemAssetBoundsFront.yPos = nil
                                }
                                
                                if let width = assetFrontBoundsDict["W"] as? String
                                {
                                    itemAssetBoundsFront.width = self.getCGFloatFromString(width)
                                    
                                }
                                else
                                {
                                    itemAssetBoundsFront.width = nil
                                }
                                
                                if let height = assetFrontBoundsDict["H"] as? String
                                {
                                    itemAssetBoundsFront.height = self.getCGFloatFromString(height)
                                }
                                else
                                {
                                    itemAssetBoundsFront.height = nil
                                }
                                
                                
                                if let dotCenterX = assetFrontBoundsDict["DotX"] as? String
                                {
                                    itemAssetBoundsFront.dotCenterX = self.getCGFloatFromString(dotCenterX)
                                }
                                else
                                {
                                    itemAssetBoundsFront.dotCenterX = nil
                                }
                                
                                if let dotCenterY = assetFrontBoundsDict["DotY"] as? String
                                {
                                    itemAssetBoundsFront.dotCenterY = self.getCGFloatFromString(dotCenterY)
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
                                    itemAssetBoundsRear.xPos = self.getCGFloatFromString(x_pos)
                                }
                                else
                                {
                                    itemAssetBoundsRear.xPos = nil
                                }
                                
                                
                                if let y_pos = assetRearBoundsDict["Y"] as? String
                                {
                                    itemAssetBoundsRear.yPos = self.getCGFloatFromString(y_pos)
                                }
                                else
                                {
                                    itemAssetBoundsRear.yPos = nil
                                }
                                
                                
                                if let width = assetRearBoundsDict["W"] as? String
                                {
                                    itemAssetBoundsRear.width = self.getCGFloatFromString(width)
                                    
                                }
                                else
                                {
                                    itemAssetBoundsRear.width = nil
                                }
                                
                                if let height = assetRearBoundsDict["H"] as? String
                                {
                                    itemAssetBoundsRear.height = self.getCGFloatFromString(height)
                                    
                                }
                                else
                                {
                                    itemAssetBoundsRear.height = nil
                                }
                                
                                if let dotCenterX = assetRearBoundsDict["DotX"] as? String
                                {
                                    itemAssetBoundsRear.dotCenterX = self.getCGFloatFromString(dotCenterX)
                                }
                                else
                                {
                                    itemAssetBoundsRear.dotCenterX = nil
                                }
                                
                                if let dotCenterY = assetRearBoundsDict["DotY"] as? String
                                {
                                    itemAssetBoundsRear.dotCenterY = self.getCGFloatFromString(dotCenterY)
                                }
                                else
                                {
                                    itemAssetBoundsRear.dotCenterY = nil
                                }
                                
                                itemAssetSpecs.assetBoundsRear = itemAssetBoundsRear
                            }
                            
                            let overridesDefaultZOrder = assetSpecsDict["OverrridesDefaultZOrder"] as! String
                            itemAssetSpecs.overridesDefaultZOrder = self.getBoolFromString(overridesDefaultZOrder)
                            
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
                                    
                                    item.isAddedToWardrobe = self.getBoolFromString("\(isWardrobed)")
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

                    
                    ///main top item id
                    if let mainTopItemID = dict?.object(forKey: "ProductTopItemID") as? String
                    {
                        mainTopID = mainTopItemID
                    }
                    
                }
                
                return (itemsArray, mainTopID, nil)
                
            }
            else
            {
                //failure
                let genericErrorMsg = "Failed to fetch items. Please try again later."
                if let errorDict = responseObject!["Error"] as! NSDictionary!
                {
                    if let errorMessage = errorDict["Message"] as? String
                    {
                        return (nil, nil, errorMessage)
                        
                    }
                    else
                    {
                        return (nil, nil, genericErrorMsg)
                    }
                    
                }
                else
                {
                    return (nil, nil, genericErrorMsg)
                }
                
                
            }
            
        }
        
        return (nil, nil, nil)
    }
    
    
    
    
    

    // MARK: - GetCatalogService version 1
    class func getRequestDictForGetCatalogService(_ categoryID : String, startIndex : String, pageSize : String) -> Dictionary<String,String>{
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
        
        requestDict["ProductCategoryID"] = categoryID;

        requestDict["AssetSize"] = scaleSize

        requestDict["StartIndex"] = startIndex

        requestDict["PageSize"] = pageSize

        return requestDict
    }
    
    
    class func parseFetchCatalogResponse(_ responseObject:AnyObject?) -> (clothingItems : [ShoeItem]?, totalCount : Int?, errorString : String?)
    {
        let success = responseObject!["Success"] as! Bool
        
        let count = responseObject!["Count"] as! Int
        
        if  success == true
        {
            //success
            

            var totalItemsArray:[ShoeItem] = [ShoeItem]()
            
            if let resultArray = responseObject!["Results"] as! [NSDictionary]!
            {
                if resultArray.count > 0
                {
                    
                    for dict:NSDictionary  in resultArray
                    {

                        
                        var mainTopItem : ShoeItem! = nil
                        var secTopArray = [ShoeItem]()
                        var earringsArray = [ShoeItem]()
                        var bottomsArray = [ShoeItem]()
                        var shoesArray = [ShoeItem]()
                        
                        var assetsArray = [ItemAssetImage]()
                        var stylesArray = [ClothingStyle]()

                        
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
                                if let assetSize = assetDict["AssetSize"] as? String{
                                    
                                    itemAssetImage.assetSize = assetSize
                                }
                                
                                [assetsArray.append(itemAssetImage)]
                                
                            }
                        }
                        
                        
                        
                        /// Clothing Styles
                        if let stylArray = dict.object(forKey: "StylesMap") as? NSArray
                        {
                            for styleDict in (stylArray as? [[String:Any]])!
                            {
                                let clothingStyle = ClothingStyle()
                                
                                if let tm_id = styleDict["TM_ID"] as? String{
                                    
                                    clothingStyle.TopMain_ID  = tm_id
                                    if tm_id == ""
                                    {
                                        clothingStyle.TopMain_ID  = "0"

                                    }
                                }
                                if let ts_id = styleDict["TS_ID"] as? String{
                                    
                                    clothingStyle.TopSec_ID  = ts_id
                                    if ts_id == ""
                                    {
                                        clothingStyle.TopSec_ID  = "0"
                                        
                                    }
                                }
                                if let er_id = styleDict["ER_ID"] as? String{
                                    
                                    clothingStyle.Earrings_ID  = er_id
                                    if er_id == ""
                                    {
                                        clothingStyle.Earrings_ID  = "0"
                                        
                                    }
                                }
                                if let bt_id = styleDict["BT_ID"] as? String{
                                    
                                    clothingStyle.Bottom_ID  = bt_id
                                    if bt_id == ""
                                    {
                                        clothingStyle.Bottom_ID  = "0"
                                        
                                    }
                                }
                                if let sh_id = styleDict["SH_ID"] as? String{
                                    
                                    clothingStyle.Shoes_ID  = sh_id
                                    if sh_id == ""
                                    {
                                        clothingStyle.Shoes_ID  = "0"
                                        
                                    }
                                }
                                
                                
                                
                                ///TM_specs
                                var assetSpecs = ItemAssetSpecs()
                                if let specsArray = (styleDict as AnyObject).object(forKey: "TM") as? NSArray
                                {

                                    if specsArray.count > 0
                                    {
                                        
                                        let assetSpecsDict = specsArray[0] as! NSDictionary
                                        

                                        let x_pos = assetSpecsDict["X"] as! String
                                        assetSpecs.xPos = self.getCGFloatFromString(x_pos)
                                        
                                        let y_pos = assetSpecsDict["Y"] as! String
                                        assetSpecs.yPos = self.getCGFloatFromString(y_pos)
                                        
                                        let width = assetSpecsDict["W"] as! String
                                        assetSpecs.width = self.getCGFloatFromString(width)
                                        
                                        let height = assetSpecsDict["H"] as! String
                                        assetSpecs.height = self.getCGFloatFromString(height)
                                        
                                        let zOrder = assetSpecsDict["Z"] as! String
                                        assetSpecs.zOrder = self.getIntFromString(zOrder)
                                        
                                    }
                                    
                                }
                                clothingStyle.TopMain_Specs = assetSpecs
                                
                                
                                ///TS_specs
                                assetSpecs = ItemAssetSpecs()
                                if let specsArray = (styleDict as AnyObject).object(forKey: "TS") as? NSArray
                                {
                                    
                                    if specsArray.count > 0
                                    {
                                        
                                        let assetSpecsDict = specsArray[0] as! NSDictionary
                                        
                                        
                                        let x_pos = assetSpecsDict["X"] as! String
                                        assetSpecs.xPos = self.getCGFloatFromString(x_pos)
                                        
                                        let y_pos = assetSpecsDict["Y"] as! String
                                        assetSpecs.yPos = self.getCGFloatFromString(y_pos)
                                        
                                        let width = assetSpecsDict["W"] as! String
                                        assetSpecs.width = self.getCGFloatFromString(width)
                                        
                                        let height = assetSpecsDict["H"] as! String
                                        assetSpecs.height = self.getCGFloatFromString(height)
                                        
                                        let zOrder = assetSpecsDict["Z"] as! String
                                        assetSpecs.zOrder = self.getIntFromString(zOrder)
                                        
                                    }
                                    
                                }
                                clothingStyle.TopSec_Specs = assetSpecs
                                
                                
                                ///ER_specs
                                assetSpecs = ItemAssetSpecs()
                                if let specsArray = (styleDict as AnyObject).object(forKey: "ER") as? NSArray
                                {
                                    
                                    if specsArray.count > 0
                                    {
                                        
                                        let assetSpecsDict = specsArray[0] as! NSDictionary
                                        
                                        
                                        let x_pos = assetSpecsDict["X"] as! String
                                        assetSpecs.xPos = self.getCGFloatFromString(x_pos)
                                        
                                        let y_pos = assetSpecsDict["Y"] as! String
                                        assetSpecs.yPos = self.getCGFloatFromString(y_pos)
                                        
                                        let width = assetSpecsDict["W"] as! String
                                        assetSpecs.width = self.getCGFloatFromString(width)
                                        
                                        let height = assetSpecsDict["H"] as! String
                                        assetSpecs.height = self.getCGFloatFromString(height)
                                        
                                        let zOrder = assetSpecsDict["Z"] as! String
                                        assetSpecs.zOrder = self.getIntFromString(zOrder)
                                        
                                    }
                                    
                                }
                                clothingStyle.Earrings_Specs = assetSpecs
                                
                                
                                
                                ///BT_specs
                                assetSpecs = ItemAssetSpecs()
                                if let specsArray = (styleDict as AnyObject).object(forKey: "BT") as? NSArray
                                {
                                    
                                    if specsArray.count > 0
                                    {
                                        
                                        let assetSpecsDict = specsArray[0] as! NSDictionary
                                        
                                        
                                        let x_pos = assetSpecsDict["X"] as! String
                                        assetSpecs.xPos = self.getCGFloatFromString(x_pos)
                                        
                                        let y_pos = assetSpecsDict["Y"] as! String
                                        assetSpecs.yPos = self.getCGFloatFromString(y_pos)
                                        
                                        let width = assetSpecsDict["W"] as! String
                                        assetSpecs.width = self.getCGFloatFromString(width)
                                        
                                        let height = assetSpecsDict["H"] as! String
                                        assetSpecs.height = self.getCGFloatFromString(height)
                                        
                                        let zOrder = assetSpecsDict["Z"] as! String
                                        assetSpecs.zOrder = self.getIntFromString(zOrder)
                                        
                                    }
                                    
                                }
                                clothingStyle.Bottom_Specs = assetSpecs
                                
                                
                                
                                ///SH_specs
                                assetSpecs = ItemAssetSpecs()
                                if let specsArray = (styleDict as AnyObject).object(forKey: "SH") as? NSArray
                                {
                                    
                                    if specsArray.count > 0
                                    {
                                        
                                        let assetSpecsDict = specsArray[0] as! NSDictionary
                                        
                                        
                                        let x_pos = assetSpecsDict["X"] as! String
                                        assetSpecs.xPos = self.getCGFloatFromString(x_pos)
                                        
                                        let y_pos = assetSpecsDict["Y"] as! String
                                        assetSpecs.yPos = self.getCGFloatFromString(y_pos)
                                        
                                        let width = assetSpecsDict["W"] as! String
                                        assetSpecs.width = self.getCGFloatFromString(width)
                                        
                                        let height = assetSpecsDict["H"] as! String
                                        assetSpecs.height = self.getCGFloatFromString(height)
                                        
                                        let zOrder = assetSpecsDict["Z"] as! String
                                        assetSpecs.zOrder = self.getIntFromString(zOrder)
                                        
                                    }
                                    
                                }
                                clothingStyle.Shoes_Specs = assetSpecs
                                
                                
                                
                                stylesArray.append(clothingStyle)
                                
                            }
                        }
                        
                        
                        /// Main Top
                        if let TMArray = dict.object(forKey: "TopProductItemDetailsinfo") as? NSArray
                        {
                            if TMArray.count > 0
                            {
                                mainTopItem = ShoeItem()

                                let mainTopDict = TMArray[0] as! NSDictionary
                                
                                
                                if let productID = mainTopDict["ProductID"] as? String{
                                    
                                    mainTopItem.itemProductID = productID
                                }
                                if let productName = mainTopDict["ProductName"] as? String{
                                    
                                    mainTopItem.itemName = productName
                                }
                                else
                                {
                                    mainTopItem.itemName = ""
                                }
                                if let designerName = mainTopDict["DesignerName"] as? String{
                                    
                                    mainTopItem.designerName = designerName
                                }
                                else
                                {
                                    mainTopItem.designerName = ""
                                }
                                
                                if let bodyCategoryName = mainTopDict["ItemType"] as? String{
                                    
                                    mainTopItem.itemType = bodyCategoryName
                                }
                                else
                                {
                                    mainTopItem.itemType = ""
                                }
                                if let price = mainTopDict["Price"] as? String{
                                    
                                    mainTopItem.price = price
                                }
                                else
                                {
                                    mainTopItem.price = ""
                                }
                                
                                
                                if let options = mainTopDict["Options"] as? String{
                                    
                                    mainTopItem.itemOptions = options
                                }
                                else
                                {
                                    mainTopItem.itemOptions = ""
                                }

                                
                                mainTopItem.isPrimaryItem = true
                                mainTopItem.clothingType = ClothingType.top_MAIN
                                
                                
                                let assets =   assetsArray.filter({ (itemAsset) -> Bool in
                                    
                                    return itemAsset.productID == mainTopItem.itemProductID
                                    
                                })
                                
                                if assets.count > 0
                                {
                                    let itemAsset = assets[0]
                                    mainTopItem.itemImageURL = itemAsset.assetUrl
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
                                    
                                    
                                    item.isPrimaryItem = false
                                    item.clothingType = ClothingType.top_SECONDARY
                                   
                                    let assets =   assetsArray.filter({ (itemAsset) -> Bool in
                                        
                                        return itemAsset.productID == item.itemProductID
                                        
                                    })
                                    
                                    if assets.count > 0
                                    {
                                        let itemAsset = assets[0]
                                        item.itemImageURL = itemAsset.assetUrl
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
                                    
                                    
                                    item.isPrimaryItem = false
                                    item.clothingType = ClothingType.earrings
                                    
                                    
                                    let assets =   assetsArray.filter({ (itemAsset) -> Bool in
                                        
                                        return itemAsset.productID == item.itemProductID
                                        
                                    })
                                    
                                    if assets.count > 0
                                    {
                                        let itemAsset = assets[0]
                                        item.itemImageURL = itemAsset.assetUrl
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
                                    
                                    
                                    item.isPrimaryItem = false
                                    item.clothingType = ClothingType.bottom
                                    
                                    
                                    let assets =   assetsArray.filter({ (itemAsset) -> Bool in
                                        
                                        return itemAsset.productID == item.itemProductID
                                        
                                    })
                                    
                                    if assets.count > 0
                                    {
                                        let itemAsset = assets[0]
                                        item.itemImageURL = itemAsset.assetUrl
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
                                    
                                    
                                    item.isPrimaryItem = false
                                    item.clothingType = ClothingType.shoes
                                    
                                    
                                    let assets =   assetsArray.filter({ (itemAsset) -> Bool in
                                        
                                        return itemAsset.productID == item.itemProductID
                                        
                                    })
                                    
                                    if assets.count > 0
                                    {
                                        let itemAsset = assets[0]
                                        item.itemImageURL = itemAsset.assetUrl
                                    }
                                    
                                    
                                    shoesArray.append(item)
                                    
                                }
                                
                                
                                
                            }
                        }
                        
                        mainTopItem.topSecArray = secTopArray
                        mainTopItem.earringsArray = earringsArray
                        mainTopItem.bottomsArray = bottomsArray
                        mainTopItem.shoesArray = shoesArray
                        mainTopItem.clothingStyles = stylesArray
                        
                        
                        totalItemsArray.append(mainTopItem)

                        
                    }
                }
            
            
            
            return (totalItemsArray, count, nil)
            
            }
            else
            {
                //failure
                let genericErrorMsg = "Failed to fetch items. Please try again later."
                if let errorDict = responseObject!["Error"] as! NSDictionary!
                {
                    if let errorMessage = errorDict["Message"] as? String
                    {
                        return (nil, nil, errorMessage)
                        
                    }
                    else
                    {
                        return (nil, nil, genericErrorMsg)
                    }
                    
                }
                else
                {
                    return (nil, nil, genericErrorMsg)
                }
                
                
            }
        
        }
        
        return (nil, nil, nil)
    }
    
    
    // MARK: - GetCatalog Local Data
    class func getClothingItems() -> [ShoeItem]!
    {
        
        ///SHOES
        
        var shoesArray = [ShoeItem]()
        
        //Shoes 1
        var shoeItem = ShoeItem()
        shoeItem.itemProductID = "11"
        shoeItem.itemName = "White Sneaker"
        shoeItem.itemType = "Shoes"
        shoeItem.itemImageName = "shoes - white sneakers"
        shoeItem.designerName = "Designer 2"
        shoeItem.price = "$11"
        shoeItem.itemDescription = "70% Triacetate. 30% polyester,Thin straps. V-neck and scoop back. Darting at bust. Hi-low back,Nude Color,Made in U.S.A.,Dry Clean"
        shoeItem.isPrimaryItem = false
        
        var itemSizes = [ItemSize]()
        
        var itemSize = ItemSize()
        itemSize.itemSizeName = "2.5"
        itemSize.itemAvailability = 29
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "3.5"
        itemSize.itemAvailability = 2
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "4"
        itemSize.itemAvailability = 0
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "4.5"
        itemSize.itemAvailability = 34
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "5.5"
        itemSize.itemAvailability = 29
        itemSizes.append(itemSize)
        
        shoeItem.itemSizes = itemSizes
        
        shoeItem.clothingType = ClothingType.shoes
        
        shoesArray.append(shoeItem)
        
        
        //Shoes 2
        shoeItem = ShoeItem()
        shoeItem.itemProductID = "22"
        shoeItem.itemName = "Black Heels"
        shoeItem.itemType = "Shoes"
        shoeItem.itemImageName = "shoes - black heels"
        shoeItem.designerName = "Designer 2"
        shoeItem.price = "$22"
        shoeItem.itemDescription = "70% Triacetate. 30% polyester,Thin straps. V-neck and scoop back. Darting at bust. Hi-low back,Nude Color,Made in U.S.A.,Dry Clean"
        shoeItem.isPrimaryItem = false
        
        itemSizes = [ItemSize]()
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "2.5"
        itemSize.itemAvailability = 29
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "3.5"
        itemSize.itemAvailability = 2
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "4"
        itemSize.itemAvailability = 0
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "4.5"
        itemSize.itemAvailability = 34
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "5.5"
        itemSize.itemAvailability = 29
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "6.5"
        itemSize.itemAvailability = 29
        itemSizes.append(itemSize)
        
        shoeItem.itemSizes = itemSizes
        
        shoeItem.clothingType = ClothingType.shoes
        
        shoesArray.append(shoeItem)
        
        
        //Shoes 3
        shoeItem = ShoeItem()
        shoeItem.itemProductID = "33"
        shoeItem.itemName = "Black Boots"
        shoeItem.itemType = "Shoes"
        shoeItem.itemImageName = "shoes - black boots"
        shoeItem.designerName = "Designer 2"
        shoeItem.price = "$33"
        shoeItem.itemDescription = "70% Triacetate. 30% polyester,Thin straps. V-neck and scoop back. Darting at bust. Hi-low back,Nude Color,Made in U.S.A.,Dry Clean"
        shoeItem.isPrimaryItem = false
        
        itemSizes = [ItemSize]()
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "2.5"
        itemSize.itemAvailability = 29
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "3.5"
        itemSize.itemAvailability = 2
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "4"
        itemSize.itemAvailability = 0
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "4.5"
        itemSize.itemAvailability = 34
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "5.5"
        itemSize.itemAvailability = 29
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "6.5"
        itemSize.itemAvailability = 29
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "7.0"
        itemSize.itemAvailability = 0
        itemSizes.append(itemSize)
        
        shoeItem.itemSizes = itemSizes
        
        shoeItem.clothingType = ClothingType.shoes
        
        shoesArray.append(shoeItem)
        

        
        ///SHOES
//        var shoeItem = ShoeItem()
//        shoeItem.itemName = "sneakers"
//        shoeItem.itemImageName = "shoes - white sneakers"
//        shoeItem.xPosition = 48
//        shoeItem.yPosition = 511
//        shoeItem.width = 123
//        shoeItem.height = 78
//        shoeItem.zOrder =  1
//        shoeItem.clothingType = ClothingType.SHOES
//        shoeArray.append(shoeItem)
        
        
//        shoeItem = ShoeItem()
//        shoeItem.itemName = "tan-boots"
//        shoeItem.itemImageName = "shoes - black heels"
//        shoeItem.xPosition = 54
//        shoeItem.yPosition = 500
//        shoeItem.width = 113
//        shoeItem.height = 96
//        shoeItem.zOrder =  1
//        shoeItem.clothingType = ClothingType.SHOES
//        shoeArray.append(shoeItem)
        
//        shoeItem = ShoeItem()
//        shoeItem.itemName = "black-boots"
//        shoeItem.itemImageName = "shoes - black boots"
//        shoeItem.xPosition = 46
//        shoeItem.yPosition = 374
//        shoeItem.width = 122
//        shoeItem.height = 221
//        shoeItem.zOrder =  2
//        shoeItem.clothingType = ClothingType.SHOES
//        shoeArray.append(shoeItem)
        
        
        
        ///EARRINGS
        
        var earringsArray = [ShoeItem]()
        
        //ER 1
        shoeItem = ShoeItem()
        shoeItem.itemProductID = "111"
        shoeItem.itemName = "Earrings1"
        shoeItem.itemType = "Earrings"
        shoeItem.itemImageName = "accessories - earrings1"
        shoeItem.designerName = "Designer 3"
        shoeItem.price = "$111"
        shoeItem.itemDescription = "70% Triacetate. 30% polyester,Thin straps. V-neck and scoop back. Darting at bust. Hi-low back,Nude Color,Made in U.S.A.,Dry Clean"
        shoeItem.isPrimaryItem = false
        
        itemSizes = [ItemSize]()
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "S"
        itemSize.itemAvailability = 29
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "M"
        itemSize.itemAvailability = 2
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "O/S"
        itemSize.itemAvailability = 0
        itemSizes.append(itemSize)
        
        
        shoeItem.itemSizes = itemSizes
        
        shoeItem.clothingType = ClothingType.earrings
        
        earringsArray.append(shoeItem)
        
        
        //ER 2
        shoeItem = ShoeItem()
        shoeItem.itemProductID = "222"
        shoeItem.itemName = "Earrings2"
        shoeItem.itemType = "Earrings"
        shoeItem.itemImageName = "accessories - earrings2"
        shoeItem.designerName = "Designer 3"
        shoeItem.price = "$222"
        shoeItem.itemDescription = "70% Triacetate. 30% polyester,Thin straps. V-neck and scoop back. Darting at bust. Hi-low back,Nude Color,Made in U.S.A.,Dry Clean"
        shoeItem.isPrimaryItem = false
        
        itemSizes = [ItemSize]()
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "S"
        itemSize.itemAvailability = 0
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "M"
        itemSize.itemAvailability = 2
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "O/S"
        itemSize.itemAvailability = 2
        itemSizes.append(itemSize)
        
        
        shoeItem.itemSizes = itemSizes
        
        shoeItem.clothingType = ClothingType.earrings
        
        earringsArray.append(shoeItem)
        
        
        
        //ER 3
        shoeItem = ShoeItem()
        shoeItem.itemProductID = "333"
        shoeItem.itemName = "Earrings3"
        shoeItem.itemType = "Earrings"
        shoeItem.itemImageName = "accessories - earrings3"
        shoeItem.designerName = "Designer 4"
        shoeItem.price = "$333"
        shoeItem.itemDescription = "70% Triacetate. 30% polyester,Thin straps. V-neck and scoop back. Darting at bust. Hi-low back,Nude Color,Made in U.S.A.,Dry Clean"
        shoeItem.isPrimaryItem = false
        
        itemSizes = [ItemSize]()
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "S"
        itemSize.itemAvailability = 0
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "M"
        itemSize.itemAvailability = 2
        itemSizes.append(itemSize)
        
        
        shoeItem.itemSizes = itemSizes
        
        shoeItem.clothingType = ClothingType.earrings
        
        earringsArray.append(shoeItem)
        
        
        
        ///EARRINGS
//        shoeItem = ShoeItem()
//        shoeItem.itemName = "sneakers"
//        shoeItem.itemImageName = "accessories - earrings1"
//        shoeItem.xPosition = 57
//        shoeItem.yPosition = 45
//        shoeItem.width = 63
//        shoeItem.height = 21
//        shoeItem.zOrder =  1
//        shoeItem.clothingType = ClothingType.EARRINGS
//        earringsArray.append(shoeItem)
        
        
//        shoeItem = ShoeItem()
//        shoeItem.itemName = "tan-boots"
//        shoeItem.itemImageName = "accessories - earrings2"
//        shoeItem.xPosition = 60
//        shoeItem.yPosition = 47
//        shoeItem.width = 58
//        shoeItem.height = 12
//        shoeItem.zOrder =  1
//        shoeItem.clothingType = ClothingType.EARRINGS
//        earringsArray.append(shoeItem)
        
//        shoeItem = ShoeItem()
//        shoeItem.itemName = "black-boots"
//        shoeItem.itemImageName = "accessories - earrings3"
//        shoeItem.xPosition = 60
//        shoeItem.yPosition = 47
//        shoeItem.width = 57
//        shoeItem.height = 12
//        shoeItem.zOrder =  1
//        shoeItem.clothingType = ClothingType.EARRINGS
//        earringsArray.append(shoeItem)
        
        
        
        ///TOP SECONDARY
        
        var topSecsArray = [ShoeItem]()
        
        //TS 1
        shoeItem = ShoeItem()
        shoeItem.itemProductID = "1111"
        shoeItem.itemName = "Jacket Black"
        shoeItem.itemType = "Jacket"
        shoeItem.itemImageName = "jacket - black"
        shoeItem.designerName = "Designer 3"
        shoeItem.price = "$100"
        shoeItem.itemDescription = "70% Triacetate. 30% polyester,Thin straps. V-neck and scoop back. Darting at bust. Hi-low back,Nude Color,Made in U.S.A.,Dry Clean"
        shoeItem.isPrimaryItem = false
        
        itemSizes = [ItemSize]()
        

        itemSize = ItemSize()
        itemSize.itemSizeName = "M"
        itemSize.itemAvailability = 2
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "L"
        itemSize.itemAvailability = 0
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "XL"
        itemSize.itemAvailability = 0
        itemSizes.append(itemSize)
        
        
        shoeItem.itemSizes = itemSizes
        
        shoeItem.clothingType = ClothingType.top_SECONDARY
        
        topSecsArray.append(shoeItem)
        
        
        
        //TS 2
        shoeItem = ShoeItem()
        shoeItem.itemProductID = "2222"
        shoeItem.itemName = "Jacket Olive"
        shoeItem.itemType = "Jacket"
        shoeItem.itemImageName = "jacket - olive"
        shoeItem.designerName = "Designer 3"
        shoeItem.price = "$200"
        shoeItem.itemDescription = "70% Triacetate. 30% polyester,Thin straps. V-neck and scoop back. Darting at bust. Hi-low back,Nude Color,Made in U.S.A.,Dry Clean"
        shoeItem.isPrimaryItem = false
        
        itemSizes = [ItemSize]()
        
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "M"
        itemSize.itemAvailability = 2
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "L"
        itemSize.itemAvailability = 0
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "XL"
        itemSize.itemAvailability = 0
        itemSizes.append(itemSize)
        
        
        shoeItem.itemSizes = itemSizes
        
        shoeItem.clothingType = ClothingType.top_SECONDARY
        
        topSecsArray.append(shoeItem)
        
        
        
    
        
        
        ///TOP SECONDARY
//        shoeItem = ShoeItem()
//        shoeItem.itemName = "sneakers"
//        shoeItem.itemImageName = "jacket - black"
//        shoeItem.xPosition = 2
//        shoeItem.yPosition = 80
//        shoeItem.width = 164
//        shoeItem.height = 222
//        shoeItem.zOrder =  3
//        shoeItem.clothingType = ClothingType.TOP_SECONDARY
//        topsSecArray.append(shoeItem)
        
//        shoeItem = ShoeItem()
//        shoeItem.itemName = "tan-boots"
//        shoeItem.itemImageName = "jacket - olive"
//        shoeItem.xPosition = 4
//        shoeItem.yPosition = 78
//        shoeItem.width = 164
//        shoeItem.height = 222
//        shoeItem.zOrder =  3
//        shoeItem.clothingType = ClothingType.TOP_SECONDARY
//        topsSecArray.append(shoeItem)
        
        
        
        ///BOTTOMS
        
        var bottomsArray = [ShoeItem]()
        
        //BT 1
        shoeItem = ShoeItem()
        shoeItem.itemProductID = "101"
        shoeItem.itemName = "White Jeans"
        shoeItem.itemType = "Pants"
        shoeItem.itemImageName = "pants - white jeans"
        shoeItem.designerName = "Designer 3"
        shoeItem.price = "$101"
        shoeItem.itemDescription = "70% Triacetate. 30% polyester,Thin straps. V-neck and scoop back. Darting at bust. Hi-low back,Nude Color,Made in U.S.A.,Dry Clean"
        shoeItem.isPrimaryItem = false
        
        itemSizes = [ItemSize]()
        
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "S"
        itemSize.itemAvailability = 5
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "M"
        itemSize.itemAvailability = 2
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "L"
        itemSize.itemAvailability = 29
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "XL"
        itemSize.itemAvailability = 4
        itemSizes.append(itemSize)
        
        
        shoeItem.itemSizes = itemSizes
        
        shoeItem.clothingType = ClothingType.bottom
        
        bottomsArray.append(shoeItem)
        
        
        
        
        //BT 2
        shoeItem = ShoeItem()
        shoeItem.itemProductID = "202"
        shoeItem.itemName = "Black Skirt"
        shoeItem.itemType = "Skirt"
        shoeItem.itemImageName = "skirt - black"
        shoeItem.designerName = "Designer 4"
        shoeItem.price = "$202"
        shoeItem.itemDescription = "70% Triacetate. 30% polyester,Thin straps. V-neck and scoop back. Darting at bust. Hi-low back,Nude Color,Made in U.S.A.,Dry Clean"
        shoeItem.isPrimaryItem = false
        
        itemSizes = [ItemSize]()
        
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "S"
        itemSize.itemAvailability = 5
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "M"
        itemSize.itemAvailability = 2
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "L"
        itemSize.itemAvailability = 29
        itemSizes.append(itemSize)
        

        
        shoeItem.itemSizes = itemSizes
        
        shoeItem.clothingType = ClothingType.bottom
        
        bottomsArray.append(shoeItem)
        
        
        
        
        //BT 3
        shoeItem = ShoeItem()
        shoeItem.itemProductID = "303"
        shoeItem.itemName = "White Skirt"
        shoeItem.itemType = "Skirt"
        shoeItem.itemImageName = "skirt - white"
        shoeItem.designerName = "Designer 4"
        shoeItem.price = "$303"
        shoeItem.itemDescription = "70% Triacetate. 30% polyester,Thin straps. V-neck and scoop back. Darting at bust. Hi-low back,Nude Color,Made in U.S.A.,Dry Clean"
        shoeItem.isPrimaryItem = false
        
        itemSizes = [ItemSize]()
        
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "S"
        itemSize.itemAvailability = 5
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "M"
        itemSize.itemAvailability = 2
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "L"
        itemSize.itemAvailability = 29
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "XL"
        itemSize.itemAvailability = 0
        itemSizes.append(itemSize)
        
        
        shoeItem.itemSizes = itemSizes
        
        shoeItem.clothingType = ClothingType.bottom
        
        bottomsArray.append(shoeItem)
        
        ///BOTTOMS
//        shoeItem = ShoeItem()
//        shoeItem.itemName = "sneakers"
//        shoeItem.itemImageName = "pants - white jeans"
//        shoeItem.xPosition = 29
//        shoeItem.yPosition = 239
//        shoeItem.width = 131
//        shoeItem.height = 289
//        shoeItem.zOrder =  1
//        shoeItem.clothingType = ClothingType.BOTTOM
//        bottomsArray.append(shoeItem)
        
//        shoeItem = ShoeItem()
//        shoeItem.itemName = "tan-boots"
//        shoeItem.itemImageName = "skirt - black"
//        shoeItem.xPosition = 11
//        shoeItem.yPosition = 247
//        shoeItem.width = 147
//        shoeItem.height = 139
//        shoeItem.zOrder =  1
//        shoeItem.clothingType = ClothingType.BOTTOM
//        bottomsArray.append(shoeItem)
        
//        shoeItem = ShoeItem()
//        shoeItem.itemName = "tan-boots"
//        shoeItem.itemImageName = "skirt - white"
//        shoeItem.xPosition = 27
//        shoeItem.yPosition = 219
//        shoeItem.width = 118
//        shoeItem.height = 130
//        shoeItem.zOrder =  1
//        shoeItem.clothingType = ClothingType.BOTTOM
//        bottomsArray.append(shoeItem)
        
        
        
        
        
        ///TOP MAIN 1
        var topsMainArray = [ShoeItem]()

        //TM 1
        shoeItem = ShoeItem()
        shoeItem.itemProductID = "1"
        shoeItem.itemName = "Pattern Blouse"
        shoeItem.itemType = "Top"
        shoeItem.itemImageName = "top - pattern blouse"
        shoeItem.designerName = "Designer 1"
        shoeItem.price = "$49"
        shoeItem.itemDescription = "70% Triacetate. 30% polyester,Thin straps. V-neck and scoop back. Darting at bust. Hi-low back,Nude Color,Made in U.S.A.,Dry Clean"
        shoeItem.isPrimaryItem = true
        
        itemSizes = [ItemSize]()
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "S"
        itemSize.itemAvailability = 29
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "M"
        itemSize.itemAvailability = 30
        itemSizes.append(itemSize)

        itemSize = ItemSize()
        itemSize.itemSizeName = "L"
        itemSize.itemAvailability = 2
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "XL"
        itemSize.itemAvailability = 0
        itemSizes.append(itemSize)
        
        
        shoeItem.itemSizes = itemSizes
        
        
        shoeItem.earringsArray = earringsArray
        shoeItem.bottomsArray = bottomsArray
        shoeItem.shoesArray = shoesArray
        
        

   
        
        let clothingStylesTop1 = self.getClothingStylesForTop1()
        
        
        shoeItem.clothingStyles = clothingStylesTop1
        
        shoeItem.clothingType = ClothingType.top_MAIN

        topsMainArray.append(shoeItem)
        
        
        
        
        
        
        
        ///TOP MAIN 2

        //TM 2
        shoeItem = ShoeItem()
        shoeItem.itemProductID = "2"
        shoeItem.itemName = "Red Blouse"
        shoeItem.itemType = "Top"
        shoeItem.itemImageName = "top - red blouse"
        shoeItem.designerName = "Designer 2"
        shoeItem.price = "$72"
        shoeItem.itemDescription = "70% Triacetate. 30% polyester,Thin straps. V-neck and scoop back. Darting at bust. Hi-low back,Nude Color,Made in U.S.A.,Dry Clean"
        shoeItem.isPrimaryItem = true
        
        itemSizes = [ItemSize]()
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "S"
        itemSize.itemAvailability = 29
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "M"
        itemSize.itemAvailability = 30
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "L"
        itemSize.itemAvailability = 2
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "XL"
        itemSize.itemAvailability = 0
        itemSizes.append(itemSize)
        
        
        shoeItem.itemSizes = itemSizes
        
        
        shoeItem.earringsArray = earringsArray
        shoeItem.bottomsArray = bottomsArray
        shoeItem.shoesArray = shoesArray
        

        let clothingStylesTop2 = self.getClothingStylesForTop2()
        
        
        shoeItem.clothingStyles = clothingStylesTop2
        
        shoeItem.clothingType = ClothingType.top_MAIN
        
        topsMainArray.append(shoeItem)
        
        
        
        
        
        
        
        ///TOP MAIN 3
        
        //TM 3
        shoeItem = ShoeItem()
        shoeItem.itemProductID = "3"
        shoeItem.itemName = "White Lace"
        shoeItem.itemType = "Top"
        shoeItem.itemImageName = "top - white lace"
        shoeItem.designerName = "Designer 3"
        shoeItem.price = "$42"
        shoeItem.itemDescription = "70% Triacetate. 30% polyester,Thin straps. V-neck and scoop back. Darting at bust. Hi-low back,Nude Color,Made in U.S.A.,Dry Clean"
        shoeItem.isPrimaryItem = true
        
        itemSizes = [ItemSize]()
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "S"
        itemSize.itemAvailability = 29
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "M"
        itemSize.itemAvailability = 30
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "L"
        itemSize.itemAvailability = 2
        itemSizes.append(itemSize)
        
        itemSize = ItemSize()
        itemSize.itemSizeName = "XL"
        itemSize.itemAvailability = 0
        itemSizes.append(itemSize)
        
        
        shoeItem.itemSizes = itemSizes
        
        shoeItem.topSecArray = topSecsArray
        shoeItem.earringsArray = earringsArray
        shoeItem.bottomsArray = bottomsArray
        shoeItem.shoesArray = shoesArray
        
        
        let clothingStylesTop3 = self.getClothingStylesForTop3()
        
        
        shoeItem.clothingStyles = clothingStylesTop3
        
        shoeItem.clothingType = ClothingType.top_MAIN
        
        topsMainArray.append(shoeItem)
        
        
        
        
        return topsMainArray
        
        


    }
    
    
    
    // MARK: - Conversion Utility methods
    
    class func getCGFloatFromString(_ floatString : String) -> CGFloat
    {
        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: floatString)
        let numberFloatValue = number!.floatValue
        return CGFloat(numberFloatValue)
    }
    
    class func getIntFromString(_ intString : String) -> Int
    {
        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: intString)
        let numberIntValue = number!.intValue
        return numberIntValue
    }
    
    class func getBoolFromString(_ boolString : String) -> Bool
    {
        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: boolString)
        let numberBoolValue = number!.boolValue
        return numberBoolValue
    }
    
    
    class func getClothingStylesForTop1() -> [ClothingStyle]
    {
        //Clothing Styles
        var clothingStyles = [ClothingStyle]()
        
        ////////////////////Clothing Style 1 TM1 ER1 BT1 SH1///////////////////
        var clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        var itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 2 TM1 ER1 BT1 SH2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 3 TM1 ER1 BT1 SH3///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 4 TM1 ER1 BT2 SH1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 5 TM1 ER1 BT2 SH2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 6 TM1 ER1 BT2 SH3///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        ////////////////////Clothing Style 7 TM1 ER1 BT3 SH1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 8 TM1 ER1 BT3 SH2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 9 TM1 ER1 BT3 SH3///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 10 TM1 ER2 BT1 SH1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 11 TM1 ER2 BT1 SH2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 12 TM1 ER2 BT1 SH3///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 13 TM1 ER2 BT2 SH1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 14 TM1 ER2 BT2 SH2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 15 TM1 ER2 BT2 SH3///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        ////////////////////Clothing Style 16 TM1 ER2 BT3 SH1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 17 TM1 ER2 BT3 SH2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 18 TM1 ER2 BT3 SH3///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 19 TM1 ER3 BT1 SH1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 20 TM1 ER3 BT1 SH2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 21 TM1 ER3 BT1 SH3///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 22 TM1 ER3 BT2 SH1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 23 TM1 ER3 BT2 SH2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 24 TM1 ER3 BT2 SH3///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        ////////////////////Clothing Style 25 TM1 ER3 BT3 SH1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 26 TM1 ER3 BT3 SH2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 27 TM1 ER3 BT3 SH3///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 1 Asset Specs
        clothingStyle.TopMain_ID = "1"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 0
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 172
        itemAssetSpecs.height = 209
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        return clothingStyles
    }
  
    
    
    
    
    
    
    class func getClothingStylesForTop2() -> [ClothingStyle]
    {
        //Clothing Styles
        var clothingStyles = [ClothingStyle]()
        
        ////////////////////Clothing Style 1 TM2 ER1 BT1 SH1///////////////////
        var clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        var itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 2 TM2 ER1 BT1 SH2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 3 TM2 ER1 BT1 SH3///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 4 TM2 ER1 BT2 SH1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 5 TM2 ER1 BT2 SH2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 6 TM2 ER1 BT2 SH3///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        ////////////////////Clothing Style 7 TM2 ER1 BT3 SH1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 8 TM2 ER1 BT3 SH2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 9 TM2 ER1 BT3 SH3///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 10 TM2 ER2 BT1 SH1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 11 TM2 ER2 BT1 SH2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 12 TM2 ER2 BT1 SH3///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 13 TM2 ER2 BT2 SH1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 14 TM2 ER2 BT2 SH2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 15 TM2 ER2 BT2 SH3///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        ////////////////////Clothing Style 16 TM2 ER2 BT3 SH1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 17 TM2 ER2 BT3 SH2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 18 TM2 ER2 BT3 SH3///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 19 TM2 ER3 BT1 SH1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 20 TM2 ER3 BT1 SH2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 21 TM2 ER3 BT1 SH3///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 22 TM2 ER3 BT2 SH1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 23 TM2 ER3 BT2 SH2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 24 TM2 ER3 BT2 SH3///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        ////////////////////Clothing Style 25 TM2 ER3 BT3 SH1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 26 TM2 ER3 BT3 SH2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 27 TM2 ER3 BT3 SH3///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 2 Asset Specs
        clothingStyle.TopMain_ID = "2"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 13
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 155
        itemAssetSpecs.height = 176
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "0"
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        return clothingStyles
    }

    
    class func getClothingStylesForTop3() -> [ClothingStyle]
    {
        //Clothing Styles
        var clothingStyles = [ClothingStyle]()
        
        ////////////////////Clothing Style 1 TM3 ER1 BT1 SH1  TS1 ///////////////////
        var clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        var itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 2 TM3 ER1 BT1 SH2 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 3 TM3 ER1 BT1 SH3 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 4 TM3 ER1 BT2 SH1 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 5 TM3 ER1 BT2 SH2 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 6 TM3 ER1 BT2 SH3 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        ////////////////////Clothing Style 7 TM3 ER1 BT3 SH1 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 8 TM3 ER1 BT3 SH2 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 9 TM3 ER1 BT3 SH3 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 10 TM3 ER2 BT1 SH1 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 11 TM3 ER2 BT1 SH2 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 12 TM3 ER2 BT1 SH3 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 13 TM3 ER2 BT2 SH1 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 14 TM3 ER2 BT2 SH2 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 15 TM3 ER2 BT2 SH3 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        ////////////////////Clothing Style 16 TM3 ER2 BT3 SH1 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 17 TM3 ER2 BT3 SH2 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 18 TM3 ER2 BT3 SH3 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 19 TM3 ER3 BT1 SH1 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 20 TM3 ER3 BT1 SH2 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 21 TM3 ER3 BT1 SH3 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 22 TM3 ER3 BT2 SH1 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 23 TM3 ER3 BT2 SH2 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 24 TM3 ER3 BT2 SH3 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        ////////////////////Clothing Style 25 TM3 ER3 BT3 SH1 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 26 TM3 ER3 BT3 SH2 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 27 TM3 ER3 BT3 SH3 TS1///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 1 Asset Specs
        clothingStyle.TopSec_ID = "1111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 2
        itemAssetSpecs.yPos = 80
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        /////////////////////////////////////////////////////////////////////////////
        
        //TS2
        
        ////////////////////Clothing Style 1 TM3 ER1 BT1 SH1  TS2 ///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 2 TM3 ER1 BT1 SH2 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 3 TM3 ER1 BT1 SH3 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 4 TM3 ER1 BT2 SH1 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 5 TM3 ER1 BT2 SH2 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 6 TM3 ER1 BT2 SH3 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        ////////////////////Clothing Style 7 TM3 ER1 BT3 SH1 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 8 TM3 ER1 BT3 SH2 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 9 TM3 ER1 BT3 SH3 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 1 Asset Specs
        
        clothingStyle.Earrings_ID = "111"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 57
        itemAssetSpecs.yPos = 45
        itemAssetSpecs.width = 63
        itemAssetSpecs.height = 21
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 10 TM3 ER2 BT1 SH1 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 11 TM3 ER2 BT1 SH2 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 12 TM3 ER2 BT1 SH3 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 13 TM3 ER2 BT2 SH1 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 14 TM3 ER2 BT2 SH2 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 15 TM3 ER2 BT2 SH3 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        ////////////////////Clothing Style 16 TM3 ER2 BT3 SH1 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 17 TM3 ER2 BT3 SH2 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 18 TM3 ER2 BT3 SH3 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 2 Asset Specs
        
        clothingStyle.Earrings_ID = "222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 58
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 19 TM3 ER3 BT1 SH1 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 20 TM3 ER3 BT1 SH2 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 21 TM3 ER3 BT1 SH3 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 1 Asset Specs
        
        clothingStyle.Bottom_ID = "101"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 29
        itemAssetSpecs.yPos = 239
        itemAssetSpecs.width = 131
        itemAssetSpecs.height = 289
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 22 TM3 ER3 BT2 SH1 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 23 TM3 ER3 BT2 SH2 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////Clothing Style 24 TM3 ER3 BT2 SH3 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 2 Asset Specs
        
        clothingStyle.Bottom_ID = "202"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 11
        itemAssetSpecs.yPos = 247
        itemAssetSpecs.width = 147
        itemAssetSpecs.height = 139
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        
        
        ////////////////////Clothing Style 25 TM3 ER3 BT3 SH1 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 1 Asset Specs
        
        clothingStyle.Shoes_ID = "11"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 48
        itemAssetSpecs.yPos = 511
        itemAssetSpecs.width = 123
        itemAssetSpecs.height = 78
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 26 TM3 ER3 BT3 SH2 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 2 Asset Specs
        
        clothingStyle.Shoes_ID = "22"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 54
        itemAssetSpecs.yPos = 500
        itemAssetSpecs.width = 113
        itemAssetSpecs.height = 96
        itemAssetSpecs.zOrder = 1
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        
        
        
        
        
        ////////////////////Clothing Style 27 TM3 ER3 BT3 SH3 TS2///////////////////
        clothingStyle = ClothingStyle()
        
        
        //TM 3 Asset Specs
        clothingStyle.TopMain_ID = "3"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 40
        itemAssetSpecs.yPos = 90
        itemAssetSpecs.width = 95
        itemAssetSpecs.height = 136
        itemAssetSpecs.zOrder = 2
        clothingStyle.TopMain_Specs = itemAssetSpecs
        
        //TS 2 Asset Specs
        clothingStyle.TopSec_ID = "2222"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 4
        itemAssetSpecs.yPos = 78
        itemAssetSpecs.width = 164
        itemAssetSpecs.height = 222
        itemAssetSpecs.zOrder = 3
        clothingStyle.TopSec_Specs = itemAssetSpecs
        
        //ER 3 Asset Specs
        
        clothingStyle.Earrings_ID = "333"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 60
        itemAssetSpecs.yPos = 47
        itemAssetSpecs.width = 57
        itemAssetSpecs.height = 12
        itemAssetSpecs.zOrder = 1
        clothingStyle.Earrings_Specs = itemAssetSpecs
        
        
        //BT 3 Asset Specs
        
        clothingStyle.Bottom_ID = "303"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 27
        itemAssetSpecs.yPos = 219
        itemAssetSpecs.width = 118
        itemAssetSpecs.height = 130
        itemAssetSpecs.zOrder = 1
        clothingStyle.Bottom_Specs = itemAssetSpecs
        
        //SH 3 Asset Specs
        
        clothingStyle.Shoes_ID = "33"
        itemAssetSpecs = ItemAssetSpecs()
        itemAssetSpecs.xPos = 46
        itemAssetSpecs.yPos = 374
        itemAssetSpecs.width = 122
        itemAssetSpecs.height = 221
        itemAssetSpecs.zOrder = 2
        clothingStyle.Shoes_Specs = itemAssetSpecs
        
        clothingStyles.append(clothingStyle)
        

        
        
        return clothingStyles
    }
    
    
}

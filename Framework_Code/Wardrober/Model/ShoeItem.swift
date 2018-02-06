//
//  ShoeItem.swift
//  Fashion180
//
//  Created by Yogi on 10/10/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//

import UIKit

enum ClothingType {
    case top_MAIN
    case top_SECONDARY
    case bottom
    case shoes
    case earrings
    case bracelets
}

class ShoeItem: NSObject {

    var productBottomItemID : String!
    var itemProductID : String!
    var itemName : String!
    var itemType : String!
    var itemImageName : String!
    var itemImageURL : String!
    
    var rearItemImageURL : String?

    
    var designerName : String!
    var price : String!
    var itemDescription : String!
    var itemOptions : String!

    var isPrimaryItem : Bool! = false
    var isAssetDownloading : Bool! = false
    var isAssetDownloaded : Bool! = false
    var isSizesDownloading : Bool! = false
    var isSizesDownloaded : Bool! = false
    
    var isRearAssetDownloading : Bool! = false
    var isRearAssetDownloaded : Bool! = false
    
    var itemSizes : [ItemSize] = [ItemSize]()
    var sizeSelected : ItemSize? = nil
    
    var clothingType : ClothingType!

    var earringsArray : [ShoeItem] = [ShoeItem]()
    var topSecArray : [ShoeItem] = [ShoeItem]()
    var bottomsArray : [ShoeItem] = [ShoeItem]()
    var shoesArray : [ShoeItem] = [ShoeItem]()
    

    var isAddedToWardrobe : Bool! = false

    var assetSizeSpecs : ItemAssetSpecs!
    var zOrder : Int!
    
    
    var totalEarringsCount : Int! = 0
    var totalJackectsCount : Int! = 0
    var totalBottomsCount : Int! = 0
    var totalShoesCount : Int! = 0
    
    /// older not required
    var clothingStyles : [ClothingStyle] = [ClothingStyle]()
    var xPosition : CGFloat!
    var yPosition : CGFloat!
    var width : CGFloat!
    var height : CGFloat!
    var isAddedToWishlist : Bool! = false

}

//
//  ItemAssetSpecs.swift
//  Fashion180
//
//  Created by Yogi on 07/11/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//

import UIKit

class ItemAssetSpecs: NSObject {

    var assetBoundsFront : ItemAssetBounds!
    var assetBoundsRear : ItemAssetBounds!
    var overridesDefaultZOrder : Bool!
    var productID : String!
    
    
    ////older, not in use in V2
    var xPos : CGFloat!
    var yPos : CGFloat!
    var width : CGFloat!
    var height : CGFloat!
    var zOrder : Int!
}

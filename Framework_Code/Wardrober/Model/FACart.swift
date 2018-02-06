//
//  FACart.swift
//  Fashion180
//
//  Created by Yogi on 11/11/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//

import UIKit

class FACart: NSObject {

    fileprivate static let sharedInstance = FACart()

    fileprivate var items : [ShoeItem] = [ShoeItem]()
    
    class func sharedCart() -> FACart
    {
        return sharedInstance
    }
    
    func getCartItems() -> [ShoeItem]!
    {
        return items
    }
    
    func removeCartItem(_ item : ShoeItem)
    {
        items.remove(at: items.index(of: item)!)
    }
    
    func removeAllCartItems()
    {
        items.removeAll()
    }
    
    func addItemToCart(_ item : ShoeItem)
    {
        items.append(item)
    }
    
    func getCartCount() -> Int
    {
        return items.count
    }
    
}

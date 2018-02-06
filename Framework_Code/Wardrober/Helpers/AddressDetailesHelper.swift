//
//  AddressDetailesHelper.swift
//  Wardrober
//
//  Created by Saraschandra on 11/01/18.
//  Copyright © 2018 Mobiware. All rights reserved.
//

import UIKit

class AddressDetailesHelper: NSObject
{
    class func  getAddressHelper(_ responseObj:AnyObject?) -> [Address]?
    {
        var addresses : [Address] =  [Address]()
        
        if let getShippingAddResultsDict = responseObj!["GetShippingAddressResult"] as? NSDictionary
        {
           if let _ = getShippingAddResultsDict["Error"] as? NSNull
           {
              if let resultsArray = getShippingAddResultsDict["Results"] as? [NSDictionary]
              {
                 if resultsArray.count > 0
                 {
                    for dict in resultsArray
                    {
                        let address = Address()
                        
                        address.firstName = dict.object(forKey: "FirstName") as! String
                        address.lastName = dict.object(forKey: "LastName") as! String
                        address.compyName = dict.object(forKey: "CompanyName") as! String
                        address.streetAddress = dict.object(forKey: "StreetAddress") as! String
                        address.city = dict.object(forKey: "City") as! String
                        address.state = dict.object(forKey: "State") as! String
                        address.country = dict.object(forKey: "Country") as! String
                        address.phone = dict.object(forKey: "Phone") as! String
                        address.zip = dict.object(forKey: "ZIP") as! String
                        address.shippingAddressID = (dict.object(forKey: "ShippingAddressid") as! String)
                        address.customerID = dict.object(forKey: "CustomerID") as! String
                        
                        addresses.append(address)
                        
                    }
                    return addresses
                 }
                 else
                 {
                    return addresses
                 }
              }
           }
        }
        return addresses
    }
    
    
}

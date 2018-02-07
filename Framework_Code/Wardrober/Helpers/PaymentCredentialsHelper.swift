//
//  PaymentCredentialsHelper.swift
//  Wardrober
//
//  Created by Srinivas Peddinti on 2/7/18.
//  Copyright © 2018 Mobiware. All rights reserved.
//

import UIKit

class PaymentCredentialsHelper: NSObject {

    class func  getAuthenticationHelper(_ responseObj:AnyObject?) -> [Credentials]?
    {
        var credentials : [Credentials] =  [Credentials]()
        
        if let getCredentailsResultsDict = responseObj!["GetAuthenticationCredentialsResult"] as? NSDictionary
        {
            if let _ = getCredentailsResultsDict["Error"] as? NSNull
            {
                if let resultsArray = getCredentailsResultsDict["Results"] as? [NSDictionary]
                {
                    if resultsArray.count > 0
                    {
                        for dict in resultsArray
                        {
                            let clientCredential = Credentials()
                            
                            clientCredential.apiLoginId = dict.object(forKey: "ApiLoginId") as! String
                            clientCredential.transactionKey = dict.object(forKey: "TransactionKey") as! String
                           clientCredential.publicClientKey = dict.object(forKey: "PublicClientKey") as! String
                           
                            credentials.append(clientCredential)
                            
                        }
                        return credentials
                    }
                    else
                    {
                        return credentials
                    }
                }
            }
        }
        return credentials
    }
}

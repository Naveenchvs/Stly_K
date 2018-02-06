//
//  CreateAccountHelper.swift
//  Fashion180
//
//  Created by Srinivas Peddinti on 10/18/16.
//  Copyright © 2016 MobiwareInc. All rights reserved.
//

import UIKit

class CreateAccountHelper: NSObject
{

    // MARK: Response object parsing
    class func  createAccountResponseMessage(_ responseObj:AnyObject?) -> (String?, String?)
    {
            var custId : String? = nil
            
            if let _ = responseObj!["Error"] as? NSNull
            {
                if let resultsArray = responseObj!["Results"] as? [NSDictionary]
                {
                    if resultsArray.count > 0
                    {
                        let resultDict = resultsArray.first;
                        var customerId = "";
                        var statusCode = "0"
                        
                        if let sts_code = resultDict!["StatusCode"] as! String!
                        {
                            statusCode = sts_code
                        }
                        
                        
                        if statusCode == "0"
                        {
                            if let _ = resultDict!["CustomerUserID"] as? String
                            {
                                customerId = resultDict!["CustomerUserID"] as? String ?? "";
                                custId = customerId
                                
                                return (custId, nil)
                            }
                            else if let _ = resultDict!["CustomerUserID"] as? Int
                            {
                                customerId = String(format: "%d", arguments: [resultDict!["CustomerUserID"] as? Int ?? ""]);
                                custId = customerId
                                
                                return (custId, nil)
                                
                                
                            }
                            else
                            {
                                return (custId, "Invalid Customer ID")
                            }
                            
                        }
                        else
                        {
                            let message = resultDict!["StatusMsg"] as? String ?? ""
                            
                            return (nil, message)
                        }

                        
                        /* let user:User = User(appointmentReminder:appointmentReminder, city: resultDict!["City"] as? String ?? "", contactId: (resultDict!["ContactId"] as? String) ?? "", country: resultDict!["Country"]  as? String ?? "", customerId: customerId, firstName: resultDict!["FirstName"] as? String ?? "", homeNumber: resultDict!["HomeNumber"] as? String ?? "", lastName: resultDict!["LastName"] as? String ?? "", mobileNumber: resultDict!["MobileNumber"] as? String ?? "", remindAboutServiceNeeds: remindAboutServiceNeeds, state: resultDict!["State"] as? String ?? "", streetAddres: resultDict!["StreetAddres"] as? String ?? "", workNumber: resultDict!["WorkNumber"] as? String ?? "", zipCode: resultDict!["ZipCode"] as? String ?? "",registrationType:resultDict!["Registrationtype"] as? String ?? "",addresLine2:resultDict!["AddresLine2"] as? String ?? "");
                         CurrentUser.encode(user);*/
                    }
                }
            }
            else
            {
                if let errorDict = responseObj!["Error"] as? NSDictionary
                {
                    if errorDict.count > 0
                    {
                        let messageError = errorDict["Message"] as? String ?? ""
                        return (nil, messageError)
                    }
                }
                
            }
            
            return (nil, nil)
    }

}

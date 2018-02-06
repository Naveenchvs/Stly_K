//
//  CommonValidation.swift
//  FoodBit
//
//  Created by INDU on 17/12/14.
//  Copyright (c) 2014 Mobiware. All rights reserved.
//

import UIKit

class CommonValidation: NSObject
{
    func isValidNumeric(_ numericStr:String) -> Bool
    {
        //let numricRegEx = "\\b([0-9%_.+\\-]+)\\b";
        //let numricRegEx = "/^[0-9]{1,10}$/";
        
        let numricRegEx = "[0-9]*"
        let numericPredicate = NSPredicate(format:"SELF MATCHES %@", numricRegEx)
        let result = numericPredicate.evaluate(with: numericStr)
        return result
    }
}

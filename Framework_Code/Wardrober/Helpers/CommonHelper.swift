//
//  CommonHelper.swift
//  Fashion180
//

import UIKit

class CommonHelper: NSObject
{
    
    public typealias FMCheckAndDownloadAssetHandler = (Bool, String?) -> Swift.Void
   
    class func getCustomerID() -> String
    {
        if let userCustomerId = UserDefaults.standard.value(forKey: Constants.kSignedInUserID) as? String
        {
            return userCustomerId
        }
        else
        {
            return "0"
        }
    }
    
    
    class func setCustomerIDIfNotExists()
    {
        let customerID = UserDefaults.standard.value(forKey: Constants.kSignedInUserID) as? String

        if UserDefaults.standard.value(forKey: Constants.kUserIdentifier) as? String == nil
        {
            UserDefaults.standard.set(customerID, forKey: Constants.kUserIdentifier)
            UserDefaults.standard.synchronize()
        }

    }
    
    class func isValidEmail(_ testStr:String) -> Bool
    {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func sessionConfigObjcInitialisation() -> URLSessionConfiguration{
        let sessionConfi = URLSessionConfiguration.default;
        sessionConfi.httpAdditionalHeaders = ["Content-Type":"application/json; charset=utf-8",Urls.AccessToken:Urls.AccessTokenValue]
        return sessionConfi
    }
    
    class func sessionConfigObjc() -> URLSessionConfiguration{
        let sessionConfi = URLSessionConfiguration.default;
        sessionConfi.httpAdditionalHeaders = ["Content-Type":"application/json; charset=utf-8",Urls.AccessToken:Wardrober.shared().serviceAccessToken!]
        return sessionConfi
    }
    
    
    
    class func updateMultiplierCenterXConstraint(multiplier : CGFloat?, forDotView dotView: FADotView)
    {
        guard multiplier != nil else
        {
            return
        }
        
        guard let containerView  = dotView.superview else
        {
            return
        }
        let matchingConstraints =  containerView.constraints.filter { (constraint) -> Bool in
            
            return (constraint.firstItem as! UIView == dotView && constraint.firstAttribute == .centerX)
        }
        
        guard matchingConstraints.count > 0 else
        {
            return
        }
        
        let dotCenterXConstraint = matchingConstraints.first!
        
        containerView.removeConstraint(dotCenterXConstraint)
        
        let newDotCenterXConstraint = NSLayoutConstraint(
            item: dotCenterXConstraint.firstItem,
            attribute: dotCenterXConstraint.firstAttribute,
            relatedBy: dotCenterXConstraint.relation,
            toItem: dotCenterXConstraint.secondItem,
            attribute: dotCenterXConstraint.secondAttribute,
            multiplier: multiplier!,
            constant: dotCenterXConstraint.constant)
        
        containerView.addConstraint(newDotCenterXConstraint)
        
    }
    
    class func updateMultiplierCenterYConstraint(multiplier : CGFloat?, forDotView dotView: FADotView)
    {
        guard multiplier != nil else
        {
            return
        }
        
        guard let containerView  = dotView.superview else
        {
            return
        }
        let matchingConstraints =  containerView.constraints.filter { (constraint) -> Bool in
            
            return (constraint.firstItem as! UIView == dotView && constraint.firstAttribute == .centerY)
        }
        
        guard matchingConstraints.count > 0 else
        {
            return
        }
        
        let dotCenterYConstraint = matchingConstraints.first!
        
        containerView.removeConstraint(dotCenterYConstraint)
        
        let newDotCenterYConstraint = NSLayoutConstraint(
            item: dotCenterYConstraint.firstItem,
            attribute: dotCenterYConstraint.firstAttribute,
            relatedBy: dotCenterYConstraint.relation,
            toItem: dotCenterYConstraint.secondItem,
            attribute: dotCenterYConstraint.secondAttribute,
            multiplier: multiplier!,
            constant: dotCenterYConstraint.constant)
        
        containerView.addConstraint(newDotCenterYConstraint)
        
    }
    
    
    // MARK: - ClientAppLogin service (Framework initialization service)
    class func getRequestDictForClientAppLogin(_ ClientID : String, ClientSecret : String) -> Dictionary<String,String>{
        var requestDict:Dictionary<String,String> = Dictionary<String,String>()
        
        let bundleIdentifier = Bundle.main.bundleIdentifier
        ///print("bundle Id retrieved : \(bundleIdentifier)")
        
        requestDict["ClientID"] = ClientID;
        
        requestDict["ClientSecret"] = ClientSecret
        
        requestDict["Source"] = "ios"
        
        if let bundleIdentifier = Bundle.main.bundleIdentifier
        {
            requestDict["Bundle_Id"] = bundleIdentifier
            
           // requestDict["Bundle_Id"] = "com.flash180.stanleykorshak"
        }
        
        
        return requestDict
    }
    
    
    class func parseClientAppLoginResponse(_ responseObject:AnyObject?) -> (apiUrl : String?, accessToken : String?, errorString : String?)
    {
        let success = responseObject!["Success"] as! Bool
        
        if  success == true
        {
            //success
            
            if let resultArray = responseObject!["Results"] as! [NSDictionary]!
            {
                if resultArray.count > 0
                {
                    let result = resultArray.first!
                    
                    //                    Access_Token":"String content",
                    //                    "ClientApiUri":"String content",
                    //                    "StatusCode":"String content",
                    //                    "StatusMsg":"String content"
                    
                    
                    let statusCode = result["StatusCode"] as? String!
                    let statusMsg = result["StatusMsg"] as? String!
                    
                    guard statusCode == "0" else
                    {
                        return(nil, nil, statusMsg)
                    }
                    
                    let apiurl = result["ClientApiUri"];
                    let accessToken = result["Access_Token"];
                    
                    return(apiurl as! String?, accessToken as! String?, nil)
                    
                }
                else
                {
                    ///empty result
                    
                    return (nil, nil, "Invalid client api url/token due to Unknown Error")
                }
            }
            else
            {
                return (nil, nil, "Unexpected client api url/token response due to Unknown Error")
            }
        }
        else
        {
            if let error = responseObject!["Error"] as? NSDictionary!
            {
                return (nil, nil, error["Message"] as! String?)
            }
            else
            {
                return (nil, nil, "Unknown Error")
                
            }
            
        }
        
    }
    
    
    // MARK: - GetProductCategorysInfo service (dynamically retrieving item categories)
    class func parseGetProductCategorysInfoResponse(_ responseObject:AnyObject?) -> (categories : [FACategory]?, errorString : String?)
    {
        let success = responseObject!["Success"] as! Bool
        
        if  success == true
        {
            //success
            
            if let resultArray = responseObject!["Results"] as! [NSDictionary]!
            {
                if resultArray.count > 0
                {
                    var categories = [FACategory]()
                    for result in resultArray
                    {
                        //                    "Results":[{
                        //                    "ProductCategoryID":"String content",
                        //                    "ProductCategoryName":"String content",
                        //                    "ProductCategoryImageUrl":"String content"
                        //                    }]
                        
                        
                        
                        let category = FACategory()
                        if let categoryID = result["ProductCategoryID"]
                        {
                            category.categoryId = categoryID as? String
                            
                        }
                        if let categoryName = result["ProductCategoryName"]
                        {
                            category.categoryName = categoryName as? String
                        }
                        if let categoryImgUrl = result["ProductCategoryImageUrl"] as? String
                        {
                            if categoryImgUrl != ""
                            {
                                category.categoryImageUrl = categoryImgUrl
                            }
                        }
                        
                        categories.append(category)
                    }
                    
//                    categories.sort{ $0.categoryId < $1.categoryId }

                    return(categories, nil)

                }
                else
                {
                    ///empty result
                    
                    return (nil, "Invalid client api url/token due to Unknown Error")
                }
            }
            else
            {
                return (nil, "Unexpected client api url/token response due to Unknown Error")
            }
        }
        else
        {
            if let error = responseObject!["Error"] as? NSDictionary!
            {
                return (nil, error["Message"] as! String?)
            }
            else
            {
                return (nil, "Unknown Error")
                
            }
            
        }
        
    }
    
    
    // MARK: - GetModelInfoByAssetSize service (dynamically retrieving model assets and related config data)
    class func getRequestDictForGetModelInfoByAssetSize() -> Dictionary<String,String>{
        var requestDict:Dictionary<String,String> = Dictionary<String,String>()
        
        let scale = UIScreen.main.scale
        
        requestDict["AssetSize"] = "\(Int(scale))";
        
        return requestDict
    }
    
    
    class func parseGetModelInfoByAssetSizeResponse(_ responseObject:AnyObject?) -> (modelConfig : FAModelConfig?, errorString : String?)
    {
        let success = responseObject!["Success"] as! Bool
        
        if  success == true
        {
            //success
            
            if let resultArray = responseObject!["Results"] as! [NSDictionary]!
            {
                if resultArray.count > 0
                {
                    let result = resultArray.first!
                    
                    //                    "Results":[{
                    //                    "FrontModelImage":"String content",
                    //                    "BackModelImage":"String content",
                    //                    "AssetSize":"String content"
                    //                    }]
                    

                    
                    let modelConfig = FAModelConfig()
                    if let frontImageUrl = result["FrontModelImage"]
                    {
                        modelConfig.frontAssetUrl = frontImageUrl as? String
                        
                    }
                    if let rearImageUrl = result["BackModelImage"]
                    {
                        modelConfig.rearAssetUrl = rearImageUrl as? String
                    }
                    
                    
                    return(modelConfig, nil)
                    
                }
                else
                {
                    ///empty result
                    
                    return (nil, "Invalid client api url/token due to Unknown Error")
                }
            }
            else
            {
                return (nil, "Unexpected client api url/token response due to Unknown Error")
            }
        }
        else
        {
            if let error = responseObject!["Error"] as? NSDictionary!
            {
                return (nil, error["Message"] as! String?)
            }
            else
            {
                return (nil, "Unknown Error")
                
            }
            
        }
        
    }
    
    
    // MARK: - CheckAndDownloadAsset at imageUrl and callback

    class func checkAndDownloadAsset(imageUrl : String, completion: @escaping FMCheckAndDownloadAssetHandler)
    {
        guard let itemImageUrl = URL(string: imageUrl) else
        {
            completion(false, "invalid url")
            return
        }
        
        let cacheResult : FAImageCache.CacheCheckResult = FAImageCache.default.isImageCached(forKey: imageUrl)
        if (cacheResult.cached == true)
        {
            
            ///print("imageCache Exists for image url \(imageUrl)")
            
            completion(true, nil)
        }
        else
        {
            ///print("FAImageCache itemImageUrl===>\(itemImageUrl) \n imageurl===>\(imageUrl)")
            
            FAImageDownloader.default.downloadImage(with: itemImageUrl, options: [], progressBlock: nil) {
                (image, error, url, data) in
                
                guard error == nil else
                {
                    completion(false, error?.localizedDescription)
                    return
                }
                
                ///print("storing imageForImageUrl \(imageUrl)")
                FAImageCache.default.store(image!, forKey: imageUrl, completionHandler: {
                    
                    completion(true, nil)
                    
                })
                
                
            }
        }
        
    }
    
    
    // MARK: - CheckAndDownloadFrontAsset for item and callback
    
    class func checkAndDownloadFrontAsset(item : ShoeItem, completion: @escaping FMCheckAndDownloadAssetHandler)
    {
        guard let itemImageUrl = URL(string: item.itemImageURL!) else
        {
            completion(false, "invalid url")
            return
        }
        
        let cacheResult : FAImageCache.CacheCheckResult = FAImageCache.default.isImageCached(forKey: item.itemImageURL)
        if (cacheResult.cached == true)
        {
            
            ///print("imageCache Exists for image url \(item.itemImageURL!)")
            
            item.isAssetDownloaded = true
            item.isAssetDownloading = false
            
            completion(true, nil)
        }
        else
        {
            ///print("imageCache Not for image url \(item.itemImageURL!)")
            
            item.isAssetDownloaded = false
            item.isAssetDownloading = true
            
            FAImageDownloader.default.downloadImage(with: itemImageUrl, options: [], progressBlock: nil) {
                (image, error, url, data) in
                
                guard error == nil else
                {
                    item.isAssetDownloaded = false
                    item.isAssetDownloading = false
                    
                    completion(false, error?.localizedDescription)
                    return
                }
                
                
                
                FAImageCache.default.store(image!, forKey: item.itemImageURL, completionHandler: {
                    
                    item.isAssetDownloaded = true
                    item.isAssetDownloading = false
                    
                    completion(true, nil)
                    
                })
                
                
                
                
            }
        }
        
    }
    
    // MARK: - CheckAndDownloadRearAsset for item and callback
    
    class func checkAndDownloadRearAsset(item : ShoeItem, completion: @escaping FMCheckAndDownloadAssetHandler)
    {
        guard let itemImageUrl = URL(string: item.rearItemImageURL!) else
        {
            completion(false, "invalid url")
            return
        }
        
        let cacheResult : FAImageCache.CacheCheckResult = FAImageCache.default.isImageCached(forKey: item.rearItemImageURL!)
        if (cacheResult.cached == true)
        {
            
            ///print("imageCache Exists for image url \(item.rearItemImageURL!)")
            
            item.isRearAssetDownloaded = true
            item.isRearAssetDownloading = false
            
            completion(true, nil)
        }
        else
        {
            ///print("imageCache Not for image url \(item.rearItemImageURL!)")
            
            item.isRearAssetDownloaded = false
            item.isRearAssetDownloading = true
            
            FAImageDownloader.default.downloadImage(with: itemImageUrl, options: [], progressBlock: nil) {
                (image, error, url, data) in
                
                guard error == nil else
                {
                    item.isRearAssetDownloaded = false
                    item.isRearAssetDownloading = false
                    
                    completion(false, error?.localizedDescription)
                    return
                }
                
                
                FAImageCache.default.store(image!, forKey: item.rearItemImageURL!, completionHandler: {
                    
                    item.isRearAssetDownloaded = true
                    item.isRearAssetDownloading = false
                    
                    completion(true, nil)
                    
                })
            }
        }
    }
}

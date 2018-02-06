//
//  Wardrober.swift
//  Fashion180
//
//  Created by Yogi on 16/05/17.
//  Copyright © 2017 Mobiware. All rights reserved.
//

import UIKit

enum WardroberState
{
    case none
    case initialising
    case initialised
    case fetchingCategories
    case categoriesFetched
    case fetchingModelInfo
    case modelInfoFetched
}

public struct WardroberNotifications
{
    public static let ItemAddedToWardrobe = Notification.Name("com.wardrober.addedToWardrobe")
    public static let ItemRemovedFromWardrobe = Notification.Name("com.wardrober.removedFromWardrobe")
    public static let ItemAddedToCart = Notification.Name("com.wardrober.addedToCart")
    public static let ItemRemovedFromCart = Notification.Name("com.wardrober.removedFromCart")

    public static let WillExit = Notification.Name("com.wardrober.wardroberWillExitWithoutCheckout")
    public static let CheckoutTapped = Notification.Name("com.wardrober.wardroberWillExitWithCheckout")
}

@objc public protocol WardroberDelegate
{
    @objc optional func wardroberAddedAnItemToWardrobe(item : WRItem)
    @objc optional func wardroberRemovedAnItemFromWardrobe(item : WRItem)
    @objc optional func wardroberAddedAnItemToCart(item : WRCartItem)
    @objc optional func wardroberRemovedAnItemFromCart(item : WRCartItem)
    
    @objc optional func wardroberWillExit()
    
    @objc optional func wardroberCheckoutTappedWithCartItems(items : [WRCartItem])

}



final public class Wardrober: NSObject
{
    private static var privateShared : Wardrober?
    class func shared() -> Wardrober
    {
        // change class to final to prevent override
        guard let uwShared = privateShared else {
            privateShared = Wardrober()
            return privateShared!
        }
        return uwShared
    }
    
    
    private var homeVC : HomeContainerVC? = nil
    
    var clientId : String? = nil
    var clientSecret : String? = nil
    
    var serviceMainUrl : String? = nil
    var serviceAccessToken : String? = nil
    
    var modelConfig : FAModelConfig? = nil
    var categories = [FACategory]()
    
    var state = WardroberState.none
    
    private var hostViewController : UIViewController? = nil
    
    var delegate : WardroberDelegate? = nil
    
    private override init()
    {
        super.init()
    }
    
    
    
    class func registerDefaultsValues()
    {
        var defaultsDict = [String : AnyObject]()
        defaultsDict[Constants.kUserSuccessfullySignedIn] = false as AnyObject?
        defaultsDict[Constants.kFirstLaunch] = true as AnyObject?
        
        UserDefaults.standard.register(defaults: defaultsDict)
    }
    
    
    public class func initialiseWith(clientID : String, secret : String, delegate : WardroberDelegate? = nil)
    {
        
        guard Wardrober.shared().state == .none else
        {
            print("An instance of Wardrober already in initialisation mode. initialiseWith can be called again if initialisation fails for some reason")
            return
        }
        
        Wardrober.shared().delegate = delegate
        
        Wardrober.shared().state = .initialising
        Wardrober.shared().clientId = clientID
        Wardrober.shared().clientSecret = secret
        
        ///call the framework provisioning service to get the main url and secret
        //call the service and get the data
        let url = String(format: "%@", arguments: [Urls.WardroberInitializerUrl]);
        
        let requestDict = CommonHelper.getRequestDictForClientAppLogin(clientID, ClientSecret: secret)
        
        FAServiceHelper().initialPost(url: url, parameters: requestDict as NSDictionary  , completion : { (success : Bool?, message : String?, responseObject : AnyObject?) in
            
            guard success == true else
            {
                print("Wardrober Initialization Failed (\(String(describing: message)))")
                
                Wardrober.shared().state = .none
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kWardroberInitialisedFailNotification), object: nil)
                
                return
            }
            
            guard responseObject != nil else
            {
                print("Wardrober Initialization Failed - Invalid response from the remote server")

                return
            }
            
            let (url, token, errorMsg) = CommonHelper.parseClientAppLoginResponse(responseObject as AnyObject?)
            
            if errorMsg == nil
            {
                //print("Wardrober Initialization Succeeded")
                //print("serviceMainUrl : \(url)")
                //print("serviceAccessToken : \(token)")
                
                Wardrober.shared().serviceMainUrl = url
                Wardrober.shared().serviceAccessToken = token
                
                Wardrober.shared().state = .initialised
                
                CommonHelper.setCustomerIDIfNotExists()
                
                //fetch categories
                Wardrober.shared().fetchCategories()
                
            }
            else
            {
                
                Wardrober.shared().state = .none
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kWardroberInitialisedFailNotification), object: nil)
                
                print("Wardrober Initialization Failed - (\(String(describing: errorMsg)))")

                
            }
            
        })
        
    }
    
    
    private func fetchCategories()
    {
        Wardrober.shared().state = .fetchingCategories
        
        ///call the fetch model asset info service to get the model front and rear assets and other related config data
        let url = String(format: "%@/%@", arguments: [self.serviceMainUrl!, Urls.GetProductCategorysInfo]);
        
        FAServiceHelper().post(url: url, parameters: [:]  , completion : { (success : Bool?, message : String?, responseObject : AnyObject?) in
            
            guard success == true else
            {
                print("Wardrober fetchCategories Failed (\(String(describing: message)))")
                
                return
            }
            
            guard responseObject != nil else
            {
                print("Wardrober fetchCategories Failed - invalid response from the remote server")
                
                return
            }
            
            let (categories, errorMsg) = CommonHelper.parseGetProductCategorysInfoResponse(responseObject as AnyObject?)
            
            if errorMsg == nil
            {
                //print("Category data fetch Succeeded")
                //print("categories count : \(categories!.count)")
                Wardrober.shared().categories = categories!
                
                Wardrober.shared().state = .categoriesFetched
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kCategoriesFetchedNotification), object: nil)
                
                //fetch url for Model Image if it isn't available - will be done once per Wardrober invocation
                Wardrober.shared().fetchModelAssetInfo()
                
                
            }
            else
            {
                
                print("Wardrober fetchCategories Failed (\(String(describing: message)))")
                
            }
            
        })
    }
    
    private func fetchModelAssetInfo()
    {
        Wardrober.shared().state = .fetchingModelInfo
        
        ///call the fetch model asset info service to get the model front and rear assets and other related config data
        let url = String(format: "%@/%@", arguments: [self.serviceMainUrl!, Urls.GetModelInfoByAssetSize]);
        
        FAServiceHelper().post(url: url, parameters:CommonHelper.getRequestDictForGetModelInfoByAssetSize() as NSDictionary  , completion : { (success : Bool?, message : String?, responseObject : AnyObject?) in
            
            guard success == true else
            {
                print("Model Config data Initialization Failed (\(String(describing: message)))")
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kWardroberInitialisedFailNotification), object: nil)
                
                return
            }
            
            guard responseObject != nil else
            {
                print("Model Config data Initialization Failed - invalid response from the remote server")
                return
            }
            
            let (modelConfig, errorMsg) = CommonHelper.parseGetModelInfoByAssetSizeResponse(responseObject as AnyObject?)
            
            if errorMsg == nil
            {
                ///print("Model Config data Initialization Succeeded")
                ///print("model front url : \(modelConfig?.frontAssetUrl)")
                ///print("model rear url : \(modelConfig?.rearAssetUrl)")
                
                Wardrober.shared().modelConfig = modelConfig
                
                Wardrober.shared().state = .modelInfoFetched
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kWardroberInitialisedNotification), object: nil)
                
            }
            else
            {
                print("Model Config data Initialization Failed (\(String(describing: message)))")
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kWardroberInitialisedFailNotification), object: nil)
            }
        })
        
    }
    
    public class func launch(fromViewController viewController : UIViewController, animated : Bool)
    {
        Wardrober.shared().hostViewController = viewController
        
        self.registerDefaultsValues()
        UIApplication.shared.isStatusBarHidden = true;
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: Wardrober.self))
        let homeController = storyboard.instantiateViewController(withIdentifier: "HomeContainerVC") as! HomeContainerVC
        
        Wardrober.shared().homeVC = homeController
        
        viewController.present(homeController, animated: animated) {
            
        }
    }
    
    
    public class func getCartItems() -> [WRCartItem]
    {
        let itemsArray = [WRCartItem]()

        for item in FACart.sharedCart().getCartItems()
        {
            let wrItem = WRCartItem()
            wrItem.itemProductID = item.itemProductID
            wrItem.price = item.price
            wrItem.sizeSelected = item.sizeSelected?.itemSizeName
            wrItem.isAddedToWardrobe = item.isAddedToWardrobe

        }
        return itemsArray
    }
    
    public class func removeAllCartItems()
    {
        FACart.sharedCart().removeAllCartItems()
    }
    
    public class func removeCartItem(cartItem : WRCartItem)
    {
        let itemsToDelete = FACart.sharedCart().getCartItems().filter { (item) -> Bool in
            
            return item.itemProductID == cartItem.itemProductID
        }
        
        for item in itemsToDelete
        {
            FACart.sharedCart().removeCartItem(item)
        }
        
    }
    
    
    private func dispose()
    {
        
        ///print("dispose called on wardrober")

        self.homeVC = nil
        self.delegate = nil
        self.serviceMainUrl = nil
        self.serviceAccessToken = nil
        self.clientId = nil
        self.clientSecret = nil
        self.state = .none
        
        Wardrober.privateShared = nil
        
    }
    
    public class func exit(animated : Bool = true)
    {
        Wardrober.shared().hostViewController?.dismiss(animated: animated, completion: {
            
            Wardrober.shared().dispose()
        })
    }
}



extension UIWindow
{
    var visibleViewController: UIViewController?
    {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController?
    {
        if let nc = vc as? UINavigationController
        {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController
        {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        }
        else
        {
            if let pvc = vc?.presentedViewController
            {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            }
            else
            {
                return vc
            }
        }
    }
}

public class WRItem : NSObject
{
    public var itemProductID : String!
    public var isAddedToWardrobe : Bool! = false
}

public class WRCartItem : WRItem
{
    public var price : String!
    public var sizeSelected : String!
}




//
//  HomeContainerVC.swift
//  Fashion180
//
//  Created by Yogi on 05/10/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//

import UIKit


class HomeContainerVC: UIViewController, UINavigationControllerDelegate, FATutorialVCDelegate, SignInDelegate, AddContainerDelegate
{
    @IBOutlet weak var childContentView: UIView!
    var homeNavigationController : BaseNavigationController? = nil;
    var slideMenuVC : SlideMenuVC? = nil;

    var modelVC : ModelVC? = nil;
    
    @IBOutlet weak var navigationItemContainer : UIView!
    
    @IBOutlet weak var hbMenuButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var wardrobeButton: UIButton!
    @IBOutlet weak var modelButton: UIButton!
    
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var notifCountLble: UILabel!
    
    var hbMenuOn : Bool = false
    
    var selectedButton : UIButton!
    
    var actionAfterLogin : ACTION_AFTER_LOGIN = ACTION_AFTER_LOGIN.none

    // MARK: -  Activity Indicator
    var faAnimatedHanger : FAAnimatedHanger!
    
    //var addressArray : [Address]!
    
    var selectedAddDict : [String : Address]!
    
    var activityView = UIActivityIndicatorView()
    
    var avilabilities : [CheckAvailablityItems] =  [CheckAvailablityItems]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.badgeView.layer.cornerRadius = 10
        self.badgeView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeContainerVC.wardroberServiceInitialised), name: NSNotification.Name(rawValue: Constants.kWardroberInitialisedNotification) , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeContainerVC.wardroberServiceInitialisationFailed), name: NSNotification.Name(rawValue: Constants.kWardroberInitialisedFailNotification) , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeContainerVC.itemsPresentInCartCount), name: NSNotification.Name(rawValue: Constants.kItemsPresentInCartNotification), object: nil)
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.color = UIColor.black
        activityView.center = self.view.center
        
        self.view.addSubview(activityView)
        
        if Wardrober.shared().state != WardroberState.modelInfoFetched
        {
            self.setProgressHudHidden(false)
        }
        
        
        self.disableButtons([self.homeButton])
        self.selectButtons([self.homeButton])
        self.selectedButton = self.homeButton
        
        let storyBoard = UIStoryboard(name: "Main", bundle:Bundle(for: Wardrober.self))
        self.homeNavigationController = storyBoard.instantiateViewController(withIdentifier: "HomeNavigationController") as? BaseNavigationController
       
        self.homeNavigationController!.delegate = self
        
        let landingPageVC = self.homeNavigationController?.viewControllers[0] as! FACategoryVC
        
        landingPageVC.homeContainerVC = self
        
        self.slideMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as? SlideMenuVC

        self.slideMenuVC?.homeContainerVC = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeContainerVC.hbMenuAppeared), name: NSNotification.Name(rawValue: Constants.kSlideMenuAppearedNotification) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeContainerVC.hbMenuDisappeared), name: NSNotification.Name(rawValue: Constants.kSlideMenuDisappearedNotification) , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeContainerVC.checkOutBtnTapped(_:)), name: NSNotification.Name(rawValue: Constants.kCheckOutBtnTappedNotif) , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeContainerVC.loadSignController), name: NSNotification.Name(rawValue: Constants.kUserNotSignedIn) , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeContainerVC.loadSignControllerFromItemDetailVC), name: NSNotification.Name(rawValue: Constants.kUserNotSignedInFromItemDetailVC) , object: nil)
        
        

        self.presentHomeNavigationController();
        self.loadSlideMenuVC()
        
        navigationItemContainer.layer.shadowColor = UIColor.black.cgColor
        navigationItemContainer.layer.shadowOffset = CGSize(width: 0, height: 1)
        navigationItemContainer.layer.shadowOpacity = 0.15
        navigationItemContainer.layer.shadowRadius = 4
        
        
        let firstLaunch = UserDefaults.standard.bool(forKey: Constants.kFirstLaunch)
        
        if firstLaunch == true
        {
            self.perform(#selector(HomeContainerVC.presentTutorial), with: nil, afterDelay: 0.01)
            
            return
            
        }
        
    }

    @objc func itemsPresentInCartCount(_ notification : Notification)
    {
        
        if let itemsCartDict = notification.userInfo as? [String: Any]
        {
            if let itemsCount = itemsCartDict["cartItemsCount"] as? Int
            {
                if itemsCount>0
                {
                    self.badgeView.isHidden = false
                    self.notifCountLble.text = String(format: "%d",itemsCount)
                }
                else
                {
                    self.badgeView.isHidden = true
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func presentHomeNavigationController()
    {
        
        self.childContentView.translatesAutoresizingMaskIntoConstraints = false;

        
        let childView = homeNavigationController!.view
        childView?.translatesAutoresizingMaskIntoConstraints = false;
        
        self.addChildViewController(homeNavigationController!)
        homeNavigationController!.didMove(toParentViewController: self)
        self.childContentView.addSubview(childView!)
        self.childContentView.clipsToBounds = true;
        
        self.childContentView.addConstraint(NSLayoutConstraint(item: self.childContentView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0.0))
        self.childContentView.addConstraint(NSLayoutConstraint(item: self.childContentView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0))
        self.childContentView.addConstraint(NSLayoutConstraint(item: self.childContentView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0))
        self.childContentView.addConstraint(NSLayoutConstraint(item: self.childContentView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
        
        self.view.setNeedsLayout()
        
        self.view.layoutIfNeeded()

        
    }
    
    
    func loadSlideMenuVC()
    {
        let childView = self.slideMenuVC!.view
        childView?.translatesAutoresizingMaskIntoConstraints = false;
        
        self.addChildViewController(slideMenuVC!)
        slideMenuVC!.didMove(toParentViewController: self)
        self.childContentView.addSubview(childView!)
        self.childContentView.clipsToBounds = true;
        
        self.childContentView.addConstraint(NSLayoutConstraint(item: self.childContentView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0.0))
        self.childContentView.addConstraint(NSLayoutConstraint(item: self.childContentView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0))
        self.childContentView.addConstraint(NSLayoutConstraint(item: self.childContentView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0))
        self.childContentView.addConstraint(NSLayoutConstraint(item: self.childContentView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
       self.slideMenuVC!.view.isHidden = true;
        
        
    }
    
    func unhideSlideMenuVC()
    {
        
        self.slideMenuVC!.view.isHidden = false;
        
        self.slideMenuVC!.performFadeInAnimation()
    }
    
    func hideSlideMenuVC()
    {

        self.slideMenuVC!.performFadeOutAnimation()

    }
    

    
    
    func enableButtons(_ menuButtons : [UIButton]?)
    {
        if let buttons = menuButtons
        {
            for menuButton in buttons
            {
                menuButton.isUserInteractionEnabled = true
            }
        }
        else
        {
            hbMenuButton.isUserInteractionEnabled = true
            homeButton.isUserInteractionEnabled = true
            wardrobeButton.isUserInteractionEnabled = true
            modelButton.isUserInteractionEnabled = true
            cartButton.isUserInteractionEnabled = true
        }
    }
    
    
    
    func disableButtons(_ menuButtons : [UIButton]?)
    {
        if let buttons = menuButtons
        {
            for menuButton in buttons
            {
                menuButton.isUserInteractionEnabled = false
            }
        }
        else
        {
            hbMenuButton.isUserInteractionEnabled = false
            homeButton.isUserInteractionEnabled = false
            wardrobeButton.isUserInteractionEnabled = false
            modelButton.isUserInteractionEnabled = false
            cartButton.isUserInteractionEnabled = false
        }
        
    }
    
    
    func selectButtons(_ menuButtons : [UIButton]?)
    {
        if let buttons = menuButtons
        {
            for menuButton in buttons
            {
                menuButton.tintColor = Constants.GeneralSelectedColor
            }
        }
        else
        {
            hbMenuButton.tintColor = Constants.GeneralSelectedColor
            homeButton.tintColor = Constants.GeneralSelectedColor
            wardrobeButton.tintColor = Constants.GeneralSelectedColor
            modelButton.tintColor = Constants.GeneralSelectedColor
            cartButton.tintColor = Constants.GeneralSelectedColor
        }
    }
    
    func unselectButtons(_ menuButtons : [UIButton]?)
    {
        if let buttons = menuButtons
        {
            for menuButton in buttons
            {
                menuButton.tintColor = Constants.GeneralUnselectedColor
            }
        }
        else
        {
            hbMenuButton.tintColor = Constants.GeneralUnselectedColor
            homeButton.tintColor = Constants.GeneralUnselectedColor
            wardrobeButton.tintColor = Constants.GeneralUnselectedColor
            modelButton.tintColor = Constants.GeneralUnselectedColor
            cartButton.tintColor = Constants.GeneralUnselectedColor
        }
        
    }

    // MARK: - Wardrober Initialisation Notification
    @objc func wardroberServiceInitialised()
    {
        self.setProgressHudHidden(true)
        
        //Load Categories if they aren't available - will be done once per Wardrober invocation

    }
    
    func setProgressHudHidden(_ hidden : Bool)
    {
        
        if hidden == false
        {
            let storyBoard = UIStoryboard(name: "Checkout", bundle:Bundle(for: Wardrober.self))
            self.faAnimatedHanger = storyBoard.instantiateViewController(withIdentifier: "FAAnimatedHanger") as? FAAnimatedHanger
            
            let childView = self.faAnimatedHanger!.view
            childView?.translatesAutoresizingMaskIntoConstraints = false;
            
            self.addChildViewController(faAnimatedHanger)
            faAnimatedHanger!.didMove(toParentViewController: self)
            self.view.addSubview(childView!)
            self.view.clipsToBounds = true
            
            let xConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0)
            
            let yConstraint =  NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0)
            
            let tConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0)
            
            let bConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: childView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
            
            self.view.addConstraints([xConstraint, yConstraint, tConstraint, bConstraint])
            
            self.faAnimatedHanger.view.layoutIfNeeded()
            
        }
        else
        {
            //hide
            self.faAnimatedHanger.view.removeFromSuperview()
        }
    }

    // MARK: - Wardrober Initialisation Failed Notification
    @objc func wardroberServiceInitialisationFailed()
    {
        self.setProgressHudHidden(true)

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
        {
            Wardrober.exit(animated: true)
        }
    }
    
    // MARK: - HBMenu Notifications
    @objc func hbMenuAppeared()
    {
        self.hbMenuOn = true
        self.enableButtons(nil)
        self.disableButtons([self.selectedButton])

    }
    
    @objc func hbMenuDisappeared()
    {
        self.hbMenuOn = false
        self.enableButtons(nil)
        self.disableButtons([self.selectedButton])

    }

    // MARK: - IBActions
    
    @IBAction func hbMenuTapped(_ sender : UIButton)
    {
        self.disableButtons(nil)
        
        if self.hbMenuOn == false
        {
            unhideSlideMenuVC()
        }
        else
        {
            hideSlideMenuVC()
        }
    }

    @IBAction func homeTapped(_ sender : UIButton)
    {
        if hbMenuOn == true
        {
            self.hideSlideMenuVC()
        }
        
        self.disableButtons(nil)
        
        self.homeNavigationController?.popToRootViewController(animated: true)

        
    }
    
    @IBAction func WardrobeTapped(_ sender : UIButton)
    {
        if hbMenuOn == true
        {
            self.hideSlideMenuVC()
        }
        
        let userSignedIn =   UserDefaults.standard.bool(forKey: Constants.kUserSuccessfullySignedIn)
        
        if userSignedIn == true
        {
            self.disableButtons(nil)
            
            let storyBoard = UIStoryboard(name: "Main", bundle:Bundle(for: Wardrober.self))
            if let wardrobeVC = storyBoard.instantiateViewController(withIdentifier: "WardrobeVC") as? WardrobeVC
            {
                wardrobeVC.homeContainerVC = self
                self.homeNavigationController?.popToRootViewController(animated: false)
                self.homeNavigationController?.pushViewController(wardrobeVC, animated: false)
                
            }
        }
        else
        {
            self.actionAfterLogin = ACTION_AFTER_LOGIN.wardrobe_SHOW
            
            self.presentSignController()
        }
        
    }
    
    @IBAction func ModelTapped(_ sender : UIButton)
    {
        if hbMenuOn == true
        {
            self.hideSlideMenuVC()
        }
        
        self.disableButtons(nil)
        
        let storyBoard = UIStoryboard(name: "Main", bundle:Bundle(for: Wardrober.self))
        if let modelVC = storyBoard.instantiateViewController(withIdentifier: "_DModelVC") as? ModelVC
        {
            modelVC.selectedCategoryIndex = 0
            modelVC.homeContainerVC = self

            self.homeNavigationController?.popToRootViewController(animated: false)
        
            self.homeNavigationController?.pushViewController(modelVC, animated: false)

        }

    }
    
    @IBAction func CartTapped(_ sender : UIButton)
    {
        if hbMenuOn == true
        {
            self.hideSlideMenuVC()
        }
        
        self.disableButtons(nil)
        
        let storyBoard = UIStoryboard(name: "Checkout", bundle:Bundle(for: Wardrober.self))
        if let cartVC = storyBoard.instantiateViewController(withIdentifier: "ShoppingCart") as? ShoppingCart
        {
            
            self.homeNavigationController?.popToRootViewController(animated: false)
            self.homeNavigationController?.pushViewController(cartVC, animated: false)

        }

    }
    
    func checkItemsAvailablity()
    {
        var checkAvailablityItems = [[String: String]]()
        
        for item in FACart.sharedCart().getCartItems()
        {
            var dict = [String : String]()
            dict["ProductItemID"] = item.itemProductID
            dict["Size"] = item.sizeSelected?.itemSizeName
            //print(item.sizeSelected?.itemSizeName!)

            checkAvailablityItems.append(dict)
        }
        
        let cartItems = ["Cartitems" : checkAvailablityItems]
        print(cartItems)
        
        //self.activityView.startAnimating()
            
        let urlString = String(format: "http://65.19.149.190/dev.stanleykorshakv1/ClientApi/WardrobeClientApi.svc/CheckProductAvailability")
        
        self.avilabilities.removeAll()
            
        FAServiceHelper().post(url: urlString, parameters: cartItems as NSDictionary  , completion : { (success : Bool?, message : String?, responseObject : AnyObject?) in
                
                //self.activityView.stopAnimating()
                
                guard success == true else
                {
                    let alert=UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert);
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                guard responseObject == nil else
                {
                    self.avilabilities =  AvailabilityHelper.getAvailabilityHelper(responseObject! as AnyObject?)!
                    
                    for item in self.avilabilities
                    {
                        let productID = item.productItemID as Int
                        let avilable = item.avilability
                        //let avilable = false
                        let _ = item.size
                        
                        if avilable == false
                        {
                            print("This ID \(productID), Sold out")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "SoldoutAlert"), object: nil)
                            return
                        }
                    }
                    self.getAddressService()
                    return
                }
            })
    }
    
    @objc func checkOutBtnTapped(_ notification: NSNotification)
    {
        let userSignedIn = UserDefaults.standard.bool(forKey: Constants.kUserSuccessfullySignedIn)
        
        if userSignedIn == true
        {
           //self.getAddressService()
            self.checkItemsAvailablity()
        }
        else
        {
           self.actionAfterLogin = ACTION_AFTER_LOGIN.address_SHOW
           self.presentSignController()
        }
    }
    
    @objc func presentSignController()
    {
        self.presentSignInVC()
    }
    
    @objc func loadSignController()
    {
        //self.actionAfterLogin = ACTION_AFTER_LOGIN.wardrobe_SHOW
        self.actionAfterLogin = ACTION_AFTER_LOGIN.none
        self.presentSignInVC()
    }
    
    @objc func loadSignControllerFromItemDetailVC()
    {
        self.actionAfterLogin = ACTION_AFTER_LOGIN.none
        self.presentSignInVC()
    }
    
    func presentSignInVC()
    {
        let storyBoard = UIStoryboard(name: "SignIn", bundle:Bundle(for: Wardrober.self))
        let siginController = storyBoard.instantiateViewController(withIdentifier: "singIn") as? SignInController
        siginController!.delegate = self
        
        let signNavigationVC = UINavigationController.init(rootViewController: siginController!)
        
        self.present(signNavigationVC, animated: true, completion: nil)
    }
    // MARK: - SignInDelegate methods
    
    func signInControllerDidLogin(_ signInVC: SignInController)
    {
        signInVC.dismiss(animated: true)
        {
            let userSignedIn =   UserDefaults.standard.bool(forKey: Constants.kUserSuccessfullySignedIn)
            
            if userSignedIn == true
            {
                if self.actionAfterLogin == ACTION_AFTER_LOGIN.wardrobe_SHOW
                {
                    self.actionAfterLogin = .none
                    
                    self.WardrobeTapped(self.wardrobeButton)
                }
                else if self.actionAfterLogin == ACTION_AFTER_LOGIN.address_SHOW
                {
                    self.actionAfterLogin = .none
                    
                    //self.getAddressService()
                    self.checkItemsAvailablity()
                }
            }
        }
    }
    
    func signUpControllerDidRegisterSuccessfully(_ signUpVC: SignUpController)
    {
        signUpVC.dismiss(animated: true)
        {
            let userSignedIn = UserDefaults.standard.bool(forKey: Constants.kUserSuccessfullySignedIn)
            
            if userSignedIn == true
            {
                if self.actionAfterLogin == ACTION_AFTER_LOGIN.wardrobe_SHOW
                {
                    self.actionAfterLogin = .none
                        
                    self.WardrobeTapped(self.wardrobeButton)
                }
                else if self.actionAfterLogin == ACTION_AFTER_LOGIN.address_SHOW
                {
                    self.actionAfterLogin = .none
                    
                    //self.getAddressService()
                    self.checkItemsAvailablity()
                }
            }
            
        }
    }
    
    func signInControllerDidCancelLogin(_ signInVC: SignInController)
    {
        signInVC.dismiss(animated: true)
        {
            
        }
    }
    
    //DefaultAddressDelegate Methods
    /*func selectedDeliveryAddress(selectedAddress: [String : Address])
    {
        selectedAddDict = selectedAddress
        self.dismiss(animated: true, completion: nil)
    }*/
    
    
    //AddressContainerViewDelegate Methods
    func addressSaved()
    {
        self.dismiss(animated: false, completion: nil)
        
        let storyBoard = UIStoryboard(name: "Address", bundle:Bundle(for: Wardrober.self))
        let defaultAddVC = storyBoard.instantiateViewController(withIdentifier: "DefaultAddressViewController") as? DefaultAddressVC
        
        let addressNavigationVC = UINavigationController.init(rootViewController: defaultAddVC!)
        
        self.present(addressNavigationVC, animated: false, completion: nil)
    }
    
    func getAddressService()
    {
        self.activityView.startAnimating()
        
        let userCustomerId = UserDefaults.standard.string(forKey: Constants.kSignedInUserID)
        
        let urlString = String(format: "%@/GetShippingAddress/%@", arguments: [Urls.stanleyKorshakUrl,userCustomerId!]);
        
        //self.addressArray.removeAll()
        
        FAServiceHelper().get(url: urlString, completion : { (success : Bool?, message : String?, responseObject : AnyObject?) in
            
            self.activityView.stopAnimating()
            
            guard success == true else
            {
                return
            }
            
            guard responseObject == nil else
            {
                //self.addressArray =  AddressDetailesHelper.getAddressHelper(responseObject! as AnyObject?)
                
                if let getShippingAddResultsDict = responseObject!["GetShippingAddressResult"] as? NSDictionary
                {
                    if let _ = getShippingAddResultsDict["Error"] as? NSNull
                    {
                        if let resultsArray = getShippingAddResultsDict["Results"] as? [NSDictionary]
                        {
                            if resultsArray.count > 0
                            {
                                self.presentDefaultAddressController()
                            }
                            else
                            {
                                self.presentaddContainer()
                            }
                        }
                    }
                }
                return
            }
        })
    }
    
   
    
    func presentaddContainer()
    {
        let storyBoard = UIStoryboard(name: "Address", bundle:Bundle(for: Wardrober.self))
        let addContainerVC = storyBoard.instantiateViewController(withIdentifier: "AddContainerViewController") as? AddContainerVC
        addContainerVC!.fromWhichController = "HomeContainerVC"
        addContainerVC!.delegate = self
        let addContainerNavController = UINavigationController.init(rootViewController: addContainerVC!)
        
        self.present(addContainerNavController, animated: true, completion: nil)
    }
    
    func presentDefaultAddressController()
    {
        let storyBoard = UIStoryboard(name: "Address", bundle:Bundle(for: Wardrober.self))
        let defaultAddVC = storyBoard.instantiateViewController(withIdentifier: "DefaultAddressViewController") as? DefaultAddressVC
       
        let addressNavigationVC = UINavigationController.init(rootViewController: defaultAddVC!)
        
        self.present(addressNavigationVC, animated: true, completion: nil)
    }

    
    // MARK : - UINavigationController Delegate
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool)
    {
        
        self.enableButtons(nil)
        self.unselectButtons(nil)
        if viewController.isKind(of: FACategoryVC.self)
        {
            self.disableButtons([self.homeButton])
            self.selectButtons([self.homeButton])

            self.selectedButton = self.homeButton
        }
        else if viewController.isKind(of: WardrobeVC.self)
        {
            self.disableButtons([self.wardrobeButton])
            self.selectButtons([self.wardrobeButton])
            self.selectedButton = self.wardrobeButton

        }
        else if viewController.isKind(of: ModelVC.self)
        {
            self.disableButtons([self.modelButton])
            self.selectButtons([self.modelButton])
            self.selectedButton = self.modelButton
        }
        else if viewController.isKind(of: ShoppingCart.self)
        {
            self.disableButtons([self.cartButton])
            self.selectButtons([self.cartButton])
            self.selectedButton = self.cartButton
        }
    }
    
    
    // MARK: - Tutorial
    
    @objc func presentTutorial()
    {
        //print("tutorial tapped")
        let storyBoard = UIStoryboard(name: "Main", bundle:Bundle(for: Wardrober.self))
        let tutorialVC = storyBoard.instantiateViewController(withIdentifier: "FATutorialViewController") as? FATutorialViewController
        
        tutorialVC!.delegate = self
        self.present(tutorialVC!, animated: true, completion:
        {
            //print("after siginNavController animation finished")
        })
    }
    
    // MARK: - FATutorial View Controller Delegate

    func tutorialVCDidTapStartShopping(_ tutorialVC: FATutorialViewController)
    {
        self.dismiss(animated: true)
        {
            if self.hbMenuOn == true
            {
                self.hbMenuTapped(self.hbMenuButton)
            }
        }
    }
    
    //MARK:- Locking orientation to Portrait only
    open override var shouldAutorotate: Bool
    {
        return false
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation
    {
        return UIInterfaceOrientation.portrait
    }

}


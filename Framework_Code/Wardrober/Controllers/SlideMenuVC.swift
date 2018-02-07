//
//  SlideMenuVC.swift
//  Fashion180
//
//  Created by Yogi on 05/10/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//

import UIKit

enum ACTION_AFTER_LOGIN
{
    case wardrobe_SHOW
    case address_SHOW
    case none
}

class SlideMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate, SignInDelegate
{

    @IBOutlet var slideMenuLeadingConstraint : NSLayoutConstraint!
    @IBOutlet var bgView : UIView!
    @IBOutlet var sideMenuView : UIView!

    var sideMenuItemArray : [String] = ["Stanley Korshak", "CONTACT US", "TUTORIAL","LOGIN"]
    
    var sideMenuWidth : CGFloat!
    
    
    var firstLayout : Bool = true
    
    var homeContainerVC : HomeContainerVC!

    var userSignedIn : Bool! = false
    
    
    var actionAfterLogin : ACTION_AFTER_LOGIN = ACTION_AFTER_LOGIN.none
    
    
    @IBOutlet var slideMenuTableView : UITableView!
    var fontSize : CGFloat!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(SlideMenuVC.slideMenuDidAppear), name: NSNotification.Name(rawValue: Constants.kSlideMenuAppearedNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SlideMenuVC.slideMenuDidDisappear), name: NSNotification.Name(rawValue: Constants.kSlideMenuDisappearedNotification), object: nil)

        let tapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(SlideMenuVC.bgViewTapped))
        self.bgView.addGestureRecognizer(tapGestureRecog)

        self.bgView.alpha = 0
        
        switch (Constants.deviceIdiom)
        {
            
        case .pad:
            self.fontSize = 16
        case .phone:
            self.fontSize = 12
        default: break
            //print("Unspecified UI idiom")
            
        }

    }
    
    @objc func bgViewTapped()
    {
        self.performFadeOutAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    
    func performFadeInAnimation()
    {
        self.bgView.alpha = 0

        UIView.animate(withDuration: 0.3, animations: {
            
            self.bgView.alpha = 0.7
            //self.slideMenuLeadingConstraint.constant = 0
            
        }, completion: { (finished) in
            
            self.performSlideInAnimation()

        }) 
    }
    
    func performSlideInAnimation()
    {
        UIView.animate(withDuration: 0.3, animations: {
            
            self.slideMenuLeadingConstraint.constant = 0
            self.view.layoutIfNeeded()

        }, completion: { (finished) in

            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kSlideMenuAppearedNotification), object: nil)
        }) 
    }
    
    
    
    @objc func slideMenuDidAppear()
    {
        userSignedIn = UserDefaults.standard.bool(forKey: Constants.kUserSuccessfullySignedIn)
        
        self.reloadSlideMenuTable()

    }
    

    @objc func slideMenuDidDisappear()
    {
        
    }
    
    
    func reloadSlideMenuTable()
    {
        self.slideMenuTableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.fade)
    }
    
    func performFadeOutAnimation()
    {
        UIView.animate(withDuration: 0.3, animations: {
            
            self.slideMenuLeadingConstraint.constant = -self.sideMenuWidth
            
            self.view.layoutIfNeeded()
            
        }, completion: { (finished) in
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.bgView.alpha = 0
                
            }, completion: { (finished) in
                
                self.view.isHidden = true

                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kSlideMenuDisappearedNotification), object: nil)
            })
        }) 
    }
    
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        if(firstLayout)
        {
            sideMenuWidth = sideMenuView.bounds.size.width
            
            firstLayout = false;
            
            self.slideMenuLeadingConstraint.constant = -self.sideMenuWidth
        }
    }
    

    @IBAction func crossButtonTapped(_ sender : UIButton!)
    {
        self.performFadeOutAnimation()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SlideMenuVC
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch (Constants.deviceIdiom)
        {
        case .pad:
            return 60
        case .phone:
            return 40
        default:
            return 40
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sideMenuItemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell")
        
        let titleLabel = cell?.contentView.viewWithTag(999) as! UILabel
        
        if indexPath.row == self.sideMenuItemArray.index(of: "LOGIN")
        {
            if userSignedIn == true
            {
                titleLabel.text = "LOG OUT"
                sideMenuItemArray[3] = "LOG OUT"

            }
            else
            {
                titleLabel.text = "LOGIN"
                sideMenuItemArray[3] = "LOGIN"

            }
        }
        else
        {
            titleLabel.text = sideMenuItemArray[indexPath.row]

        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
    
        if indexPath.row == 0
        {
            if userSignedIn == false
            {
                //present sign in modally
                self.actionAfterLogin = ACTION_AFTER_LOGIN.wardrobe_SHOW
                self.presentSignIn()
                
            }
            else
            {
                // present Wardrobe
                self.homeContainerVC.WardrobeTapped(homeContainerVC.wardrobeButton)
                
            }
        }
        else if indexPath.row == 1
        {
            print("Coming soon")
        }
            
        else if indexPath.row == 2
        {
            self.homeContainerVC.presentTutorial()
        }
            
        if indexPath.row == 3
        {
            if userSignedIn == false
            {
                //present sign in modally
                self.actionAfterLogin = ACTION_AFTER_LOGIN.none
                self.presentSignIn()
            }
            else
            {
                UserDefaults.standard.set(false, forKey: Constants.kUserSuccessfullySignedIn)
                UserDefaults.standard.removeObject(forKey: Constants.kSignedInUserID)
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kUserSuccessfullySignedOutNotif), object: nil)
                
                FACart.sharedCart().removeAllCartItems()
                
                let cartItemsCountDict: [String: Any] = ["cartItemsCount": FACart.sharedCart().getCartCount(), "Notif": "Notif"]
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.kItemsPresentInCartNotification), object: nil, userInfo: cartItemsCountDict)


                self.userSignedIn = false
                
                sideMenuItemArray[3] = "LOGIN"
                
                self.reloadSlideMenuTable()
            }
        }
    }
    
    func presentSignIn()
    {
    
        let storyBoard = UIStoryboard(name: "SignIn", bundle: Bundle(for: Wardrober.self))
        let siginController = storyBoard.instantiateViewController(withIdentifier: "singIn") as? SignInController
        
        siginController!.delegate = self
        
        let signNavigationVC = UINavigationController.init(rootViewController: siginController!)
        
        self.present(signNavigationVC, animated: true, completion:
        {
            
        })
        
        //let signNavigationVC = UINavigationController.init(rootViewController: siginController!)
        //let siginNavController = storyBoard.instantiateViewController(withIdentifier: "") as? UINavigationController
        //let signInController = siginNavController?.viewControllers[0] as? SignInController
    }
    
    // MARK: - SignInDelegate methods
    
    func signInControllerDidLogin(_ signInVC: SignInController)
    {
        signInVC.dismiss(animated: true)
        {
            self.userSignedIn =   UserDefaults.standard.bool(forKey: Constants.kUserSuccessfullySignedIn)
            
            self.reloadSlideMenuTable()
            
            if self.actionAfterLogin == ACTION_AFTER_LOGIN.wardrobe_SHOW
            {
                self.actionAfterLogin = .none
                
                self.homeContainerVC.WardrobeTapped(self.homeContainerVC.wardrobeButton)
            }
        }
    }
    
    func signUpControllerDidRegisterSuccessfully(_ signUpVC: SignUpController)
    {
        signUpVC.dismiss(animated: true)
        {
            self.userSignedIn =   UserDefaults.standard.bool(forKey: Constants.kUserSuccessfullySignedIn)
            
            self.reloadSlideMenuTable()
            
            if self.actionAfterLogin == ACTION_AFTER_LOGIN.wardrobe_SHOW
            {
                self.actionAfterLogin = .none
                
                self.homeContainerVC.WardrobeTapped(self.homeContainerVC.wardrobeButton)
            }
        }
    }
    
    func signInControllerDidCancelLogin(_ signInVC: SignInController)
    {
        signInVC.dismiss(animated: true)
        {
            
        }
    }
}



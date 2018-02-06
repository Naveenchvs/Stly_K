//
//  LandingPageVC.swift
//  Fashion180
//
//  Created by Yogi on 05/10/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//

import UIKit

class LandingPageVC: UIViewController, ShoppingCartDelegate {


    @IBOutlet var gridUnitWidthConstraint : NSLayoutConstraint!
    @IBOutlet var gridUnitHeightConstraint : NSLayoutConstraint!
    @IBOutlet var gridContainerView : UIView!

    @IBOutlet var NewFallGridView : UIView!
    @IBOutlet var CasualGridView : UIView!
    @IBOutlet var WeddingGridView : UIView!
    @IBOutlet var PartyGridView : UIView!
    @IBOutlet var Casual2GridView : UIView!

    
    @IBOutlet var NewFallLabel : UILabel!
    @IBOutlet var CasualLabel : UILabel!
    @IBOutlet var WeddingLabel : UILabel!
    @IBOutlet var PartyLabel : UILabel!
    @IBOutlet var Casual2Label : UILabel!
    
    
    var firstLayout : Bool = true
    
    var homeContainerVC : HomeContainerVC!
    
    var selectedCategoryIndex : Int!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.NewFallGridView.alpha = 0
        self.CasualGridView.alpha = 0
        self.WeddingGridView.alpha = 0
        self.PartyGridView.alpha = 0
        self.Casual2GridView.alpha = 0

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 16
        let roundedfontSize = floor(fontSize)
        
        
        self.NewFallLabel.font = self.NewFallLabel.font.withSize(roundedfontSize)
        self.CasualLabel.font = self.CasualLabel.font.withSize(roundedfontSize)
        self.WeddingLabel.font = self.WeddingLabel.font.withSize(roundedfontSize)
        self.PartyLabel.font = self.PartyLabel.font.withSize(roundedfontSize)
        self.Casual2Label.font = self.Casual2Label.font.withSize(roundedfontSize)

        self.view.layoutIfNeeded()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func shopButtonTapped(_ sender : UIButton!)
    {
        ///print("tag \(sender.tag)")
        
        self.selectedCategoryIndex = sender.tag - 1
        
        self.performSegue(withIdentifier: "LandingTo2Dmodel", sender: self)
        
    }
    
    
    @IBAction func hamburgerMenuTapped(_ sender : UIBarButtonItem!)
    {
        self.homeContainerVC.unhideSlideMenuVC()
    }
    
    
    
    func fadeInAnimateGridViews()
    {
        let unitDuration = 0.1
        
        UIView.animate(withDuration: unitDuration, animations: {
            self.NewFallGridView.alpha = 1
        }, completion: { (finished) in
            
            
            UIView.animate(withDuration: unitDuration, animations: {
                self.CasualGridView.alpha = 1
                
                }, completion: { (finished) in
                    
                    
                    UIView.animate(withDuration: unitDuration, animations: {
                        self.WeddingGridView.alpha = 1
                        
                        }, completion: { (finished) in
                            
                            
                            UIView.animate(withDuration: unitDuration, animations: {
                                self.PartyGridView.alpha = 1
                                
                                }, completion: { (finished) in
                                    
                                    
                                    UIView.animate(withDuration: unitDuration, animations: {
                                        self.Casual2GridView.alpha = 1
                                        
                                        }, completion: { (finished) in
                                            
                                            
                                            
                                    })
                                    
                            })
                            
                    })
                    
            })
            
            
        }) 
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        if(firstLayout)
        {
            gridUnitWidthConstraint.constant = (gridContainerView.bounds.width - 6) / 3
            gridUnitHeightConstraint.constant = (gridContainerView.bounds.height - 6) / 3
            
            self.view.layoutIfNeeded()
            
            firstLayout = false;
            
            self.fadeInAnimateGridViews()

        }
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func wishlistButtonTapped(_ sender : UIButton!)
    {
//        let userSignedIn =   UserDefaults.standard.bool(forKey: Constants.kUserSuccessfullySignedIn)
//        
//        
//        if userSignedIn == false
//        {
//            //present sign in modally
//            
//            ///print("login tapped")
//            
//            let storyBoard = UIStoryboard(name: "SignIn", bundle:Bundle(for: Wardrober.self))
//            let siginNavController = storyBoard.instantiateViewController(withIdentifier: "signInNavigationController") as? UINavigationController
//            
//            
//            ///print("siginNavController loaded")
//            
//            let signInController = siginNavController?.viewControllers[0] as? SignInController
//            signInController!.delegate = self
//            
//            ///print("after siginNavController loaded")
//            
//            
//            self.present(siginNavController!, animated: true, completion: {
//                ///print("after siginNavController animation finished")
//                
//                
//            })
//            
//        }
//        else
//        {
//            /// show wishlist
//        }
        
    }
    
    @IBAction func wardrobeButtonTapped(_ sender : UIButton!)
    {
        let userSignedIn =   UserDefaults.standard.bool(forKey: Constants.kUserSuccessfullySignedIn)
        
        
        if userSignedIn == false
        {
            //present sign in modally
            
//            ///print("login tapped")
//            
//            let storyBoard = UIStoryboard(name: "SignIn", bundle:Bundle(for: Wardrober.self))
//            let siginNavController = storyBoard.instantiateViewController(withIdentifier: "signInNavigationController") as? UINavigationController
//            
//            
//            ///print("siginNavController loaded")
//            
//            let signInController = siginNavController?.viewControllers[0] as? SignInController
//            signInController!.delegate = self
//            
//            ///print("after siginNavController loaded")
//            
//            
//            self.present(siginNavController!, animated: true, completion: {
//                ///print("after siginNavController animation finished")
//                
//                
//            })
            
        }
        else
        {
            /// show wardrobe
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle(for: Wardrober.self))
            
            let wardrobeVC = mainStoryboard.instantiateViewController(withIdentifier: "WardrobeVC")
            
            self.navigationController?.pushViewController(wardrobeVC, animated: true)
            
        }

    }
    
    
        
    
    // MARK: - Shopping Cart Navigation
    
    func pushShoppingCartVC()
    {
        let storyBoard = UIStoryboard(name: "Checkout", bundle:Bundle(for: Wardrober.self))
        let shoppingCartController = storyBoard.instantiateViewController(withIdentifier: "ShoppingCart") as? ShoppingCart
        shoppingCartController!.delegate = self
        self.navigationController?.pushViewController(shoppingCartController!, animated: true)
    }

    
    @IBAction func cartButtonTapped()
    {
        self.pushShoppingCartVC()
    }
    
    // MARK: - Shopping Cart Delegate
    func shoppingCartDidTapBackButton(_ shoppingCart: ShoppingCart!) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "LandingTo2Dmodel"
        {
           let modelVC =  segue.destination as! ModelVC
            
            modelVC.homeContainerVC = self.homeContainerVC
            modelVC.selectedCategoryIndex = self.selectedCategoryIndex
        }
        
    }
 

}

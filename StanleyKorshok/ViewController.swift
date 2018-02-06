//
//  ViewController.swift
//  StanleyKorshok
//
//  Created by Saraschandra on 09/01/18.
//  Copyright © 2018 Mobiware. All rights reserved.
//

import UIKit
import Wardrober

class ViewController: UIViewController
{

    @IBOutlet var openBtn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.navigateToStanleyKorshak()
    }
    
    
    func navigateToStanleyKorshak()
    {
        Wardrober.initialiseWith(clientID: "client12208977-95e5-4a0e-acc7-d5347aca074a", secret: "5o6h64jwa4zd8uab809cfmu3gj70qt5tb97q872oubn5k2nvh7sb677s4cbx6sgr9fc9wtdb7use9zsn5ltsa4wdbpw55fsc566f0o9x4relp3tfty1u9xqe", delegate : self)
        
        Wardrober.launch(fromViewController: self, animated: true)
    }
    
    @IBAction func openBtnAction(_ sender: UIButton)
    {
        //DUMMY
       // Wardrober.initialiseWith(clientID: "client12208977-95e5-4a0e-acc7-d5347aca074a", secret: "5o6h64jwa4zd8uab809cfmu3gj70qt5tb97q872oubn5k2nvh7sb677s4cbx6sgr9fc9wtdb7use9zsn5ltsa4wdbpw55fsc566f0o9x4relp3tfty1u9xqe", delegate : self)
        
        Wardrober.initialiseWith(clientID: "client12208977-95e5-4a0e-acc7-d5347aca074a", secret: "5o6h64jwa4zd8uab809cfmu3gj70qt5tb97q872oubn5k2nvh7sb677s4cbx6sgr9fc9wtdb7use9zsn5ltsa4wdbpw55fsc566f0o9x4relp3tfty1u9xqe", delegate : self)
        
        Wardrober.launch(fromViewController: self, animated: true)
        
        //Subscribing To Wardrober Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.anItemAddedToWardrobe), name: WardroberNotifications.ItemAddedToWardrobe, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.anItemRemovedFromWardrobe), name: WardroberNotifications.ItemRemovedFromWardrobe, object: nil)


        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.anItemAddedToCart), name: WardroberNotifications.ItemAddedToCart, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.anItemRemovedFromCart), name: WardroberNotifications.ItemRemovedFromCart, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.willExit), name: WardroberNotifications.WillExit, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.checkoutTapped), name: WardroberNotifications.CheckoutTapped, object: nil)
    }
    
    //MARK:- Wardrober Notifications Handling :-
    
    @objc func anItemAddedToWardrobe(notification : Notification)
    {
        if let item = notification.object as? WRItem
        {
            print("Notification anItemAddedToWardrobe  - \(item.itemProductID)")
        }
    }
    
    @objc func anItemRemovedFromWardrobe(notification : Notification)
    {
        if let item = notification.object as? WRItem
        {
            print("Notification anItemRemovedFromWardrobe  - \(item.itemProductID)")
        }
    }
    
    @objc func anItemAddedToCart(notification : Notification)
    {
        if let item = notification.object as? WRCartItem
        {
            print("Notification anItemAddedToCart  - \(item.itemProductID)")
        }
    }
    
    @objc func anItemRemovedFromCart(notification : Notification)
    {
        if let item = notification.object as? WRCartItem
        {
            print("Notification anItemRemovedFromCart  - \(item.itemProductID)")
        }
    }
    
    @objc func willExit(notification : Notification)
    {
        print("Notification willExit ")
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    @objc func checkoutTapped(notification : Notification)
    {
        if let items = notification.object as? [WRCartItem]
        {
            print("Notification checkoutTapped  count -  \(items.count)")
        }
        
        NotificationCenter.default.removeObserver(self)
        
    }
}

//MARK:- Handling Wardrober Delegate calls.
extension ViewController : WardroberDelegate
{
    func wardroberAddedAnItemToWardrobe(item: WRItem)
    {
        print("wardroberAddedAnItemToWardrobe  - \(item.itemProductID)")
    }
    
    func wardroberRemovedAnItemFromWardrobe(item: WRItem)
    {
        print("wardroberRemovedAnItemFromWardrobe  - \(item.itemProductID)")
    }
    
    func wardroberAddedAnItemToCart(item: WRCartItem)
    {
        print("wardroberAddedAnItemToCart  - \(item.itemProductID), size selected - \(item.sizeSelected)")
    }
    
    
    func wardroberRemovedAnItemFromCart(item: WRCartItem)
    {
        print("wardroberRemovedAnItemFromCart  - \(item.itemProductID)")
    }
    
    func wardroberWillExit()
    {
        print("wardroberWillExit")
        NotificationCenter.default.removeObserver(self)
    }
    
    func wardroberCheckoutTappedWithCartItems(items: [WRCartItem])
    {
        print("wardroberCheckoutTappedWithCartItems count - \(items.count)")
        NotificationCenter.default.removeObserver(self)
    }
    
}

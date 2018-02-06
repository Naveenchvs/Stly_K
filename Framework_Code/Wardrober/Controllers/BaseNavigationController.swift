//
//  BaseNavigationControllerViewController.swift
//  CalenShare
//
//  Created by Yogi on 24/12/14.
//  Copyright (c) 2014 Mobiware. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.barStyle = UIBarStyle.black
        self.navigationBar.barTintColor = UIColor(red : 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0) //838383
        //self.navigationBar.barTintColor = UIColor(red : 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0) //f5f5f5
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont(name : "HelveticaNeue-Bold", size : 14)!]
        
        let customFont = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font : customFont!], for: UIControlState())
 
        
        
    }

    
    //MARK:- Locking orientation to Portrait only
    open override var shouldAutorotate: Bool {
        return false
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        
        return UIInterfaceOrientation.portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

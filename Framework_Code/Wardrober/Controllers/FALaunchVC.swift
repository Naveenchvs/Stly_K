//
//  FALaunchVC.swift
//  Fashion180
//
//  Created by Yogi on 17/03/17.
//  Copyright © 2017 Mobiware. All rights reserved.
//

import UIKit

class FALaunchVC: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.perform(#selector(FALaunchVC.launchCompleted), with: nil, afterDelay: 2)
    }
    
    @IBAction func show()
    {
        //Wardrober.initialiseWith(clientID: "client.9ffb1eB0190846ae8cf3bad500955426", secret: "18bb5caea9030a9961D2923d9e420dbf8b459c7e0cbb02928acbf25b3544562a")
        
        Wardrober.initialiseWith(clientID: "6E7FA1A7-6803-4397-A819-DC793E2CBWFT", secret: "27bb5caea9030a9961b2923d9e420dbf8b459c7e0cbb02928acbf25b35445WFT")
        
        Wardrober.launch(fromViewController: self, animated : false)
        
    }
    
    @objc func launchCompleted()
    {
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let homeController = storyboard.instantiateViewController(withIdentifier: "HomeContainerVC") as! HomeContainerVC
        
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.window?.rootViewController = homeController
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

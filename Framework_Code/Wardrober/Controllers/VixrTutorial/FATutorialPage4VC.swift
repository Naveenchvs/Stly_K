//
//  FATutorialPage4VC.swift
//  FATutorial
//
//  Created by Srinivas Peddinti on 1/12/17.
//  Copyright © 2017 MobiwareInc. All rights reserved.
//

import UIKit

@objc class FATutorialPage4VC: FATutorialPageBase {

    @IBOutlet var gotItLable : UILabel!

    @IBOutlet var startShoppingBtn : UIButton!


    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let fontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 17
        let roundedfontSize = floor(fontSize)
        
        self.gotItLable.font = self.gotItLable.font.withSize(roundedfontSize)
        
        self.startShoppingBtn.titleLabel?.font.withSize(roundedfontSize
        )
        
        self.startShoppingBtn.layer.masksToBounds = false
        self.startShoppingBtn.layer.shadowRadius = 1.0
        self.startShoppingBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.startShoppingBtn.layer.shadowOpacity = 1.0
        self.startShoppingBtn.layer.shadowColor = UIColor.black.cgColor

        self.startShoppingBtn.layer.cornerRadius = 22
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startShoppingButtonTapped(){
        
        self.tutDelegate.startShoppingDidTap()
        
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

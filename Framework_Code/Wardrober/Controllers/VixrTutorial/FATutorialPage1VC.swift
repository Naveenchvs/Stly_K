//
//  FATutorialPage1VC.swift
//  FATutorial
//
//  Created by Srinivas Peddinti on 1/12/17.
//  Copyright © 2017 MobiwareInc. All rights reserved.
//

import UIKit




@objc class FATutorialPage1VC: FATutorialPageBase {

    @IBOutlet weak var nameViewTop_Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var wardrobeTutorialImageView: UIImageView!

    @IBOutlet var welcomeLabel : UILabel!
    @IBOutlet var inventoryLabel : UILabel!
    @IBOutlet var skipLabel : UILabel!

    let screenSize: CGRect = UIScreen.main.bounds


    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(screenSize.size.width <= 480)
        {
            self.nameViewTop_Constraint.constant = 10
            
        }
        
        let fontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 17
        let roundedfontSize = floor(fontSize)
        
        self.welcomeLabel.font = self.welcomeLabel.font.withSize(roundedfontSize)
        self.inventoryLabel.font = self.inventoryLabel.font.withSize(roundedfontSize)
        self.skipLabel.font = self.skipLabel.font.withSize(roundedfontSize)
        
    let imageConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: wardrobeTutorialImageView, attribute: NSLayoutAttribute.height, multiplier: (wardrobeTutorialImageView.frame.size.height / wardrobeTutorialImageView.frame.size.width) * 0.9, constant: 0.0)
        
        self.view.addConstraint(imageConstraint)
        
        self.view.layoutIfNeeded()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    @IBAction func skipButtonTapped(){
        
        
        
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

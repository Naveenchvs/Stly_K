//
//  FATutorialPage2VC.swift
//  FATutorial
//
//  Created by Srinivas Peddinti on 1/12/17.
//  Copyright © 2017 MobiwareInc. All rights reserved.
//

import UIKit

@objc class FATutorialPage2VC: FATutorialPageBase {

    @IBOutlet weak var nameViewTop_Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var wardrobeTutorialDraggingImageView: UIImageView!
    
    @IBOutlet var slideLabel : UILabel!
    //@IBOutlet var newLookLabel : UILabel!
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
        
        self.slideLabel.font = self.slideLabel.font.withSize(roundedfontSize)
        //self.newLookLabel.font = self.newLookLabel.font.withSize(roundedfontSize)
        self.skipLabel.font = self.skipLabel.font.withSize(roundedfontSize)
        
        let imageConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: wardrobeTutorialDraggingImageView, attribute: NSLayoutAttribute.height, multiplier: (wardrobeTutorialDraggingImageView.frame.size.height / wardrobeTutorialDraggingImageView.frame.size.width) * 0.9, constant: 0.0)
        
        self.view.addConstraint(imageConstraint)
        
        self.view.layoutIfNeeded()
        
    }
    
    
    @IBAction func skipButtonTapped(){
        
        
        
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

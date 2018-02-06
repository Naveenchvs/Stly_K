//
//  FAAnimatedHanger.swift
//  Fashion180
//
//  Created by Srinivas Peddinti on 12/15/17.
//  Copyright © 2017 Mobiware. All rights reserved.
//

import UIKit

class FAAnimatedHanger: UIViewController
{

    @IBOutlet var hangerImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.startAnimatingHanger()
    }
    func startAnimatingHanger()
    {
        
        UIView.animate(withDuration: 2, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            
            self.hangerImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
            
        }) { (finished) -> Void in
            
            UIView.animate(withDuration: 2, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                
                self.hangerImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            }) { (finished) -> Void in
                self.startAnimatingHanger()
                
                
            }
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  FAProgressHud.swift
//  Fashion180
//
//  Created by Srinivas Peddinti on 5/12/17.
//  Copyright © 2017 Mobiware. All rights reserved.
//

import UIKit

class FAProgressHud: UIViewController
{
    @IBOutlet weak var firstProgressView : UIView!
    @IBOutlet weak var secondProgressView : UIView!
    @IBOutlet weak var thirdProgressView : UIView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.firstProgressView.layer.cornerRadius = 4.0
        self.secondProgressView.layer.cornerRadius = 4.0
        self.thirdProgressView.layer.cornerRadius = 4.0
        self.startAnimatingHud()
    }

    func startAnimatingHud()
    {

        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.firstProgressView.alpha = 1.0
            self.firstProgressView.transform = CGAffineTransform(scaleX: 1, y: 1.3)

        }) { (finished) in
           
            self.firstProgressView.alpha = 0.5
            self.firstProgressView.transform = CGAffineTransform(scaleX: 1, y: 1)

            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
                self.secondProgressView.alpha = 1.0
                self.secondProgressView.transform = CGAffineTransform(scaleX: 1, y: 1.3)

            }) { (finished) in
            
                self.secondProgressView.alpha = 0.5
                self.secondProgressView.transform = CGAffineTransform(scaleX: 1, y: 1)

                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    
                    self.thirdProgressView.alpha = 1.0
                    self.thirdProgressView.transform = CGAffineTransform(scaleX: 1, y: 1.3)


                }) { (finished) in

                    self.thirdProgressView.alpha = 0.5
                    self.thirdProgressView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.startAnimatingHud()

                }
            }
        }
    }
   
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    

}

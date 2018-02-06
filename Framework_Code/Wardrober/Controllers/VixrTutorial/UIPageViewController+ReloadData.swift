//
//  UIPageViewController+ReloadData.swift
//  Fashion180
//
//  Created by Srinivas Peddinti on 6/13/17.
//  Copyright © 2017 Mobiware. All rights reserved.
//

import Foundation

typealias FAPageLoadingCompletion = (Bool?) -> Swift.Void

extension UIPageViewController
{

    func xcd_setViewControllers(viewControllers : NSArray, direction:UIPageViewControllerNavigationDirection, animated: Bool, completion: @escaping FAPageLoadingCompletion)
    {
        
        DispatchQueue.main.async(execute: { () -> Void in

        self.setViewControllers(viewControllers as? [UIViewController], direction: direction, animated: false, completion: { (finished) in
                
            completion(true)
            
            })
        
        })

        self .setViewControllers(viewControllers as? [UIViewController], direction: direction, animated: animated) { (finished) in
            
            completion(animated)
        }
    }
}

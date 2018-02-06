//
//  VixrTutorialViewController.swift
//  Fashion180
//
//  Created by Yogi on 13/01/17.
//  Copyright © 2017 Mobiware. All rights reserved.
//

import UIKit

protocol FATutorialPageDelegate {
    
    func animationDidFinish(_ pageIndex : NSInteger)
    
    func startShoppingDidTap()

}

protocol FATutorialVCDelegate {
    
    func tutorialVCDidTapStartShopping(_ tutorialVC : FATutorialViewController)
}

class FATutorialViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, FATutorialPageDelegate {

    var _currentPageIndex : NSInteger!
    
    var delegate : FATutorialVCDelegate!
    
    @IBOutlet var tutorialContentView : UIView!
    @IBOutlet var skipButton : UIButton!
    @IBOutlet var skipView : UIView!

    var pageViewController : UIPageViewController!
    var tutorialPageClasses : NSArray!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tutorialPage1Class = "FATutorialPage1VC"
        let tutorialPage2Class = "FATutorialPage2VC"
        let tutorialPage3Class = "FATutorialPage3VC"
        let tutorialPage3bClass = "FATutorialPage3bVC"
        let tutorialPage4Class = "FATutorialPage4VC"
        
        
        self.tutorialPageClasses = NSArray(objects: tutorialPage1Class, tutorialPage2Class, tutorialPage3Class,tutorialPage3bClass, tutorialPage4Class)
        
        self.initializePageViewController()
        
    }


    
    func initializePageViewController()
    {
        self.pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: [:])
        
    
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
        
        
        _currentPageIndex = 0;
        
            let startingViewControllers = NSArray(object: self.itemControllerForIndex(_currentPageIndex)!)
            
        
        self.pageViewController.xcd_setViewControllers(viewControllers: startingViewControllers as! [FATutorialPageBase] as NSArray, direction: UIPageViewControllerNavigationDirection.forward, animated: false) { (finished) in
            
        }
        self.addChildViewController(self.pageViewController)
        self.tutorialContentView.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
        
        self.adjustConstraints()
        
        self.view.backgroundColor = UIColor.gray
        
        ///print("self vc frame \(self.view.frame)")
        
        
        ///print("page vc frame \(self.pageViewController.view.frame)")
        
        ///print("child vc frame \(self.pageViewController.viewControllers![0].view.frame)")

       
    }
    
    func adjustConstraints()
    {
        self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = NSLayoutConstraint(item: self.pageViewController.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.tutorialContentView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        
        let topContraint = NSLayoutConstraint(item: self.pageViewController.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.tutorialContentView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)

        let leadingContraint = NSLayoutConstraint(item: self.pageViewController.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.tutorialContentView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)

        let trailingContraint = NSLayoutConstraint(item: self.pageViewController.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.tutorialContentView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        
        
        self.tutorialContentView.addConstraints([topContraint,bottomConstraint, leadingContraint, trailingContraint])
        
        self.pageViewController.view.layoutIfNeeded()
        self.pageViewController.view.backgroundColor = UIColor.clear
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func itemControllerForIndex(_ itemIndex : Int) -> FATutorialPageBase?
    {
        if itemIndex < self.tutorialPageClasses.count
        {
            let classIdentifier = self.tutorialPageClasses[itemIndex] as! String
            
            let tutorialPageItemController = self.loadControllerWithIdentifier(classIdentifier)
            
            tutorialPageItemController.pageIndex = itemIndex
            tutorialPageItemController.tutDelegate = self
            
            return tutorialPageItemController
        }
        
        return nil
    }
    

    
    func loadControllerWithIdentifier(_ identifier : String) -> FATutorialPageBase
    {
        let storyboard = UIStoryboard(name: "Tutorial", bundle: Bundle(for: Wardrober.self))
        let controller = storyboard.instantiateViewController(withIdentifier: identifier) as! FATutorialPageBase
        
        return controller
    }
    
    
    //MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
        let vc = viewController as! FATutorialPageBase;
        if (vc.pageIndex > 0)
        {
            return self.itemControllerForIndex(vc.pageIndex - 1)

        }
        
        return nil;
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        let vc = viewController as! FATutorialPageBase
        
        
        ///print("viewControllerAfterViewController \(vc.pageIndex + 1)")

        
        if (vc.pageIndex + 1 < self.tutorialPageClasses.count)
        {
            return self.itemControllerForIndex(vc.pageIndex + 1)

        }
        
        return nil;
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return  self.tutorialPageClasses.count
    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        
        if pageViewController.viewControllers!.count > 0
        {
            
            return (pageViewController.viewControllers![0] as! FATutorialPageBase).pageIndex
            
        }
        else
        {
            return 0;
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        _currentPageIndex = (pageViewController.viewControllers![0] as! FATutorialPageBase).pageIndex
        
        if(_currentPageIndex == (self.tutorialPageClasses.count - 1))
        {
            self.skipButton.isHidden = true;
            self.skipView.isHidden = true;

        }
        else
        {
            self.skipButton.isHidden = false;
            self.skipView.isHidden = false;

        }
        
    }
    
    
    //MARK: - FATutorialPageDelegate
    func animationDidFinish(_ pageIndex: NSInteger) {
        
        _currentPageIndex = (pageViewController.viewControllers![0] as! FATutorialPageBase).pageIndex
        
        if(_currentPageIndex == 0 && pageIndex == 0)
        {

            let startingViewControllers  = [self.itemControllerForIndex(1)!] as [FATutorialPageBase]
            
            self.pageViewController.xcd_setViewControllers(viewControllers: startingViewControllers as NSArray, direction: UIPageViewControllerNavigationDirection.forward, animated: false) { (finished) in

            }
          
        }
        else if(_currentPageIndex == 1 && pageIndex == 1)
        {
            let startingViewControllers  = [self.itemControllerForIndex(2)!] as [FATutorialPageBase]
            
            self.pageViewController.xcd_setViewControllers(viewControllers: startingViewControllers as NSArray, direction: UIPageViewControllerNavigationDirection.forward, animated: false) { (finished) in
                
                }
           
        }
        else if(_currentPageIndex == 2 && pageIndex == 2)
        {
            
        }

    }
    
    func startShoppingDidTap() {
        
        self.delegate.tutorialVCDidTapStartShopping(self)
        
        UserDefaults.standard.set(false, forKey: Constants.kFirstLaunch)
        
    }
    
    
    @IBAction func BackButtonCLicked(_ sender : UIButton)
    {
        self.delegate.tutorialVCDidTapStartShopping(self)
    }

    @IBAction func DoneButtonCLicked(_ sender : UIButton)
    {
        self.delegate.tutorialVCDidTapStartShopping(self)
    }
    
    @IBAction func skipButtonTapped(_ sender : UIButton)
    {
        self.skipView.isHidden = true
        self.skipButton.isHidden = true
        
        let startingViewControllers  = [self.itemControllerForIndex((self.tutorialPageClasses.count - 1))!] as [FATutorialPageBase]
        
        self.pageViewController.xcd_setViewControllers(viewControllers: startingViewControllers as NSArray, direction: UIPageViewControllerNavigationDirection.forward, animated: false) { (finished) in
            
        }
    }

}

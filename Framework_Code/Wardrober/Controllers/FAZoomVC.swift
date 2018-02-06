//
//  FAZoomVC.swift
//  Fashion180
//
//  Created by Yogi on 27/12/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//

import UIKit

protocol FAZoomVCDelegate
{
    
    func faZoomVCDidTapClose(_ zoomVC : FAZoomVC)
    
}

class FAZoomVC: UIViewController, UIScrollViewDelegate
{

    @IBOutlet var scrollView : UIScrollView!

    @IBOutlet var closeButton : UIButton!

    
    // MARK: -  Model Container View
    @IBOutlet var modelImage : UIImageView!
    @IBOutlet var modelContainerView : UIView!
    @IBOutlet var modelItemImagesContainerView : UIView!
    @IBOutlet var modelImageAspectConstraint : NSLayoutConstraint!

    @IBOutlet var modelImageLessThanHeightConstraint : NSLayoutConstraint!

    
    @IBOutlet var topMainImageView : ClothingItemImageView!
    @IBOutlet var topSecondaryImageView : ClothingItemImageView!
    @IBOutlet var bottomImageView : ClothingItemImageView!
    @IBOutlet var shoeImageView : ClothingItemImageView!
    @IBOutlet var earringsImageView : ClothingItemImageView!
    
    @IBOutlet var hairRearImageView : ClothingItemImageView!

    
    @IBOutlet var modelContainerViewLeadingC : NSLayoutConstraint!
    @IBOutlet var modelContainerViewTopC : NSLayoutConstraint!
    @IBOutlet var modelContainerViewWidthC : NSLayoutConstraint!
    @IBOutlet var modelContainerViewHeightC : NSLayoutConstraint!
    
    var delegate : FAZoomVCDelegate!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.topMainImageView.clothingType = ClothingType.top_MAIN
        self.topSecondaryImageView.clothingType = ClothingType.top_SECONDARY
        self.bottomImageView.clothingType = ClothingType.bottom
        self.shoeImageView.clothingType = ClothingType.shoes
        self.earringsImageView.clothingType = ClothingType.earrings
        
        self.topMainImageView.isUserInteractionEnabled = false
        self.topSecondaryImageView.isUserInteractionEnabled = false
        self.bottomImageView.isUserInteractionEnabled = false
        self.shoeImageView.isUserInteractionEnabled = false
        self.earringsImageView.isUserInteractionEnabled = false
        self.hairRearImageView.isUserInteractionEnabled = false
        
        self.hairRearImageView.isHidden = true

        
        scrollView.maximumZoomScale = 3
        scrollView.minimumZoomScale = 0.5
        
        scrollView.delegate = self
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonTapped(_ sender : UIButton)
    {
        self.closeButton.isHidden = true

        UIView.animate(withDuration: 0.5, animations: {
            
            self.scrollView.zoomScale = 1
            self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) in
                self.delegate.faZoomVCDidTapClose(self)
        }) 
        
    }
    

    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        

        return self.modelContainerView
    }
    

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
    {
        ///print("scrollViewDidEndZooming")
        
        if scrollView.zoomScale <= 1
        {
            self.closeButtonTapped(self.closeButton)
            scrollView.delegate = nil
        }
    }
}

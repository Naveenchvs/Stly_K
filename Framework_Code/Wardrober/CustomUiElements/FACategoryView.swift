//
//  FACategoryView.swift
//  Wardrober
//
//  Created by Yogi on 07/06/17.
//  Copyright © 2017 Mobiware. All rights reserved.
//

import UIKit

protocol FACategoryViewDelegate
{
    func categoryViewDidDetectButtonTap(categoryView : FACategoryView)
}

class FACategoryView: UIView {

    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var underlineView : UIView!
    @IBOutlet var underlineViewWConstraint : NSLayoutConstraint!

    @IBOutlet var imageView : UIImageView!
    @IBOutlet var button : UIButton!

    var delegate : FACategoryViewDelegate? = nil
    
    @IBAction func buttonTapped()
    {
        if let d = delegate
        {
            d.categoryViewDidDetectButtonTap(categoryView: self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        ///print("awakeFromNib for FACategoryView called")

        let fontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 16
        let roundedfontSize = floor(fontSize)
        self.titleLabel.font = self.titleLabel.font.withSize(roundedfontSize)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        ///////print("layoutSubviews for FACategoryView called")
        
        ///self.adjustFrames()

    }
    
    func adjustFrames()
    {
        ///print("\(self.titleLabel.text ) - \(self.button.tag) intrinsic - \(self.titleLabel.intrinsicContentSize.width)")
        underlineView.frame = CGRect(origin: underlineView.frame.origin, size: CGSize(width: self.titleLabel.intrinsicContentSize.width + 6, height: underlineView.frame.size.height))
//        underlineView.center = CGPoint(x: self.titleLabel.center.x, y: underlineView.center.y)

    }
    
    func adjustConstraints()
    {
        self.underlineViewWConstraint.constant = self.titleLabel.intrinsicContentSize.width + 6
        self.layoutIfNeeded()
    }
    

    

}

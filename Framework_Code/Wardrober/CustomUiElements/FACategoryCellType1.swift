//
//  FACategoryCellType1.swift
//  Wardrober
//
//  Created by Yogi on 07/06/17.
//  Copyright © 2017 Mobiware. All rights reserved.
//

import UIKit
protocol FACategoryCellType1Delegate
{
    func categoryView(categoryView : FACategoryView, didDetectButtonTapInCategory1Cell cell : FACategoryCellType1)
}

class FACategoryCellType1: UITableViewCell {

    @IBOutlet var categoryView : FACategoryView!
    var delegate : FACategoryCellType1Delegate? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.categoryView.delegate = self
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

extension FACategoryCellType1 : FACategoryViewDelegate
{
    func categoryViewDidDetectButtonTap(categoryView: FACategoryView) {
        
        if let del = self.delegate
        {
            del.categoryView(categoryView: categoryView, didDetectButtonTapInCategory1Cell: self)
        }
        
    }
}


//
//  FACategoryCellType2.swift
//  Wardrober
//
//  Created by Yogi on 07/06/17.
//  Copyright © 2017 Mobiware. All rights reserved.
//

import UIKit
protocol FACategoryCellType2Delegate
{
    func categoryView(categoryView : FACategoryView, didDetectButtonTapInCategory2Cell cell : FACategoryCellType2)
}

class FACategoryCellType2: UITableViewCell {

    @IBOutlet var categoryView1 : FACategoryView!
    @IBOutlet var categoryView2 : FACategoryView!
   
    @IBOutlet var stackView : UIStackView!
    var delegate : FACategoryCellType2Delegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.categoryView1.delegate = self
        self.categoryView2.delegate = self
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

extension FACategoryCellType2 : FACategoryViewDelegate
{
    func categoryViewDidDetectButtonTap(categoryView: FACategoryView) {
        
        if let del = self.delegate
        {
            del.categoryView(categoryView: categoryView, didDetectButtonTapInCategory2Cell: self)
        }
    }
}

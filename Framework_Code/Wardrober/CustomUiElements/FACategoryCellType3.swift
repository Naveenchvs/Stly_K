//
//  FACategoryCellType3.swift
//  Wardrober
//
//  Created by Yogi on 07/06/17.
//  Copyright © 2017 Mobiware. All rights reserved.
//

import UIKit
protocol FACategoryCellType3Delegate
{
    func categoryView(categoryView : FACategoryView, didDetectButtonTapInCategory3Cell cell : FACategoryCellType3)
}

class FACategoryCellType3: UITableViewCell {

    @IBOutlet var categoryView1 : FACategoryView!
    @IBOutlet var categoryView2 : FACategoryView!
    @IBOutlet var categoryView3 : FACategoryView!
    
    @IBOutlet var stackView1 : UIStackView!
    @IBOutlet var stackView2 : UIStackView!

    var delegate : FACategoryCellType3Delegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.categoryView1.delegate = self
        self.categoryView2.delegate = self
        self.categoryView3.delegate = self

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension FACategoryCellType3 : FACategoryViewDelegate
{
    func categoryViewDidDetectButtonTap(categoryView: FACategoryView) {
        
        if let del = self.delegate
        {
            del.categoryView(categoryView: categoryView, didDetectButtonTapInCategory3Cell: self)
        }
    }
}

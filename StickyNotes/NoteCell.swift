//
//  NoteCell.swift
//  AdhesiveNote
//
//  Created by pingRuiLiao on 2016/3/31.
//  Copyright © 2016年 pingRuiLiao. All rights reserved.
//

import UIKit

class NoteCell: UICollectionViewCell {
    
    @IBOutlet weak var noteImage: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = true
        // self.button.setTitle("", forState: .Normal)
    }

    

}

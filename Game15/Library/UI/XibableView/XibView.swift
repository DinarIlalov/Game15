//
//  XibView.swift
//  course6
//
//  Created by Dinar Ilalov on 13/02/2019.
//  Copyright © 2019 Илалов Динар. All rights reserved.
//

import UIKit

class XibView: UIView, LoadXibableView {
    
    var xibView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
    }
    
}

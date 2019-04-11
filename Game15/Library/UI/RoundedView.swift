//
//  RoundedView.swift
//  Game15
//
//  Created by Dinar Ilalov on 11/04/2019.
//  Copyright © 2019 Dinar Ilalov. All rights reserved.
//

import UIKit

class RoundedView: UIView {
    
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.width/2
    }
    
}

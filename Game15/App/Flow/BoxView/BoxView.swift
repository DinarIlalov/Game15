//
//  BoxView.swift
//  Game15
//
//  Created by Dinar Ilalov on 10/04/2019.
//  Copyright © 2019 Dinar Ilalov. All rights reserved.
//

import UIKit

final class BoxView: XibView {
    
    @IBOutlet weak var mainView: UIView! {
        didSet {
            setupMainView()
        }
    }
    
    private func setupMainView() {
        
        mainView.backgroundColor = UIColor.rgba(220, 30, 70, 1)
        
        mainView.layer.borderColor = UIColor.rgba(180, 30, 70, 1).cgColor
        mainView.layer.borderWidth = 8
    }
}

//
//  ChipView.swift
//  Game15
//
//  Created by Dinar Ilalov on 10/04/2019.
//  Copyright © 2019 Dinar Ilalov. All rights reserved.
//

import UIKit

final class ChipView: XibView {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    
    var chipModel: ChipModel! {
        didSet {
            valueLabel.text = "\(chipModel.number)"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    private func setupView() {
        
        self.backgroundColor = .clear
        self.xibView.backgroundColor = .clear
        
        mainView.layer.cornerRadius = 10
        mainView.clipsToBounds = false
        mainView.layer.borderWidth = 6
        mainView.layer.borderColor = centerView.backgroundColor?.cgColor
        
    }
}

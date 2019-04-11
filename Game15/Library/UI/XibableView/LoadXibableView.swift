//
//  LoadXibableView.swift
//  course6
//
//  Created by Dinar Ilalov on 13/02/2019.
//  Copyright © 2019 Илалов Динар. All rights reserved.
//

import UIKit

protocol LoadXibableView: class {
    var xibView: UIView! { get set }
}

extension LoadXibableView {
    private func loadViewFromNib() -> UIView? {
        let metaData = type(of: self)
        let bundle = Bundle(for: metaData)
        let nib = UINib(nibName: String(describing: metaData), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        
        return view
    }
}
extension LoadXibableView where Self: UIView {
    func xibSetup() {
        xibView = loadViewFromNib()
        xibView.frame = bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(xibView)
    }
}

//
//  UIResponder+.swift
//  Tip_Calculator
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}

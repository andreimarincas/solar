//
//  UIView+Util.swift
//  Solar
//
//  Created by Andrei Marincas on 1/28/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

extension UIView {
    
    class func convert(_ point: CGPoint, from sourceView: UIView?, to destView: UIView?) -> CGPoint {
        guard let sourceView = sourceView, let destView = destView else { return point }
        guard let window = AppDelegate.shared.window else { return point }
        let p = window.convert(point, from: sourceView)
        let q = window.convert(p, to: destView)
        return q
    }
}

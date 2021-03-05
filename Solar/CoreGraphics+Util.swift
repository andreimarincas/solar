//
//  CoreGraphics+Util.swift
//  Solar
//
//  Created by Andrei Marincas on 1/27/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

extension CGRect {
    
    init(center: CGPoint, size: CGSize) {
        origin = CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
        self.size = size
    }
    
    var topLeft: CGPoint {
        return origin
    }
    
    var topRight: CGPoint {
        return CGPoint(x: origin.x + size.width, y: origin.y)
    }
    
    var bottomLeft: CGPoint {
        return CGPoint(x: origin.x, y: origin.y + size.height)
    }
    
    var bottomRight: CGPoint {
        return CGPoint(x: origin.x + size.width, y: origin.y + size.height)
    }
}

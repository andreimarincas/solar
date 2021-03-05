//
//  CubicBezier.swift
//  Solar
//
//  Created by Andrei Marincas on 1/27/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import Foundation
import CoreGraphics

struct CubicBezier {
    
    var p0: CGPoint
    var p1: CGPoint
    var p2: CGPoint
    var p3: CGPoint
    
    // t ∈ [0,1]
    func point(at t: CGFloat) -> CGPoint {
        let t2 = t * t
        let t3 = t2 * t
        return CGPoint(x: p0.x + 3 * t * (p1.x - p0.x) + 3 * t2 * (p0.x + p2.x - 2 * p1.x) + t3 * (p3.x - p0.x + 3 * p1.x - 3 * p2.x),
                       y: p0.y + 3 * t * (p1.y - p0.y) + 3 * t2 * (p0.y + p2.y - 2 * p1.y) + t3 * (p3.y - p0.y + 3 * p1.y - 3 * p2.y))
    }
    
    // t ∈ [0,1]
    subscript(t: CGFloat) -> CGPoint {
        return point(at: t)
    }
}

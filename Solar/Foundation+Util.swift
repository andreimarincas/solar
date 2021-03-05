//
//  Foundation+Util.swift
//  Solar
//
//  Created by Andrei Marincas on 1/28/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import Foundation

func  clamp<T: Comparable>(_ value: T, min: T, max: T) -> T {
    var ret = value
    if ret < min {
        ret = min
    }
    if ret > max {
        ret = max
    }
    return ret
}

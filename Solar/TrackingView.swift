//
//  TrackingView.swift
//  Solar
//
//  Created by Andrei Marincas on 1/28/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

enum TrackingPhase: Int {
    case began
    case moved
    case ended
    case cancelled
}

class TrackingView: UIView {
    
    var lastTouchLocation: CGPoint?
    var trackingHandler: ((UIView, TrackingPhase) -> Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        lastTouchLocation = touches.first?.location(in: self)
        trackingHandler?(self, .began)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        lastTouchLocation = touches.first?.location(in: self)
        trackingHandler?(self, .moved)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        lastTouchLocation = touches.first?.location(in: self)
        trackingHandler?(self, .ended)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        lastTouchLocation = touches.first?.location(in: self)
        trackingHandler?(self, .cancelled)
    }
}

extension UIView {
    
    func setTrackingTarget(_ target: Any?, action: Selector) {
        guard let view = self as? TrackingView else { return }
        view.trackingHandler = { [weak self] (_: UIView, _: TrackingPhase) in
            guard let weakSelf = self else { return }
            if let targetObj = target as? NSObjectProtocol, targetObj.responds(to: action) {
                _ = targetObj.perform(action, with: weakSelf as! TrackingView)
            }
        }
    }
}

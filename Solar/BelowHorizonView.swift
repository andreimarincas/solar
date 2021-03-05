//
//  BelowHorizonView.swift
//  Solar
//
//  Created by Andrei Marincas on 1/27/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

class BelowHorizonView: UIView {
    
    var horizonLineWidth: CGFloat = 0.5
    var horizonLineColor: UIColor = UIColor(white: 0.3, alpha: 1.0)
    var midnightHeight: CGFloat = 80.0
    var sunPathLineWidth: CGFloat = 2.0
    var sunPathLineColor: UIColor = UIColor(white: 0.3, alpha: 1.0)
    var bulletColor: UIColor = UIColor(white: 0.3, alpha: 1.0)
    var bulletRadius: CGFloat = 5.0
    var twilightHorizonDistance: CGFloat = 12.0
    
    var sunLocation: CGPoint? {
        didSet {
            setNeedsDisplay()
        }
    }
    var sunRadius: CGFloat = 8.0
    var sunRingThickness: CGFloat = 2.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.needsDisplayOnBoundsChange = true
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var sunrisePoint: CGPoint {
        return CGPoint(x: 0.2 * frame.size.width, y: 0.0)
    }
    
    var sunsetPoint: CGPoint {
        return CGPoint(x: 0.8 * frame.size.width, y: 0.0)
    }
    
    var yesterdaySunsetPoint: CGPoint {
        return CGPoint(x: -0.2 * frame.size.width, y: 0.0)
    }
    
    var tomorrowSunrisePoint: CGPoint {
        return CGPoint(x: 1.2 * frame.size.width, y: 0.0)
    }
    
    var leftMidnightPoint: CGPoint {
        return CGPoint(x: 0.0, y: midnightHeight)
    }
    
    var rightMidnightPoint: CGPoint {
        return CGPoint(x: frame.size.width, y: midnightHeight)
    }
    
    var leftSunPathBezier: CubicBezier {
        let leftMidnightPoint = self.leftMidnightPoint
        let cp1 = CGPoint(x: leftMidnightPoint.x - 5.0, y: (4.0 * leftMidnightPoint.y - sunrisePoint.y) / 3.0)
        let cp2 = CGPoint(x: leftMidnightPoint.x + 5.0, y: (4.0 * leftMidnightPoint.y - sunrisePoint.y) / 3.0)
        return CubicBezier(p0: yesterdaySunsetPoint, p1: cp1, p2: cp2, p3: sunrisePoint)
    }
    
    var rightSunPathBezier: CubicBezier {
        let rightMidnightPoint = self.rightMidnightPoint
        let cp1 = CGPoint(x: rightMidnightPoint.x - 5.0, y: (4.0 * rightMidnightPoint.y - sunsetPoint.y) / 3.0)
        let cp2 = CGPoint(x: rightMidnightPoint.x + 5.0, y: (4.0 * rightMidnightPoint.y - sunsetPoint.y) / 3.0)
        return CubicBezier(p0: sunsetPoint, p1: cp1, p2: cp2, p3: tomorrowSunrisePoint)
    }
    
    var dawnPoint: CGPoint {
        return leftSunPathBezier[1.0 - twilightHorizonDistance / (sunrisePoint.x - yesterdaySunsetPoint.x)]
    }
    
    var duskPoint: CGPoint {
        return rightSunPathBezier[twilightHorizonDistance / (tomorrowSunrisePoint.x - sunsetPoint.x)]
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        drawHorizonLine(context)
        drawSunPath(context, leftSunPathBezier)
        drawSunPath(context, rightSunPathBezier)
        drawBullets(context)
        drawSun(context)
        context.restoreGState()
    }
    
    func drawHorizonLine(_ context: CGContext) {
        context.setStrokeColor(horizonLineColor.cgColor)
        context.setLineWidth(horizonLineWidth)
        context.strokeLineSegments(between: [bounds.topLeft, bounds.topRight])
    }
    
    func drawSunPath(_ context: CGContext, _ bezier: CubicBezier) {
        let path = UIBezierPath()
        path.move(to: bezier.p0)
        path.addCurve(to: bezier.p3, controlPoint1: bezier.p1, controlPoint2: bezier.p2)
        context.addPath(path.cgPath)
        context.setStrokeColor(sunPathLineColor.cgColor)
        context.setLineWidth(sunPathLineWidth)
        context.strokePath()
    }
    
    func drawBullets(_ context: CGContext) {
        let bulletSize = CGSize(width: 2.0 * bulletRadius, height: 2.0 * bulletRadius)
        context.setFillColor(bulletColor.cgColor)
        context.fillEllipse(in: CGRect(center: sunrisePoint, size: bulletSize))
        context.fillEllipse(in: CGRect(center: sunsetPoint, size: bulletSize))
        context.fillEllipse(in: CGRect(center: dawnPoint, size: bulletSize))
        context.fillEllipse(in: CGRect(center: duskPoint, size: bulletSize))
    }
    
    func drawSun(_ context: CGContext) {
        guard let sunLocation = sunLocation else { return }
        let sunSize = CGSize(width: 2.0 * sunRadius, height: 2.0 * sunRadius)
        context.setLineWidth(sunRingThickness)
        context.setFillColor(UIColor.black.cgColor)
        context.setShadow(offset: .zero, blur: 10.0, color: UIColor.white.withAlphaComponent(0.5).cgColor)
        context.fillEllipse(in: CGRect(center: sunLocation, size: sunSize))
        context.setStrokeColor(UIColor.white.cgColor)
        context.setShadow(offset: .zero, blur: 3.0, color: UIColor.white.cgColor)
        context.strokeEllipse(in: CGRect(center: sunLocation, size: sunSize).insetBy(dx: sunRingThickness / 2.0, dy: sunRingThickness / 2.0))
        context.fillEllipse(in: CGRect(center: sunLocation, size: sunSize).insetBy(dx: sunRingThickness / 2.0, dy: sunRingThickness / 2.0))
        context.setShadow(offset: .zero, blur: 0.0, color: nil)
    }
}

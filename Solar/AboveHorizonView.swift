//
//  AboveHorizonView.swift
//  Solar
//
//  Created by Andrei Marincas on 1/27/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

class AboveHorizonView: UIView {
    
    var horizonLineWidth: CGFloat = 0.5
    var horizonLineColor: UIColor = UIColor(white: 0.3, alpha: 1.0)
    var noonHeight: CGFloat = 115.0
    var sunPathLineWidth: CGFloat = 2.0
    var sunPathLineColor: UIColor = UIColor(white: 0.3, alpha: 1.0)
    var bulletColor: UIColor = UIColor(white: 0.3, alpha: 1.0)
    var bulletRadius: CGFloat = 5.0
    
    var sunLocation: CGPoint? {
        didSet {
            setNeedsDisplay()
        }
    }
    var sunRadius: CGFloat = 8.0
    
    weak var belowHorizonView: BelowHorizonView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.needsDisplayOnBoundsChange = true
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var sunrisePoint: CGPoint {
        return CGPoint(x: 0.2 * frame.size.width, y: frame.size.height)
    }
    
    var sunsetPoint: CGPoint {
        return CGPoint(x: 0.8 * frame.size.width, y: frame.size.height)
    }
    
    var noonPoint: CGPoint {
        return CGPoint(x: frame.size.width / 2.0, y: frame.size.height - noonHeight)
    }
    
    var sunPathBezier: CubicBezier {
        let cp1 = CGPoint(x: noonPoint.x - 15.0, y: (4.0 * noonPoint.y - sunrisePoint.y) / 3.0)
        let cp2 = CGPoint(x: noonPoint.x + 15.0, y: (4.0 * noonPoint.y - sunrisePoint.y) / 3.0)
        return CubicBezier(p0: sunrisePoint, p1: cp1, p2: cp2, p3: sunsetPoint)
    }
    
    var leftMidnightPoint: CGPoint? {
        guard let belowHorizonView = belowHorizonView else { return nil }
        return UIView.convert(belowHorizonView.leftMidnightPoint, from: belowHorizonView, to: self)
    }
    
    var rightMidnightPoint: CGPoint? {
        guard let belowHorizonView = belowHorizonView else { return nil }
        return UIView.convert(belowHorizonView.rightMidnightPoint, from: belowHorizonView, to: self)
    }
    
    var dawnPoint: CGPoint? {
        guard let belowHorizonView = belowHorizonView else { return nil }
        return UIView.convert(belowHorizonView.dawnPoint, from: belowHorizonView, to: self)
    }
    
    var duskPoint: CGPoint? {
        guard let belowHorizonView = belowHorizonView else { return nil }
        return UIView.convert(belowHorizonView.duskPoint, from: belowHorizonView, to: self)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        drawEffects(context)
        drawHorizonLine(context)
        drawSunPath(context)
        drawBullets(context)
        drawSun(context)
        context.restoreGState()
    }
    
    func drawHorizonLine(_ context: CGContext) {
        context.setStrokeColor(horizonLineColor.cgColor)
        context.setLineWidth(horizonLineWidth)
        context.strokeLineSegments(between: [bounds.bottomLeft, bounds.bottomRight])
    }
    
    func drawSunPath(_ context: CGContext) {
        let bezier = self.sunPathBezier
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
        context.fillEllipse(in: CGRect(center: noonPoint, size: bulletSize))
        context.fillEllipse(in: CGRect(center: sunsetPoint, size: bulletSize))
    }
    
    func drawSun(_ context: CGContext) {
        guard let sunLocation = sunLocation else { return }
        let sunSize = CGSize(width: 2.0 * sunRadius, height: 2.0 * sunRadius)
        context.setLineWidth(1.0)
        context.setFillColor(UIColor.white.cgColor)
        context.setShadow(offset: .zero, blur: 10.0, color: UIColor.white.cgColor)
        context.fillEllipse(in: CGRect(center: sunLocation, size: sunSize))
        context.setStrokeColor(UIColor.white.cgColor)
        context.setShadow(offset: .zero, blur: 3.0, color: UIColor.white.cgColor)
        context.strokeEllipse(in: CGRect(center: sunLocation, size: sunSize).insetBy(dx: 1.0, dy: 1.0))
        context.fillEllipse(in: CGRect(center: sunLocation, size: sunSize).insetBy(dx: 1.0, dy: 1.0))
        context.setShadow(offset: .zero, blur: 0.0, color: nil)
    }
    
    func drawEffects(_ context: CGContext) {
        drawDaylightEffect(context)
        drawTwilightEffect(context)
    }
    
    func drawDaylightEffect(_ context: CGContext) {
        guard let sunLocation = sunLocation else { return }
//        let colors: [CGColor] = [UIColor(hex: 0x142230).cgColor, UIColor(hex: 0x142230).withAlphaComponent(0).cgColor]
////        let colors: [CGColor] = [UIColor(hex: 0x142230).cgColor, UIColor.black.cgColor]
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: nil)!
//        context.drawRadialGradient(gradient, startCenter: sunLocation, startRadius: 0.0, endCenter: sunLocation, endRadius: 300, options: .drawsAfterEndLocation)
        
////        let colors2: [CGColor] = [UIColor(hex: 0x1c3642).cgColor, UIColor(hex: 0x1c3642).withAlphaComponent(0).cgColor]
////        let colors2: [CGColor] = [UIColor(hex: 0x1c3642).cgColor, UIColor.clear.cgColor]
//        let colors2: [CGColor] = [UIColor(hex: 0x1c3642).cgColor, UIColor(hex: 0x142230).cgColor]
//        let colorSpace2 = CGColorSpaceCreateDeviceRGB()
//        let gradient2 = CGGradient(colorsSpace: colorSpace2, colors: colors2 as CFArray, locations: nil)!
//        context.drawRadialGradient(gradient2, startCenter: sunLocation, startRadius: 0.0, endCenter: sunLocation, endRadius: 200, options: [.drawsAfterEndLocation])
        
//        let colors: [CGColor] = [UIColor.blue.cgColor, UIColor(hex: 0x1c3642).cgColor, UIColor(hex: 0x142230).cgColor, UIColor.black.cgColor]
        
//        let colors: [CGColor] = [UIColor(hex: 0x142230).cgColor, UIColor.black.cgColor]
//        let colors: [CGColor] = [UIColor(hex: 0x54a6e0).cgColor, UIColor(hex: 0x142230).cgColor, UIColor.black.cgColor]
//        let colors: [CGColor] = [UIColor(hex: 0x54a6e0).cgColor, UIColor(hex: 0x142230).cgColor]
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: nil)!
//        context.drawRadialGradient(gradient, startCenter: sunLocation, startRadius: 0.0, endCenter: sunLocation, endRadius: 200, options: .drawsAfterEndLocation)
        
//        var alpha: CGFloat = (sunLocation.y - noonPoint.y) / (leftMidnightPoint!.y - noonPoint.y)
        
        // Draw daylight effect
        let darkPoint = dawnPoint!.offsetBy(dx: 0, dy: sunRadius)
//        let brightPoint = noonPoint.offsetBy(dx: 0, dy: dawnPoint!.y - sunrisePoint.y)
        let brightPoint = CGPoint(x: 0.0, y: noonPoint.y + (sunrisePoint.y - noonPoint.y) / 2.0)
//        let twilightInterval: CGFloat = dawnPoint!.y - sunrisePoint.y
//        let brightPoint = CGPoint(x: 0.0, y: sunrisePoint.y - twilightInterval)
        let sunY = clamp(sunLocation.y, min: brightPoint.y, max: darkPoint.y)
        var alpha = (sunY - brightPoint.y) / (darkPoint.y - brightPoint.y)
        alpha = 1.0 - alpha // TODO: apply cubic
        alpha = 1.0 - (1.0 - alpha) * (1.0 - alpha)
//        NSLog("alpha: \(alpha)")
//        alpha = 1
        
        let minRadius: CGFloat = 300
        let maxRadius: CGFloat = 1000
        let radius: CGFloat = minRadius + alpha * (maxRadius - minRadius)
        
//        let colors2: [CGColor] = [UIColor(hex: 0x142230).cgColor, UIColor.black.cgColor]
        let colors2: [CGColor] = [UIColor(hex: 0x54a6e0).withAlphaComponent(alpha).cgColor, UIColor.clear.cgColor]

//        let colors2: [CGColor] = [UIColor(hex: 0x54a6e0).cgColor, UIColor.black.cgColor]
//        let colors2: [CGColor] = [UIColor(hex: 0x54a6e0).cgColor, UIColor.black.cgColor]
//        let colors2: [CGColor] = [UIColor(hex: 0x54a6e0).cgColor, UIColor(hex: 0x142230).cgColor, UIColor.black.cgColor]
//        let colors2: [CGColor] = [UIColor(hex: 0x54a6e0).cgColor, UIColor(hex: 0x142230).cgColor]
        let colorSpace2 = CGColorSpaceCreateDeviceRGB()
        let gradient2 = CGGradient(colorsSpace: colorSpace2, colors: colors2 as CFArray, locations: nil)!
        context.drawRadialGradient(gradient2, startCenter: sunLocation, startRadius: 0.0, endCenter: sunLocation, endRadius: radius, options: .drawsAfterEndLocation)
    }
    
//    func drawTwilightEffect(_ context: CGContext) {
//        guard let sunLocation = sunLocation else { return }
//        let sunSize = CGSize(width: 2.0 * sunRadius, height: 2.0 * sunRadius)
//        context.setFillColor(UIColor.white.cgColor)
//        //context.setShadow(offset: .zero, blur: 30.0, color: UIColor.red.cgColor)
////        context.setShadow(offset: CGSize(width: 10, height: 10), blur: 30.0, color: UIColor.red.cgColor)
//        context.fillEllipse(in: CGRect(center: sunLocation, size: sunSize))
//        context.setShadow(offset: .zero, blur: 0.0, color: nil)
//    }
    
    func drawTwilightEffect(_ context: CGContext) {
        guard let sunLocation = sunLocation else { return }
        let darkPoint = dawnPoint!.offsetBy(dx: 0, dy: sunRadius)
        let twilightInterval: CGFloat = dawnPoint!.y - sunrisePoint.y
        let brightPoint = CGPoint(x: 0.0, y: sunrisePoint.y - twilightInterval).offsetBy(dx: 0, dy: -sunRadius)
        // Check if sun location is in twilight zone
        guard sunLocation.y >= brightPoint.y && sunLocation.y <= darkPoint.y else { return }
        let sunY = clamp(sunLocation.y, min: brightPoint.y, max: darkPoint.y)
        var progress: CGFloat = (sunY - brightPoint.y) / (darkPoint.y - brightPoint.y)
        progress = 1.0 - progress
        //NSLog("progress: \(progress)")
        
        if progress > 0.5 {
            progress = 1.0 - progress
        }
        progress *= 2.0
        NSLog("progress: \(progress)")
        
//        if sunY < sunrisePoint.y {
//            progress = 1.0 - (1.0 - progress) * (1.0 - progress) * (1.0 - progress)
//            NSLog("progress cubic: \(progress)")
//        }
        
        let alpha = progress
        
        let minRadius: CGFloat = 50
        let maxRadius: CGFloat = 150
        let radius: CGFloat = minRadius + progress * (maxRadius - minRadius)
        NSLog("radius: \(radius)")
        
        context.saveGState()
        
        func drawBlackGradient() {
            let colors: [CGColor] = [UIColor.black.withAlphaComponent(alpha / 2).cgColor, UIColor.clear.cgColor]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: nil)!
//            context.setBlendMode(.plusDarker)
            context.setBlendMode(.plusLighter)
            context.drawRadialGradient(gradient, startCenter: sunLocation, startRadius: 0.0, endCenter: sunLocation, endRadius: radius, options: .drawsAfterEndLocation)
        }
//        drawBlackGradient()
        
        let colors: [CGColor] = [UIColor.red.withAlphaComponent(alpha).cgColor, UIColor.clear.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: nil)!
        
//        context.setBlendMode(.destinationOver)
//        context.setBlendMode(.difference)
//        context.setBlendMode(.exclusion)
//        context.setBlendMode(.lighten)
//        context.setBlendMode(.plusDarker)
//        context.setBlendMode(.plusLighter)
//        context.setBlendMode(.screen)
        context.drawRadialGradient(gradient, startCenter: sunLocation, startRadius: 0.0, endCenter: sunLocation, endRadius: radius, options: .drawsAfterEndLocation)
//        context.setBlendMode(.plusLighter)
//        context.drawRadialGradient(gradient, startCenter: sunLocation, startRadius: 0.0, endCenter: sunLocation, endRadius: radius, options: .drawsAfterEndLocation)
//        context.drawRadialGradient(gradient, startCenter: sunLocation, startRadius: 0.0, endCenter: sunLocation, endRadius: radius, options: .drawsAfterEndLocation)
        context.restoreGState()
    }
}

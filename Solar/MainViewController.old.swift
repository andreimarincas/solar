////
////  MainViewController.swift
////  Solar
////
////  Created by Andrei Marincas on 1/27/18.
////  Copyright © 2018 Andrei Marincas. All rights reserved.
////
//
//import UIKit
//
//class MainViewController: UIViewController {
//    
//    var drawingView: DrawingView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .black
//        
//        drawingView = DrawingView(frame: view.frame)
//        drawingView.backgroundColor = .black
//        view.addSubview(drawingView)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        updateLayout()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        updateLayout()
//    }
//    
//    func updateLayout() {
//        drawingView.frame = view.bounds
//    }
//    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//}
//
//class DrawingView: UIView {
//    
//    struct CubicBezier {
//        var p0: CGPoint
//        var p1: CGPoint
//        var p2: CGPoint
//        var p3: CGPoint
//        
//        // t ∈ [0,1]
//        func point(at t: CGFloat) -> CGPoint {
//            let t2 = t * t
//            let t3 = t2 * t
//            return CGPoint(x: p0.x + 3 * t * (p1.x - p0.x) + 3 * t2 * (p0.x + p2.x - 2 * p1.x) + t3 * (p3.x - p0.x + 3 * p1.x - 3 * p2.x),
//                           y: p0.y + 3 * t * (p1.y - p0.y) + 3 * t2 * (p0.y + p2.y - 2 * p1.y) + t3 * (p3.y - p0.y + 3 * p1.y - 3 * p2.y))
//        }
//        
//        // t ∈ [0,1]
//        subscript(t: CGFloat) -> CGPoint {
//            return point(at: t)
//        }
//    }
//    
////    override func draw(_ rect: CGRect) {
////        super.draw(rect)
////        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return }
////        context.saveGState()
////        
////        // Draw horizon line
////        let middleLeft = CGPoint(x: 0, y: frame.size.height / 2)
////        let middleRight = CGPoint(x: frame.size.width, y: frame.size.height / 2)
////        //context.setStrokeColor(UIColor.white.withAlphaComponent(0.3).cgColor)
////        context.setStrokeColor(UIColor(white: 0.3, alpha: 1).cgColor)
////        context.setLineWidth(1)
////        context.strokeLineSegments(between: [middleLeft, middleRight])
////        
////        // Draw sun path
////        let sunrisePoint = CGPoint(x: 0.2 * frame.size.width, y: frame.size.height / 2)
////        let sunsetPoint = CGPoint(x: 0.8 * frame.size.width, y: frame.size.height / 2)
////        let noonHeight: CGFloat = 150
////        let noonPoint = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2 - noonHeight)
////        let sunPath = UIBezierPath()
////        sunPath.move(to: sunrisePoint)
////        let cp1 = CGPoint(x: noonPoint.x - 15, y: noonPoint.y)
////        let cp2 = CGPoint(x: noonPoint.x + 15, y: noonPoint.y)
////        sunPath.addCurve(to: sunsetPoint, controlPoint1: cp1, controlPoint2: cp2)
////        context.addPath(sunPath.cgPath)
////        context.setLineWidth(2)
////        context.strokePath()
////        
////        let yesterdaySunsetPoint = CGPoint(x: -0.2 * frame.size.width, y: frame.size.height / 2)
////        let midnightHeight: CGFloat = 100
////        let prevMidnightPoint = CGPoint(x: 0, y: frame.size.height / 2 + midnightHeight)
////        let cp3 = CGPoint(x: prevMidnightPoint.x - 5, y: prevMidnightPoint.y)
////        let cp4 = CGPoint(x: prevMidnightPoint.x + 5, y: prevMidnightPoint.y)
////        let yesterdayNightSunPath = UIBezierPath()
////        yesterdayNightSunPath.move(to: yesterdaySunsetPoint)
////        yesterdayNightSunPath.addCurve(to: sunrisePoint, controlPoint1: cp3, controlPoint2: cp4)
////        context.addPath(yesterdayNightSunPath.cgPath)
////        context.strokePath()
////        
////        let tomorrowSunrisePoint = CGPoint(x: frame.size.width + 0.2 * frame.size.width, y: frame.size.height / 2)
////        let nextMidnightPoint = CGPoint(x: frame.size.width, y: frame.size.height / 2 + midnightHeight)
////        let cp5 = CGPoint(x: nextMidnightPoint.x - 5, y: nextMidnightPoint.y)
////        let cp6 = CGPoint(x: nextMidnightPoint.x + 5, y: nextMidnightPoint.y)
////        let tonightSunPath = UIBezierPath()
////        tonightSunPath.move(to: sunsetPoint)
////        tonightSunPath.addCurve(to: tomorrowSunrisePoint, controlPoint1: cp5, controlPoint2: cp6)
////        context.addPath(tonightSunPath.cgPath)
////        context.strokePath()
////        
////        // Draw bullets on sunrise, noon and sunset points
////        context.setFillColor(UIColor(white: 0.3, alpha: 1).cgColor)
////        let r: CGFloat = 5
////        context.fillEllipse(in: CGRect(x: sunrisePoint.x - r, y: sunrisePoint.y - r, width: 2*r, height: 2*r))
//////        context.fillEllipse(in: CGRect(x: noonPoint.x - 1, y: noonPoint.y - 1, width: 2, height: 2))
////        context.fillEllipse(in: CGRect(x: sunsetPoint.x - r, y: sunsetPoint.y - r, width: 2*r, height: 2*r))
////        
//////        context.setStrokeColor(UIColor.red.withAlphaComponent(0.5).cgColor)
//////        context.setLineWidth(0.5)
//////        context.strokeLineSegments(between: [sunrisePoint, cp1])
//////        context.strokeLineSegments(between: [sunsetPoint, cp2])
//////        context.setFillColor(UIColor.red.cgColor)
//////        context.fillEllipse(in: CGRect(x: cp1.x - 1, y: cp1.y - 1, width: 2, height: 2))
//////        context.fillEllipse(in: CGRect(x: cp2.x - 1, y: cp2.y - 1, width: 2, height: 2))
//////        context.setFillColor(UIColor.green.cgColor)
//////        context.fillEllipse(in: CGRect(x: noonPoint.x - 1, y: noonPoint.y - 1, width: 2, height: 2))
////        
//////        let yesterdayMidnightPoint = CGPoint(x: 0, y: frame.size.height / 2 + noonHeight)
////        
////        
////        let sunPathBezier = CubicBezier(p0: sunrisePoint, p1: cp1, p2: cp2, p3: sunsetPoint)
////        context.setFillColor(UIColor.blue.withAlphaComponent(0.5).cgColor)
////        for t in stride(from: 0, through: 1, by: 0.02) {
////            let b = sunPathBezier[CGFloat(t)]
////            print("B(\(t)) = (\(b.x), \(b.y))")
////            context.fillEllipse(in: CGRect(x: b.x - r, y: b.y - r, width: 2 * r, height: 2 * r))
////        }
////        
////        context.restoreGState()
////    }
//    
////    override func draw(_ rect: CGRect) {
////        super.draw(rect)
////        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return }
////        context.saveGState()
////        
////        // Draw horizon line
////        let middleLeft = CGPoint(x: 0, y: frame.size.height / 2)
////        let middleRight = CGPoint(x: frame.size.width, y: frame.size.height / 2)
////        //context.setStrokeColor(UIColor.white.withAlphaComponent(0.3).cgColor)
////        context.setStrokeColor(UIColor(white: 0.3, alpha: 1).cgColor)
////        context.setLineWidth(1)
////        context.strokeLineSegments(between: [middleLeft, middleRight])
////        
////        // Draw sun path
////        let sunrisePoint = CGPoint(x: 0.2 * frame.size.width, y: frame.size.height / 2)
////        let sunsetPoint = CGPoint(x: 0.8 * frame.size.width, y: frame.size.height / 2)
//////        let noonHeight: CGFloat = 150
////        let noonHeight: CGFloat = 115
////        let noonPoint = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2 - noonHeight)
////        let sunPath = UIBezierPath()
////        sunPath.move(to: sunrisePoint)
//////        let cp1 = CGPoint(x: noonPoint.x - 15, y: noonPoint.y)
//////        let cp2 = CGPoint(x: noonPoint.x + 15, y: noonPoint.y)
////        let cp1 = CGPoint(x: noonPoint.x - 15, y: (4.0 * noonPoint.y - sunrisePoint.y) / 3.0)
////        let cp2 = CGPoint(x: noonPoint.x + 15, y: (4.0 * noonPoint.y - sunrisePoint.y) / 3.0)
////        sunPath.addCurve(to: sunsetPoint, controlPoint1: cp1, controlPoint2: cp2)
////        context.addPath(sunPath.cgPath)
////        context.setLineWidth(2)
////        context.strokePath()
////        
////        context.setFillColor(UIColor.blue.withAlphaComponent(0.5).cgColor)
////        let r: CGFloat = 5
////        context.fillEllipse(in: CGRect(x: noonPoint.x - r, y: noonPoint.y - r, width: 2 * r, height: 2 * r))
////        
////        context.restoreGState()
////    }
//    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return }
//        context.saveGState()
//        
//        // Draw horizon line
//        let middleLeft = CGPoint(x: 0, y: frame.size.height / 2)
//        let middleRight = CGPoint(x: frame.size.width, y: frame.size.height / 2)
//        //context.setStrokeColor(UIColor.white.withAlphaComponent(0.3).cgColor)
//        context.setStrokeColor(UIColor(white: 0.3, alpha: 1).cgColor)
//        context.setLineWidth(1)
//        context.strokeLineSegments(between: [middleLeft, middleRight])
//        
//        // Draw sun path
//        let sunrisePoint = CGPoint(x: 0.2 * frame.size.width, y: frame.size.height / 2)
//        let sunsetPoint = CGPoint(x: 0.8 * frame.size.width, y: frame.size.height / 2)
//        let noonHeight: CGFloat = 115
//        let noonPoint = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2 - noonHeight)
//        let sunPath = UIBezierPath()
//        sunPath.move(to: sunrisePoint)
//        let cp1 = CGPoint(x: noonPoint.x - 15, y: (4.0 * noonPoint.y - sunrisePoint.y) / 3.0)
//        let cp2 = CGPoint(x: noonPoint.x + 15, y: (4.0 * noonPoint.y - sunrisePoint.y) / 3.0)
//        sunPath.addCurve(to: sunsetPoint, controlPoint1: cp1, controlPoint2: cp2)
//        context.addPath(sunPath.cgPath)
//        context.setLineWidth(2)
//        context.strokePath()
//        
//        let yesterdaySunsetPoint = CGPoint(x: -0.2 * frame.size.width, y: frame.size.height / 2)
////        let midnightHeight: CGFloat = 100
//        let midnightHeight: CGFloat = 80
//        let prevMidnightPoint = CGPoint(x: 0, y: frame.size.height / 2 + midnightHeight)
////        let cp3 = CGPoint(x: prevMidnightPoint.x - 5, y: prevMidnightPoint.y)
////        let cp4 = CGPoint(x: prevMidnightPoint.x + 5, y: prevMidnightPoint.y)
//        let cp3 = CGPoint(x: prevMidnightPoint.x - 5, y: (4.0 * prevMidnightPoint.y - sunrisePoint.y) / 3.0)
//        let cp4 = CGPoint(x: prevMidnightPoint.x + 5, y: (4.0 * prevMidnightPoint.y - sunrisePoint.y) / 3.0)
//        let yesterdayNightSunPath = UIBezierPath()
//        yesterdayNightSunPath.move(to: yesterdaySunsetPoint)
//        yesterdayNightSunPath.addCurve(to: sunrisePoint, controlPoint1: cp3, controlPoint2: cp4)
//        context.addPath(yesterdayNightSunPath.cgPath)
//        context.strokePath()
//        
//        let tomorrowSunrisePoint = CGPoint(x: frame.size.width + 0.2 * frame.size.width, y: frame.size.height / 2)
//        let nextMidnightPoint = CGPoint(x: frame.size.width, y: frame.size.height / 2 + midnightHeight)
////        let cp5 = CGPoint(x: nextMidnightPoint.x - 5, y: nextMidnightPoint.y)
////        let cp6 = CGPoint(x: nextMidnightPoint.x + 5, y: nextMidnightPoint.y)
//        let cp5 = CGPoint(x: nextMidnightPoint.x - 5, y: (4.0 * nextMidnightPoint.y - sunrisePoint.y) / 3.0)
//        let cp6 = CGPoint(x: nextMidnightPoint.x + 5, y: (4.0 * nextMidnightPoint.y - sunrisePoint.y) / 3.0)
//        let tonightSunPath = UIBezierPath()
//        tonightSunPath.move(to: sunsetPoint)
//        tonightSunPath.addCurve(to: tomorrowSunrisePoint, controlPoint1: cp5, controlPoint2: cp6)
//        context.addPath(tonightSunPath.cgPath)
//        context.strokePath()
//        
//        //        context.setStrokeColor(UIColor.red.withAlphaComponent(0.5).cgColor)
//        //        context.setLineWidth(0.5)
//        //        context.strokeLineSegments(between: [sunrisePoint, cp1])
//        //        context.strokeLineSegments(between: [sunsetPoint, cp2])
//        //        context.setFillColor(UIColor.red.cgColor)
//        //        context.fillEllipse(in: CGRect(x: cp1.x - 1, y: cp1.y - 1, width: 2, height: 2))
//        //        context.fillEllipse(in: CGRect(x: cp2.x - 1, y: cp2.y - 1, width: 2, height: 2))
//        //        context.setFillColor(UIColor.green.cgColor)
//        //        context.fillEllipse(in: CGRect(x: noonPoint.x - 1, y: noonPoint.y - 1, width: 2, height: 2))
//        
//        //        let yesterdayMidnightPoint = CGPoint(x: 0, y: frame.size.height / 2 + noonHeight)
//        
//        // Draw bullets along the bezier curve
//        let sunPathBezier = CubicBezier(p0: sunrisePoint, p1: cp1, p2: cp2, p3: sunsetPoint)
//        context.setFillColor(UIColor.blue.cgColor)
//        for t in stride(from: 0, through: 1, by: 0.02) {
//            let b = sunPathBezier[CGFloat(t)]
//            print("B(\(t)) = (\(b.x), \(b.y))")
//            let r: CGFloat = 2
//            context.fillEllipse(in: CGRect(x: b.x - r, y: b.y - r, width: 2 * r, height: 2 * r))
//        }
//        
//        // Draw sunrise and sunset bullets
//        //        context.setFillColor(UIColor(white: 0.3, alpha: 1).cgColor)
//        context.setFillColor(UIColor.red.cgColor)
//        let r: CGFloat = 5
//        context.fillEllipse(in: CGRect(x: sunrisePoint.x - r, y: sunrisePoint.y - r, width: 2*r, height: 2*r))
//        //        context.fillEllipse(in: CGRect(x: noonPoint.x - 1, y: noonPoint.y - 1, width: 2, height: 2))
//        context.fillEllipse(in: CGRect(x: sunsetPoint.x - r, y: sunsetPoint.y - r, width: 2*r, height: 2*r))
//        
//        // Draw noon bullet
//        context.setFillColor(UIColor.yellow.cgColor)
//        context.fillEllipse(in: CGRect(x: noonPoint.x - r, y: noonPoint.y - r, width: 2 * r, height: 2 * r))
//        
//        // Draw midnight bullets
//        context.setFillColor(UIColor.purple.cgColor)
//        context.fillEllipse(in: CGRect(x: prevMidnightPoint.x - r, y: prevMidnightPoint.y - r, width: 2 * r, height: 2 * r))
//        context.fillEllipse(in: CGRect(x: nextMidnightPoint.x - r, y: nextMidnightPoint.y - r, width: 2 * r, height: 2 * r))
//        
//        context.restoreGState()
//    }
//}

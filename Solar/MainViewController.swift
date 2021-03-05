//
//  MainViewController.swift
//  Solar
//
//  Created by Andrei Marincas on 1/27/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var aboveHorizonView: AboveHorizonView!
    var belowHorizonView: BelowHorizonView!
    
    var progress: Float = 0.0 {
        didSet {
            updateSolar()
        }
    }
    
    override func loadView() {
        self.view = TrackingView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        aboveHorizonView = AboveHorizonView(frame: .zero)
        view.addSubview(aboveHorizonView)
        
        belowHorizonView = BelowHorizonView(frame: .zero)
        view.addSubview(belowHorizonView)
        aboveHorizonView.belowHorizonView = belowHorizonView
        
        progress = 0.5
        view.setTrackingTarget(self, action: #selector(handleTracking))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayout()
    }
    
    func updateLayout() {
        aboveHorizonView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height / 2)
        belowHorizonView.frame = CGRect(x: 0, y: view.frame.size.height / 2, width: view.frame.size.width, height: view.frame.size.height / 2)
        updateSolar()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc private func handleTracking(_ view: TrackingView) {
        if let location = view.lastTouchLocation {
            progress = Float(location.x) / Float(view.frame.size.width)
        }
    }
    
    func updateSolar() {
        // Update sun location based on the current progress.
        let progressLocation = CGPoint(x: CGFloat(progress) * view.frame.size.width, y: 0)
        let progressBelow = view.convert(progressLocation, to: belowHorizonView)
        if progressBelow.x < belowHorizonView.sunrisePoint.x {
            // Sun has not risen yet. Sun location is below horizon and to the left.
            let yesterdaySunset = belowHorizonView.yesterdaySunsetPoint
            let sunrise = belowHorizonView.sunrisePoint
            let t = (progressBelow.x - yesterdaySunset.x) / (sunrise.x - yesterdaySunset.x)
            belowHorizonView.sunLocation = belowHorizonView.leftSunPathBezier[t]
            aboveHorizonView.sunLocation = UIView.convert(belowHorizonView.sunLocation!, from: belowHorizonView, to: aboveHorizonView)
        }
        else if progressBelow.x > belowHorizonView.sunsetPoint.x {
            // Sun has set. Sun location is below horizon and to the right.
            let sunset = belowHorizonView.sunsetPoint
            let tomorrowSunrise = belowHorizonView.tomorrowSunrisePoint
            let t = (progressBelow.x - sunset.x) / (tomorrowSunrise.x - sunset.x)
            belowHorizonView.sunLocation = belowHorizonView.rightSunPathBezier[t]
            aboveHorizonView.sunLocation = UIView.convert(belowHorizonView.sunLocation!, from: belowHorizonView, to: aboveHorizonView)
        }
        else {
            // Sun is shining. Sun location is above horizon.
            let sunrise = aboveHorizonView.sunrisePoint
            let sunset = aboveHorizonView.sunsetPoint
            let progressAbove = view.convert(progressLocation, to: aboveHorizonView)
            let t = (progressAbove.x - sunrise.x) / (sunset.x - sunrise.x)
            aboveHorizonView.sunLocation = aboveHorizonView.sunPathBezier[t]
            belowHorizonView.sunLocation = UIView.convert(aboveHorizonView.sunLocation!, from: aboveHorizonView, to: belowHorizonView)
        }
    }
}

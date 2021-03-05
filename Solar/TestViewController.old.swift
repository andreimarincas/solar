////
////  TestViewController.swift
////  Solar
////
////  Created by Andrei Marincas on 1/30/18.
////  Copyright © 2018 Andrei Marincas. All rights reserved.
////
//
//import UIKit
//
//class TestViewController: UIViewController {
//    
//    var imageView: ImageView!
//    var images: [UIImage] = []
//    var displayLink: CADisplayLink?
//    var newTimeInfo: [CFTimeInterval] = []
//    let framesCount = 1800
//    let duration: CFTimeInterval = 30 // seconds
//    var framesPerSecond = 60.0
//    
//    var isPlaying = false {
//        didSet {
//            if isPlaying != oldValue {
//                NSLog("isPlaying: \(isPlaying)")
//            }
//        }
//    }
//    
//    var currentPlaybackTime: CFTimeInterval = 0 // 0..duration
//    var prevTimestamp: CFTimeInterval?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        imageView = ImageView()
//        view.addSubview(imageView)
//        
//        NSLog("start loading images")
//        for i in 0..<framesCount {
//            let name = String(format: "Comp 1_%05d", i)
////            let path = Bundle.main.path(forResource: name, ofType: "jpg", inDirectory: "frames")!
////            images.append(UIImage(contentsOfFile: path)!)
//            let url = Bundle.main.url(forResource: name, withExtension: "jpg", subdirectory: "frames")!
//            let data = try! Data(contentsOf: url)
//            let image = UIImage(data: data)!
//            images.append(image)
//        }
//        imageView.image = images.first
//        NSLog("finished loading images")
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        updateLayout()
//        displayLink = CADisplayLink(target: self, selector: #selector(updateDisplay))
//        displayLink?.add(to: .current, forMode: .defaultRunLoopMode)
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        play()
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        displayLink?.invalidate()
//        displayLink = nil
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        updateLayout()
//    }
//    
//    func updateLayout() {
//        imageView.sizeToFit()
//        let center = CGPoint(x: view.frame.size.width / 2.0, y: view.frame.size.height / 2.0)
//        imageView.frame = CGRect(center: center, size: imageView.frame.size)
//    }
//    
//    func updateDisplay(_ displayLink: CADisplayLink) {
//        if prevTimestamp == nil {
//            prevTimestamp = displayLink.timestamp
//        }
//        if isPlaying {
//            let delta = displayLink.timestamp - prevTimestamp!
//            let newTime = currentPlaybackTime + delta
//            if newTime <= duration {
//                var index = Int(round(newTime * framesPerSecond))
//                index = clamp(index, min: 0, max: framesCount - 1)
//                imageView.image = images[index]
//                currentPlaybackTime = newTime
//                newTimeInfo.append(newTime)
//            } else {
//                currentPlaybackTime = duration
//                imageView.image = images.last
//                isPlaying = false
//                for i in 0..<newTimeInfo.count {
//                    print("t[\(i)] = \(newTimeInfo[i])")
//                }
//            }
//        }
//        prevTimestamp = displayLink.timestamp
//    }
//    
//    func play() {
//        if !isPlaying {
//            newTimeInfo = []
//            isPlaying = true
//        } else {
//            isPlaying = false
//        }
//    }
//    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//}
//
//class ImageView: UIView {
//    
//    var image: UIImage? {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
//    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//        context.saveGState()
//        if let cgImage = image?.cgImage {
//            context.draw(cgImage, in: bounds)
//        }
//        context.restoreGState()
//    }
//    
//    override func sizeToFit() {
//        if let image = image {
//            let size = CGSize(width: image.size.width / 2.0, height: image.size.height / 2.0)
//            frame = CGRect(origin: frame.origin, size: size)
//        } else {
//            super.sizeToFit()
//        }
//    }
//}

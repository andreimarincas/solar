//
//  AnimationViewController.swift
//  Solar
//
//  Created by Andrei Marincas on 1/31/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit
import Compression

class AnimationViewController: UIViewController {
    
    var imageView: ImageView!
    var images: [UIImage] = []
    var displayLink: CADisplayLink?
    var newTimeInfo: [CFTimeInterval] = []
    let framesCount = 1800
    let duration: CFTimeInterval = 30 // seconds
    var framesPerSecond = 60.0
    
    var decompressedData: Data?
    
    var isPlaying = false {
        didSet {
            if isPlaying != oldValue {
                NSLog("isPlaying: \(isPlaying)")
            }
        }
    }
    
    var currentPlaybackTime: CFTimeInterval = 0 // 0..duration
    var prevTimestamp: CFTimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        imageView = ImageView()
        view.addSubview(imageView)
        
        loadImages()
        imageView.image = images.first
    }
    
//    private func loadImages() {
//        NSLog("start loading images")
//        for i in 0..<framesCount {
//            let name = String(format: "Comp2_%05d", i)
////            let path = Bundle.main.path(forResource: name, ofType: "jpg", inDirectory: "frames")!
////            images.append(UIImage(contentsOfFile: path)!)
//            let url = Bundle.main.url(forResource: name, withExtension: "jpg", subdirectory: "frames")!
//            let data = try! Data(contentsOf: url)
//            let image = UIImage(data: data)!
//            images.append(image)
//        }
//        NSLog("finished loading images")
//    }
    
    private func loadImages() {
        NSLog("start loading images")
        let compressor = Compressor()
        let compressedURL = Bundle.main.url(forResource: "Comp3Encode", withExtension: nil, subdirectory: "Comp")!
        guard let originalData = compressor.decode(dataAtURL: compressedURL, bytesCount: 49157718) else {
            NSLog("Error: Failed to decompress encoded data back to original data.")
            return
        }
        NSLog("original data size: \(originalData.count)")
        self.decompressedData = originalData
        let mapURL = Bundle.main.url(forResource: "Comp3One-map", withExtension: "data", subdirectory: "Comp")!
        guard let images = compressor.split(originalData, usingMapAtURL: mapURL) else {
            NSLog("Error: Failed to split decompressed data into images.")
            return
        }
        NSLog("frames count: \(images.count)")
        self.images = images
        NSLog("finished loading images")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLayout()
        displayLink = CADisplayLink(target: self, selector: #selector(updateDisplay))
        displayLink?.add(to: .current, forMode: .defaultRunLoopMode)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        displayLink?.invalidate()
        displayLink = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayout()
    }
    
    func updateLayout() {
        let imageSize = CGSize(width: 320.0, height: 320.0)
        let center = CGPoint(x: view.frame.size.width / 2.0, y: view.frame.size.height / 2.0)
//        imageView.frame = CGRect(center: center, size: imageSize)
//        imageView.frame = CGRect(x: center.x - imageSize.width / 2, y: center.y, width: imageSize.width, height: imageSize.height)
//        imageView.frame = CGRect(x: center.x - imageSize.width / 2, y: center.y - imageSize.height / 2, width: imageSize.width, height: imageSize.height)
//        imageView.frame = CGRect(x: 0, y: center.y - imageSize.height, width: view.frame.size.width, height: imageSize.height)
        imageView.frame = CGRect(x: center.x - imageSize.width / 2, y: 0, width: imageSize.width, height: imageSize.height)
    }
    
    @objc func updateDisplay(_ displayLink: CADisplayLink) {
        if prevTimestamp == nil {
            prevTimestamp = displayLink.timestamp
        }
        if isPlaying {
            let delta = displayLink.timestamp - prevTimestamp!
            let newTime = currentPlaybackTime + delta
            if newTime <= duration {
                var index = Int(round(newTime * framesPerSecond))
                index = clamp(index, min: 0, max: framesCount - 1)
                imageView.image = images[index]
                currentPlaybackTime = newTime
                newTimeInfo.append(newTime)
            } else {
                currentPlaybackTime = duration
                imageView.image = images.last
                isPlaying = false
                for i in 0..<newTimeInfo.count {
                    print("t[\(i)] = \(newTimeInfo[i])")
                }
                // replay
                currentPlaybackTime = 0
                play()
            }
        }
        prevTimestamp = displayLink.timestamp
    }
    
    func play() {
        if !isPlaying {
            newTimeInfo = []
            isPlaying = true
        } else {
            isPlaying = false
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

class ImageView: UIView {
    
    var image: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//        
//        context.saveGState()
//        if let cgImage = image?.cgImage {
//            context.draw(cgImage, in: bounds)
//        }
//        context.restoreGState()
//    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
//        context.saveGState()
        UIGraphicsPushContext(context)
//        if let cgImage = image?.cgImage {
//            context.translateBy(x: 0, y: image!.size.height)
//            context.scaleBy(x: 0, y: -1)
//            context.draw(cgImage, in: bounds)
            image?.draw(in: bounds)
//            context.scaleBy(x: 0, y: -1)
//            context.translateBy(x: 0, y: -image!.size.height)
//        }
//        context.restoreGState()
        UIGraphicsPopContext()
    }
    
    override func sizeToFit() {
        if let image = image {
            let size = CGSize(width: image.size.width / 2.0, height: image.size.height / 2.0)
            frame = CGRect(origin: frame.origin, size: size)
        } else {
            super.sizeToFit()
        }
    }
}

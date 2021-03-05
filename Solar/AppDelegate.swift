//
//  AppDelegate.swift
//  Solar
//
//  Created by Andrei Marincas on 1/27/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let bounds = UIScreen.main.bounds
        let window = UIWindow(frame: bounds)
        window.backgroundColor = .black
        
//        let mainVC = MainViewController()
//        mainVC.view.frame = bounds
//        window.rootViewController = mainVC
//        
//        let testVC = TestViewController()
//        testVC.view.frame = bounds
//        window.rootViewController = testVC
        
        let animVC = AnimationViewController()
        animVC.view.frame = bounds
        window.rootViewController = animVC
        
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}

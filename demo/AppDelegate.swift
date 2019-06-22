//
//  AppDelegate.swift
//  demo
//
//  Created by Chun yu Tung on 2019/4/22.
//  Copyright © 2019 Chun yu Tung. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //初始化 self.window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        //把window的背景改成白色
        self.window?.backgroundColor = UIColor.white
        
        //宣告一個view controller 指定背景為灰色
        let viewController = CocViewController()
        

        //指定root view controller
        self.window?.rootViewController = viewController
        
        
        //顯示window
        self.window?.makeKeyAndVisible()
        
        return true
    }

    


}


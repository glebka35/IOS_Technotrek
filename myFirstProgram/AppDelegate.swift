//
//  AppDelegate.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 29/09/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

import UIKit

class GUWindow:UIWindow{
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if(traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle){
            ThemeManager.sharedInstance().themeDidChange()
        }
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITableViewDelegate {

    var window: UIWindow?
    var Storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    var initialViewController : UIViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = GUWindow()
        initialViewController = Storyboard.instantiateInitialViewController()
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        return true
    }
}

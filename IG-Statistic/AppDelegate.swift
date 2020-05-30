//
//  AppDelegate.swift
//  IG-Statistic
//
//  Created by Бадый Шагаалан on 21.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            switch storedTheme {
            case 0:
                ThemeManager.applyTheme(theme: .light)
            default:
                ThemeManager.applyTheme(theme: .dark)
            }
        } else {
            ThemeManager.applyTheme(theme: .light)
        }
        ApplicationDelegate.shared.application (
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        return true
    }
          
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )

    }
}



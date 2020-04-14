//
//  SettingsViewController.swift
//  IG-Statistic
//
//  Created by и on 14.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit
import FacebookLogin

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func logOutTapped(_ sender: Any) {
        
        let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "AuthViewController")
        let cookies = HTTPCookieStorage.shared
        let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
        for cookie in facebookCookies! {
            cookies.deleteCookie(cookie)
        }
        let facebookCookies2 = cookies.cookies(for: URL(string: "https://facebook.net/")!)
        for cookie in facebookCookies2! {
            cookies.deleteCookie(cookie)
        }
        LoginManager().logOut()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginPage
    }

}

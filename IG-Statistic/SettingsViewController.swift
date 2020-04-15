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
    
    @IBAction func changePageTapped(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "userPageIsExisting")
        UserDefaults.standard.removeObject(forKey: "pageID")
        let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "AuthViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginPage
        
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        
        let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "AuthViewController")
        LoginManager().logOut()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginPage
    }

}

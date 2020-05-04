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

    @IBOutlet weak var changePageButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changePageButton.setTitleColor(ThemeManager.currentTheme().titleTextColor, for: .normal)
        logOutButton.setTitleColor(ThemeManager.currentTheme().titleTextColor, for: .normal)
        let titleColor = ThemeManager.currentTheme().titleTextColor
        let textAttributes = [NSAttributedString.Key.foregroundColor:titleColor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.tintColor = titleColor
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

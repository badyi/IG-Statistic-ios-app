//
//  ProfileNavigationController.swift
//  IG-Statistic
//
//  Created by Бадый Шагаалан on 27.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

class ProfileNavigationController: UINavigationController {
    
    var credentials: Credentials?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarVC = self.tabBarController as! BaseUITabBarViewController
        guard let credentials = tabBarVC.credentials else { return }
        self.credentials = credentials
    }
}

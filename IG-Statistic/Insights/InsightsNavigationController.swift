//
//  InsightsNavigationController.swift
//  IG-Statistic
//
//  Created by и on 26.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

class InsightsNavigationController: UINavigationController {
    
    var credentials: Credentials?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarVC = self.tabBarController as! BaseUITabBarViewController
        guard let credentials = tabBarVC.credentials else { return }
        self.credentials = credentials
    }
}

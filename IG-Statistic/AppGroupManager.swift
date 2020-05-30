//
//  AppGroupManager.swift
//  IG-Statistic
//
//  Created by и on 27.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation

class AppGroupManager {
    static func bundle() -> String {
        return "group." + Bundle.main.bundleIdentifier!
    }
}

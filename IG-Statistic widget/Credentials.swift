//
//  Credentials.swift
//  IG-Statistic widget
//
//  Created by и on 28.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation

final class Credentials {
    var instUserID: String
    var fbToken: String
    
    init(_ instID: String, _ token: String) {
        instUserID = instID
        fbToken = token
    }
}

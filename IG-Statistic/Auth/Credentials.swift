//
//  Credentials.swift
//  IG-Analyzer
//
//  Created by Бадый Шагаалан on 18.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation

class Credentials {
    var fbAccessToken: String
    var instUserID: String?
    var fbUserId: String?
    var token_type: String?
    var pageID: String?
    var category: String?
    var link: String?
    var website: String?
    var fbName: String?
    
    init(_ fbAccessToken: String) {
        self.fbAccessToken = fbAccessToken
    }
}


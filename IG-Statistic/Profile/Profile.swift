//
//  Profile.swift
//  IG-Analyzer
//
//  Created by Бадый Шагаалан on 18.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation

class Profile {
    var userID: String
    var username: String?
    var name: String?
    var postsCount: Int?
    var followersCount: Int?
    var followingsCount: Int?
    var profilePictureURLString: String?
    var bio: String?
    var accountType: String?
    
    init () {
        userID = ""
    }
    init(with id: String) {
        userID = id
    }
    
    func setInfo(_ info: MainInfoResponse) {
        bio = info.biography
        username = info.username
        name = info.name
        postsCount = info.media_count
        followersCount =  info.followers_count
        followingsCount = info.follows_count
        profilePictureURLString = info.profile_picture_url
    }
}

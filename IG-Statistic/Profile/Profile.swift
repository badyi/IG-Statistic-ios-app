//
//  Profile.swift
//  IG-Analyzer
//
//  Created by Бадый Шагаалан on 18.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

final class Profile {
    var userID: String?
    var username: String?
    var name: String?
    var postsCount: Int?
    var followersCount: Int?
    var followingsCount: Int?
    var profilePictureURLString: String?
    var bio: String?
    var website: String?
    var link: String?
    var category: String?
    var fbName: String?
    var credentials: Credentials
    var showInsightsOnPosts = false
    
    init(with credentials: Credentials, and id: String = "") {
        self.credentials = credentials
        category = credentials.category
    }
    
    func setInfo(_ info: MainInfoResponse) {
        bio = info.biography
        username = info.username
        name = info.name
        website = info.website
        postsCount = info.media_count
        followersCount =  info.followers_count
        followingsCount = info.follows_count
        profilePictureURLString = info.profile_picture_url
    }
}

final class ProfileView {
    let username: String
    let name: String?
    let postsCount: String
    let followersCount: String
    let followingsCount: String
    let bio: String?
    
    init(with profile: Profile) {
        username = profile.username!
        name = profile.name 
        postsCount = String(profile.postsCount!)
        followersCount = String(profile.followersCount!)
        followingsCount = String(profile.followingsCount!)
        bio = profile.bio
    }
}

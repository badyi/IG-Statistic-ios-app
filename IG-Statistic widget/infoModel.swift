//
//  infoModel.swift
//  IG-Statistic widget
//
//  Created by и on 28.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

protocol infoModelDelegate: AnyObject {
    func loadImage()
    func reloadAt(index: Int)
}

final class infoModel {
    var profile: Profile? {
        didSet {
            if profile?.profilePictureURLString != nil {
                delegate?.loadImage()
                delegate?.reloadAt(index: 1)
                delegate?.reloadAt(index: 2)
                delegate?.reloadAt(index: 3)
            }
        }
    }
    
    var image: UIImage? {
        didSet {
            delegate?.reloadAt(index: 0)
        }
    }
    
    weak var delegate: infoModelDelegate?
    
    init(_ delegate: infoModelDelegate) {
        self.delegate = delegate
    }
    
    func getImgURL() -> String? {
        profile?.profilePictureURLString
    }
}

final class Profile {
    var userID: String?
    var username: String?
    var name: String?
    var postsCount: Int?
    var followersCount: Int?
    var followingsCount: Int?
    var profilePictureURLString: String?
    var credentials: Credentials
    var showInsightsOnPosts = false
    
    init(with credentials: Credentials, and id: String = "") {
        self.credentials = credentials
    }
    
    func setInfo(_ info: MainInfoResponse) {
        username = info.username
        postsCount = info.media_count
        followersCount =  info.followers_count
        followingsCount = info.follows_count
        profilePictureURLString = info.profile_picture_url
    }
}

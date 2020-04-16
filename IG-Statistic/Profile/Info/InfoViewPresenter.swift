//
//  InfoViewPresenter.swift
//  IG-Statistic
//
//  Created by и on 16.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

protocol InfoViewProtocol: AnyObject {
    func setInfo(with profile: Profile, _ image: UIImage)
    func reloadData()
}

protocol InfoPresenterProtocol: AnyObject {
    func infoCount() -> Int
    func getInfo(at index: Int) -> String?
    func getInfoName(at index: Int) -> String
    func getProfileImage() -> UIImage
    func getNickname() -> String
}

final class InfoPresenter: InfoPresenterProtocol {
    weak var view: InfoViewController?
    var profile: Profile!
    var image: UIImage!
    private var info: [String] = ["name", "bio", "website","posts","followers","followings" ,"FB name", "FB Link", "Category"]
    
    init(profile: Profile, image: UIImage) {
        self.profile = profile
        self.image = image
    }
    
    func infoCount() -> Int {
        return info.count
    }
    
    func getInfoName(at index: Int) -> String {
        return info[index]
    }
    
    func getNickname() -> String {
        return profile.username!
    }
    
    func getProfileImage() -> UIImage {
        return image
    }
    
    func getInfo(at index: Int) -> String? {
        switch index {
        case 0:
            return profile.name
        case 1:
            return profile.bio
        case 2:
            return profile.website
        case 3:
            return String(profile.postsCount!)
        case 4:
            return String(profile.followersCount!)
        case 5:
            return String(profile.followingsCount!)
        case 6:
            return profile.fbName
        case 7:
            return profile.link
        case 8:
            return profile.category
        default:
            return nil
        }
    }
}

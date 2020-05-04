//
//  InfoViewPresenter.swift
//  IG-Statistic
//
//  Created by и on 16.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

protocol InfoViewProtocol: AnyObject {
    func setInfo(with _: Credentials)
    func reloadData()
    func reloadItem(at index: Int)
    func imageDidLoaded(_ image: UIImage)
}

protocol InfoPresenterProtocol: AnyObject {
    func infoCount() -> Int
    func getInfo(at index: Int) -> String?
    func getInfoName(at index: Int) -> String
    func getImage() -> UIImage?
    func getNickname() -> String?
    func getProfileImage()
}

final class InfoPresenter: InfoPresenterProtocol {
    weak var view: InfoViewProtocol?
    var infoService: InfoService!

    var profile: Profile {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadData()
            }
            getProfileImage()
            getFBname()
            getLink()
        }
    }
    
    var image: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.view?.imageDidLoaded(self.image!)
                self.view?.reloadData()
            }
        }
    }
    
    private var info: [String] = ["name", "bio", "website","posts","followers","followings" ,"Page name", "FB Link", "Category"]
    
    init(credentials: Credentials, view: InfoViewProtocol) {
        profile = Profile(with: credentials)
        self.infoService = InfoService()
        self.view = view
    }
    
    func infoCount() -> Int {
        return info.count
    }

    func getInfoName(at index: Int) -> String {
        return info[index]
    }
    
    func getNickname() -> String? {
        return profile.username
    }
    
    func getImage() -> UIImage? {
        return image
    }
    
    func getFBname(){
        infoService.getFBname(profile.credentials) { [weak self] result in
            switch result {
            case let .success(name):
                self?.profile.fbName = name
                DispatchQueue.main.async {
                    self?.view?.reloadData()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    #warning("here")//self.view?.smtWrongAlert(reason: "cant get a FB name")
                }
            }
        }
    }
    
    func getLink() {
        infoService.getFBLink(profile.credentials) { [weak self] result in
            switch result {
            case let .success(link):
                self?.profile.link = link
                DispatchQueue.main.async {
                    self?.view?.reloadItem(at: 7)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    #warning("here")//self.view?.smtWrongAlert(reason: "cant get a FB name")
                }
            }
        }
    }
    
    func getMainProfileInfo() {
        infoService.getMainProfileInfo(profile.credentials) { [weak self] result in
            switch result {
            case let .success(profile):
                let profile: Profile = profile
                profile.category = self?.profile.category
                self?.profile = profile
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getProfileImage() {
        guard let imageUrl = profile.profilePictureURLString else {
            image = UIImage(named: "defaultAvatar")
            return
        }
        infoService.getImage(imageUrl) { result in
            switch result {
            case let .success(image):
                self.image = image
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getInfo(at index: Int) -> String? {
        switch index {
        case 0:
            return self.profile.name
        case 1:
            return self.profile.bio
        case 2:
            return self.profile.website
        case 3:
            guard let count = self.profile.postsCount else { return nil }
            return String(count)
        case 4:
            guard let count = self.profile.followersCount else { return nil }
            return String(count)
        case 5:
            guard let count = self.profile.followingsCount else { return nil }
            return String(count)
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

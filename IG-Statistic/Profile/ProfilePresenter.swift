//
//  ProfilePresenter.swift
//  
//
//  Created by Бадый Шагаалан on 23.03.2020.
//

import Foundation
import UIKit

protocol ProfileViewProtocol: AnyObject {
    func setUpView()
    func setManiInfo(_ profileView: ProfileView)
    func imageDidLoaded(_ image: UIImage)
}

protocol ProfilePresenterProtocol: AnyObject {
    func getMainProfileInfo()
    func getProfileImage()
    func getCredentials() -> Credentials
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?
    private let profileService: ProfileService!

    var image: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.view?.imageDidLoaded(self.image!)
            }
        }
    }
    
    var profile: Profile {
        didSet {
            let profileView = ProfileView(with: profile)
            DispatchQueue.main.async {
                self.view?.setManiInfo(profileView)
            }
            getProfileImage()
        }
    }

    init(with credentials: Credentials, view: ProfileViewProtocol) {
        profileService = ProfileService()
        profile = Profile(with: credentials)
        self.view = view
    }
    
    func getMainProfileInfo() {
        profileService.getMainProfileInfo(profile.credentials) { [weak self] result in
            switch result {
            case let .success(profile):
                let profile: Profile = profile
                self?.profile = profile
            case let .failure(error):
                print(error)
            }
        }
     }
    
    func getProfileImage() {
        guard let imageUrl = profile.profilePictureURLString else {
            return
        }
        profileService.getImage(imageUrl) { [weak self] result in
            switch result {
            case let .success(image):
                self?.image = image
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getCredentials() -> Credentials {
        return profile.credentials
    }
    
    func reverseShowInsightsState() {
        profile.showInsightsOnPosts = !profile.showInsightsOnPosts
    }
    
    func changeShowInsightsState(with flag: Bool) {
        profile.showInsightsOnPosts = flag
    }
    
    func getShowInsightsState() -> Bool {
        profile.showInsightsOnPosts
    }
}

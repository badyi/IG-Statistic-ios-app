//
//  ProfilePresenter.swift
//  
//
//  Created by Бадый Шагаалан on 23.03.2020.
//

import Foundation
import UIKit

protocol ProfilePresenterViewDelegate: NSObjectProtocol {
    func setupProfileView()
}

class ProfilePresenter {
    private let profileService: ProfileService
    weak var profilePresenterViewDelegate: ProfilePresenterViewDelegate?
    var profile: Profile
    var credentials: Credentials
    
    init(_ credentials: Credentials) {
        profileService = ProfileService()
        profile = Profile()
        self.credentials = credentials
    }
    
    func getMainProfileInfo(completionBlock: @escaping() -> ()) {
        profileService.getMainProfileInfo(credentials) { (profile) in
            guard let prof = profile else { return }
            self.profile = prof
            completionBlock()
        }
     }
    
    func getUsername() -> String? {
        guard let username = profile.username else {
            return nil
        }
        return username
    }
    
    func getName() -> String? {
        guard let name = profile.name else {
            return nil
        }
        return name
    }
    
    func getBio() -> String? {
        guard let bio = profile.bio else {
            return nil
        }
        return bio
    }
    
    func getPostsCount() -> Int? {
        guard let count = profile.postsCount else {
            return nil
        }
        return count
    }
    
    func getFollowersCount() -> Int? {
        guard let count = profile.followersCount else {
            return nil
        }
        return count
    }
    
    func getFollowingsCount() -> Int? {
        guard let count = profile.followingsCount else {
            return nil
        }
        return count
    }
    
    func getProfilePicture(completionBlock: @escaping(_ image: UIImage) -> ()) {
        guard let imageUrl = profile.profilePictureURLString else {
            return
        }
        profileService.getImage(imageUrl) { (image) in
            completionBlock(image)
        }
    }
}

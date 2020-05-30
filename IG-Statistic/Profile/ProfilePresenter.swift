//
//  ProfilePresenter.swift
//  
//
//  Created by Бадый Шагаалан on 23.03.2020.
//

import Foundation
import UIKit

protocol ProfileViewProtocol: AnyObject {
    func setupView()
    func setManiInfo(_ profileView: ProfileView)
    func imageDidLoaded(_ image: UIImage)
    func showAlert(_ alert: UIAlertController)
    func sortPosts(by criterion: sortCriterion, direction: sortDirection)
}

protocol ProfilePresenterProtocol: AnyObject {
    func getMainProfileInfo()
    func getProfileImage()
    func getCredentials() -> Credentials
    func reverseShowInsightsState()
    func changeShowInsightsState(with flag: Bool)
    func getShowInsightsState() -> Bool
    func chooseSort()
    func sortPostsAction(alertAction: UIAlertAction)
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
    
    func chooseSort() {
        let alert = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Date (newest)", style: .default, handler: sortPostsAction))
        alert.addAction(UIAlertAction(title: "Date (oldest)", style: .default, handler: sortPostsAction))
        alert.addAction(UIAlertAction(title: "Likes (descending)", style: .default, handler: sortPostsAction))
        alert.addAction(UIAlertAction(title: "Likes (ascending)", style: .default, handler: sortPostsAction))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: sortPostsAction))
        self.view?.showAlert(alert)
    }
    
    func sortPostsAction(alertAction: UIAlertAction) {
        switch alertAction.title {
        case "Date (newest)":
            self.view?.sortPosts(by: .date, direction: .descending)
        case "Date (oldest)":
            self.view?.sortPosts(by: .date, direction: .ascending)
        case "Likes (descending)":
            self.view?.sortPosts(by: .likes, direction: .descending)
        case "Likes (ascending)":
            self.view?.sortPosts(by: .likes, direction: .ascending)
        default:
            print("no action")
        }
    }
}

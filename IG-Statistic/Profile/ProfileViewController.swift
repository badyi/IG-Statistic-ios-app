//
//  ProfileViewController.swift
//  IG-Statistic
//
//  Created by Бадый Шагаалан on 26.03.2020.
//  Copyright © 2020 Бадый ШагааProfileViewControllerлан. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {

    var pageVC: ProfilePageViewController!
    var profilePresenter: ProfilePresenter!
    
    @IBOutlet weak var profileBackView: UIView!
    @IBOutlet weak var shInsights: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postsCount: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingsCount: UILabel!
    @IBOutlet weak var followingsLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var sortsPostsButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationVC = self.navigationController as! ProfileNavigationController
        guard let credentials = navigationVC.credentials else { return }
        profilePresenter = ProfilePresenter(with: credentials,view: self)
        profilePresenter?.getMainProfileInfo()
        setUpView()
    }
    
    @IBAction func sortPosts(_ sender: Any) {
        profilePresenter.chooseSort()
    }
    
    @IBAction func showInsights(_ sender: UIButton) {
        profilePresenter.reverseShowInsightsState()
        let state = profilePresenter.getShowInsightsState()
        pageVC.insightsTapped(with: state)
        if state == true {
            shInsights.setTitleColor(ThemeManager.currentTheme().buttonSelectedColor, for: .normal)
            shInsights.layer.borderWidth = 0.8
            shInsights.layer.borderColor = ThemeManager.currentTheme().buttonSelectedColor.cgColor
        } else {
            shInsights.setTitleColor(ThemeManager.currentTheme().titleTextColor, for: .normal)
            self.shInsights.layer.borderWidth = 0.5
            self.shInsights.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        print(234)
    }
}

extension ProfileViewController: ProfileViewProtocol {
    func sortPosts(by criterion: sortCriterion, direction: sortDirection) {
        pageVC.sortBy(criterion, direction)
    }
    func showAlert(_ alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    func setUpView() {
        let titleColor = ThemeManager.currentTheme().titleTextColor
        let borderColor = ThemeManager.currentTheme().borderColor
        let backgroundColor = ThemeManager.currentTheme().backgroundColor
        
        self.navigationController?.navigationBar.barTintColor = backgroundColor
        self.navigationController?.navigationBar.tintColor = backgroundColor
        self.navigationController?.navigationBar.backgroundColor = backgroundColor
        let textAttributes = [NSAttributedString.Key.foregroundColor:titleColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.tabBarController?.tabBar.barTintColor = backgroundColor
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.tintColor = titleColor
        
        self.name.textColor = titleColor
        self.postsCount.textColor = titleColor
        self.postsLabel.textColor = titleColor
        self.followersCount.textColor = titleColor
        self.followersLabel.textColor = titleColor
        self.followingsCount.textColor = titleColor
        self.followingsLabel.textColor = titleColor
        
        self.profileBackView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.pageControl.backgroundColor = backgroundColor
        
        self.shInsights.layer.cornerRadius = 3
        self.shInsights.layer.borderWidth = 0.5
        self.shInsights.setTitleColor(titleColor, for: .normal)
        self.shInsights.layer.borderColor = borderColor.cgColor
        
        self.sortsPostsButton.layer.cornerRadius = 3
        self.sortsPostsButton.layer.borderWidth = 0.5
        self.sortsPostsButton.layer.borderColor = borderColor.cgColor
        self.sortsPostsButton.setTitleColor(titleColor, for: .normal)
        
        self.infoButton.layer.cornerRadius = 3
        self.infoButton.layer.borderWidth = 0.5
        self.infoButton.layer.borderColor = borderColor.cgColor
        self.infoButton.setTitleColor(titleColor, for: .normal)
    }
    
    func setManiInfo(_ profile: ProfileView) {
        postsCount.text = profile.postsCount
        followersCount.text = profile.followersCount
        followingsCount.text = profile.followingsCount
        name.text = profile.name
        self.title = profile.username
        
        self.pageVC?.transferData(self.profilePresenter!.profile)
    }
    
    func imageDidLoaded(_ image: UIImage) {
        self.profileImage.image = image;
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        self.profileImage.clipsToBounds = true
    }
}

extension ProfileViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PVCSegue" {
            guard let PVC = segue.destination as? ProfilePageViewController else { return }
            pageVC = PVC
            pageVC.PPVCdelegate = self
        } else if segue.identifier == "infoSegue" {
            guard let infoVC = segue.destination as? InfoViewController else {
                return }
            infoVC.cred = profilePresenter.getCredentials()
        }
    }
}

extension ProfileViewController: ProfilePageViewControllerDelegate {
    func profilePageViewController(ProfilePageViewController: ProfilePageViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func profilePageViewController(ProfilePageViewController: ProfilePageViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
}

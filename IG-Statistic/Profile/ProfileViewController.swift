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
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postsCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingsCount: UILabel!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationVC = self.navigationController as! ProfileNavigationController
        guard let credentials = navigationVC.credentials else { return }
        profilePresenter = ProfilePresenter(with: credentials,view: self)
        profilePresenter?.getMainProfileInfo()
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        print(1)
    }
}

extension ProfileViewController: ProfileViewProtocol {
    func setUpView() {

    }
    
    func setManiInfo(_ profile: ProfileView) {
        postsCount.text = profile.postsCount
        followersCount.text = profile.followersCount
        followingsCount.text = profile.followingsCount
        name.text = profile.name
        self.title = profile.username
        
        self.pageVC?.transferData(self.profilePresenter!.profile, self.profilePresenter!.credentials)
    }
    
    func imageDidLoaded(_ image: UIImage) {
        self.profileImage.image = image;
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        self.profileImage.clipsToBounds = true    }
}

extension ProfileViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "PVCSegue" else { return }
        guard let PVC = segue.destination as? ProfilePageViewController else { return }
        pageVC = PVC
        pageVC.PPVCdelegate = self
    }
}

extension ProfileViewController: ProfilePageViewControllerDelegate {
    func ProfilePageViewController(ProfilePageViewController: ProfilePageViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func ProfilePageViewController(ProfilePageViewController: ProfilePageViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
}
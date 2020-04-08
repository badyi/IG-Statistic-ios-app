//
//  ProfileViewController.swift
//  IG-Statistic
//
//  Created by Бадый Шагаалан on 26.03.2020.
//  Copyright © 2020 Бадый ШагааProfileViewControllerлан. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {

    var pageVC: ProfilePageViewController?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postsCount: UILabel!
    @IBOutlet weak var followersCont: UILabel!
    @IBOutlet weak var followingsCount: UILabel!
    @IBOutlet weak var name: UILabel!
    
    var posts: [Post]?
    var imageURLexists: Bool = false {
        didSet {
            if imageURLexists == true {
                profilePresenter?.getProfilePicture() { (image) in
                   // guard let data = data else { return }//
                    //let image = UIImage(data: data)
                    DispatchQueue.main.sync {
                        self.profileImage.image = image
                    }
                }
            }
        }
    }
    
    var profilePresenter: ProfilePresenter?
    @IBOutlet weak var pageControl: UIPageControl!
    
    var upadateCounter: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upadateCounter = 0
        
        let navigationVC = self.navigationController as! ProfileNavigationController
        guard let credentials = navigationVC.credentials else { return }
        profilePresenter = ProfilePresenter(credentials)
        
        profilePresenter?.getMainProfileInfo() {
            guard let postsCount = self.profilePresenter?.getPostsCount() else { return }
            guard let followersCount = self.profilePresenter?.getFollowersCount() else { return }
            guard let followingsCount = self.profilePresenter?.getFollowingsCount() else { return }
            DispatchQueue.main.sync {
                self.postsCount.text = "\(postsCount)"
                self.followersCont.text = "\(followersCount)"
                self.followingsCount.text = "\(followingsCount)"
                self.name.text = self.profilePresenter?.getName()
                self.imageURLexists = true
                self.title = self.profilePresenter?.getUsername()

                self.pageVC?.transferData(self.profilePresenter!.profile, self.profilePresenter!.credentials)
            }
        }
        
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        print(1)
    }
}

extension ProfileViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PVCSegue" {
            if segue.destination.isKind(of: ProfilePageViewController.self) {
                pageVC = (segue.destination as! ProfilePageViewController)
            }
        }
    }
}



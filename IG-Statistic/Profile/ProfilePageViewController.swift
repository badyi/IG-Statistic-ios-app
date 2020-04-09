//
//  ProfilePageViewController.swift
//  IG-Statistic
//
//  Created by Бадый Шагаалан on 27.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

final class ProfilePageViewController: UIPageViewController {
    let postsCVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostsVC") as! PostsCollectionViewController
    let CVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TagedVC") as! CollectionViewController
    
    lazy var subViewControllers: [UIViewController] = { return [ postsCVC, CVC ] }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setViewControllerFromIndex(index: 0)
    }
}

extension ProfilePageViewController {
    func transferData(_ profile: Profile, _ credentials: Credentials) {
        postsCVC.transferData(profile, credentials)
    }
    
    func setViewControllerFromIndex(index: Int) {
        self.setViewControllers([subViewControllers[index]], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
    }
}

extension ProfilePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if currentIndex <= 0 {
            return nil
        }
        return subViewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if currentIndex >= subViewControllers.count - 1 {
            return nil
        }
        return subViewControllers[currentIndex + 1]
    }
}

extension ProfilePageViewController: UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
}

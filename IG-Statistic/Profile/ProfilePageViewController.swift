//
//  ProfilePageViewController.swift
//  IG-Statistic
//
//  Created by Бадый Шагаалан on 27.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit


protocol ProfilePageViewControllerDelegate: class {
    func profilePageViewController(ProfilePageViewController: ProfilePageViewController,
        didUpdatePageCount count: Int)
    
    func profilePageViewController(ProfilePageViewController: ProfilePageViewController,
        didUpdatePageIndex index: Int)
}

final class ProfilePageViewController: UIPageViewController {
    let postsCVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostsVC") as! PostsCollectionViewController
    let CVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TagedVC") as! CollectionViewController
    
    lazy var subViewControllers: [UIViewController] = { return [ postsCVC, CVC ] }()
    
    weak var PPVCdelegate: ProfilePageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        for view in self.view.subviews {
          if let scrollView = view as? UIScrollView {
            scrollView.delegate = self
          }
        }
        setViewControllerFromIndex(index: 0)
        PPVCdelegate?.profilePageViewController(ProfilePageViewController: self, didUpdatePageCount: subViewControllers.count)
    }
    
}

extension ProfilePageViewController {
    func insightsTapped(with flag: Bool) {
        postsCVC.insightsTapped(with: flag)
    }
    
    func sortBy(_ creiterion: sortCriterion, _ direction: sortDirection) {
        postsCVC.sortBy(creiterion, direction)
    }
    
    func transferData(_ profile: Profile) {
        postsCVC.transferData(profile)
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
        return subViewControllers[currentIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if currentIndex >= subViewControllers.count - 1 {
            return nil
        }
        return subViewControllers[currentIndex + 1]
    }
    
  
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = subViewControllers.firstIndex(of: firstViewController){
            PPVCdelegate?.profilePageViewController(ProfilePageViewController: self, didUpdatePageIndex: index)
        }
    }
}

extension ProfilePageViewController: UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
}

extension ProfilePageViewController: UIScrollViewDelegate {
    func scrollToMenuIndex(menuIndex: Int) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    }
}

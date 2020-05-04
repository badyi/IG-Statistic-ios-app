//
//  InsightsViewController.swift
//  IG-Statistic
//
//  Created by и on 24.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit
import Charts

class InsightsViewController: UICollectionViewController {
    var presenter: InsightsPresenter!
    let cellId = "cellId"
    let activityCellId = "activityCellId"
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationVC = self.navigationController as! InsightsNavigationController
        guard let credentials = navigationVC.credentials else { return }
        presenter = InsightsPresenter(view: self, credentials: credentials)
        getActivity()
        setupMenuBar()
        setupCollectionView()
        setupView()
    }
}

extension InsightsViewController {
    func setupView() {
        let backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.navigationController?.navigationBar.barTintColor = backgroundColor
        self.navigationController?.navigationBar.tintColor = backgroundColor
        self.navigationController?.navigationBar.backgroundColor = backgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func getActivity() {
        let beginDate = Date().nDaysAgoInSec(8)
        let endDate = Date().nDaysAgoInSec(1)
        presenter.getActivityInsights(beginDate, endDate, "day")
    }
}

extension InsightsViewController: InsightsViewProtocol {
    func insightsDidLoaded(_ activity: Activity) {
        reloadItem(at: 0)
    }
    
    func reloadItem(at index: Int) {
        let index = IndexPath(row: index, section: 0)
        self.collectionView.reloadItems(at: [index])
    }
}

extension InsightsViewController: UICollectionViewDelegateFlowLayout {
    private func setupMenuBar() {
        let backview = UIView()
        backview.backgroundColor = ThemeManager.currentTheme().backgroundColor
        view.addSubview(backview)
        view.addConstraintsWithFormat("H:|[v0]|", views: backview)
        view.addConstraintsWithFormat("V:[v0(50)]", views: backview)
        view.addSubview(menuBar)
        view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat("V:[v0(50)]", views: menuBar)
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.estimatedItemSize = .zero
        }
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.backgroundColor = ThemeManager.currentTheme().backgroundColor
        collectionView?.register(ActivityCollectionViewCell.self, forCellWithReuseIdentifier: activityCellId)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        // collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        //collectionView?.scrollIndicatorInsets = UIEdgeInsets(top:, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        self.collectionView.contentInset = adjustForTabbarInsets
        self.collectionView.scrollIndicatorInsets = adjustForTabbarInsets
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 2
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: index, section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        let colors: [UIColor] = [.blue, .green, UIColor.gray, .purple]
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: activityCellId, for: indexPath) as! ActivityCollectionViewCell
            cell.config(with: presenter.activity)
            return cell
        }
        cell.backgroundColor = colors[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

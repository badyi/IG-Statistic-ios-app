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
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        setupMenuBar()
        setupCollectionView()
        setupView()
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationVC = self.navigationController as! InsightsNavigationController
        guard let credentials = navigationVC.credentials else { return }
        presenter = InsightsPresenter(view: self, credentials: credentials)
        menuBar.setSectionNames(presenter.getSectionNames())
        getActivity()
        getAudience()
    }
}

extension InsightsViewController {
    func setupView() {
        let backgroundColor = ThemeManager.currentTheme().backgroundColor
        let titleColor = ThemeManager.currentTheme().titleTextColor
        let textAttributes = [NSAttributedString.Key.foregroundColor:titleColor]
        
        navigationController?.navigationBar.topItem?.title = "Insights"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = backgroundColor
        navigationController?.navigationBar.backgroundColor = backgroundColor
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = titleColor
        tabBarController?.tabBar.barTintColor = backgroundColor
    }
    
    func getActivity() {
        let beginDate = Date().nDaysAgoInSec(8)
        let endDate = Date().nDaysAgoInSec(1)
        presenter.loadActivityInsights(beginDate, endDate, "day")
    }
    
    func getAudience() {
        presenter.loadAudienceInsights()
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

extension InsightsViewController: menuBarVCprotocol {
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        menuBar.currentSelected = menuIndex
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
        menuBar.collectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        menuBar.collectionView.reloadData()
        menuBar.collectionView.selectItem(at: IndexPath(row: menuBar.currentSelected, section: 0), animated: true, scrollPosition: .centeredHorizontally)
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
        collectionView?.register(ActivityCollectionViewCell.self, forCellWithReuseIdentifier: presenter.cellID(at: IndexPath(item: 0, section: 0)))
        collectionView?.register(AudienceCollectionViewCell.self, forCellWithReuseIdentifier: presenter.cellID(at: IndexPath(item: 1, section: 0)))
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: presenter.cellID(at: IndexPath(item: 2, section: 0)))
        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 50, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        self.collectionView.contentInset = adjustForTabbarInsets
        self.collectionView.scrollIndicatorInsets = adjustForTabbarInsets
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 2
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: index, section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        menuBar.currentSelected = index
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.insightsCount()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let insightsCellType = presenter.cellType(at: indexPath)
        switch insightsCellType {
        case .activity:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: presenter.cellID(at: indexPath), for: indexPath) as! ActivityCollectionViewCell
            cell.config(with: presenter.getActivityInsights())
            cell.setupViews()
            return cell
        case .audience:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: presenter.cellID(at: indexPath), for: indexPath) as! AudienceCollectionViewCell
            cell.config(with: presenter.getAudienceInsights())
            cell.setupViews()
            cell.delegate = self
            return cell
        default:
            break;
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: presenter.cellID(at: indexPath), for: indexPath)
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

extension InsightsViewController: cellDelegate {
    func showAlert(_ title: String, _ description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        #warning("alert color")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

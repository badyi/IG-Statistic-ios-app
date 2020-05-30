//
//  PostsCollectionViewController.swift
//  IG-Statistic
//
//  Created by Бадый Шагаалан on 28.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit
import ResourceNetworking

private let reuseIdentifier = "PostCollectionViewCell"

class FakeReachability: ReachabilityProtocol {
    var isReachable: Bool = true
}

class PostsCollectionViewController: UICollectionViewController {
    var presenter: PostsCollectionPresenter! 
    private let refreshControl = UIRefreshControl()

    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func refresh() {
        if presenter != nil {
            presenter.getPosts()
            refreshControl.endRefreshing()
        }
    }
}

extension PostsCollectionViewController {
    func setupView() {
        let backgroundColor = ThemeManager.currentTheme().backgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        collectionView!.register(UINib.init(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView!.refreshControl = refreshControl
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = .zero
        collectionView.backgroundColor = backgroundColor
    }
    
    func insightsTapped(with flag: Bool) {
        presenter.setInsightsState(with: flag)
        reloadData()
    }
    
    func sortBy(_ creiterion: sortCriterion, _ direction: sortDirection) {
        presenter.sortBy(creiterion, direction)
    }
}

extension PostsCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = presenter?.postsCount() else {
            return 0
        }
        return count
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let postView = presenter.postView(at: indexPath.row)
        presenter.getPostInfo(at: indexPath.row)
        presenter.getInsights(at: indexPath.row)
        (cell as! PostCollectionViewCell).configure(with: postView, presenter.showInsights())
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.didEndDisplaying(at: indexPath.row)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCollectionViewCell
        cell.configure(with: presenter.postView(at: indexPath.row), presenter.showInsights())
        return cell
    }
}

extension PostsCollectionViewController {
    func transferData(_ profile: Profile) {
        presenter = PostsCollectionPresenter(profile, self)
        presenter.getPosts()
    }
}

extension PostsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 4) / 3
        return CGSize(width: width, height: width)
    }
}

extension PostsCollectionViewController: PostListViewProtocol {
    func reloadData() {
        self.collectionView.reloadData()
    }
    
    func reloadItem(at index: Int) {
        let index: IndexPath = IndexPath(row: index, section: 0)
        self.collectionView.reloadItems(at: [index])
    }
}

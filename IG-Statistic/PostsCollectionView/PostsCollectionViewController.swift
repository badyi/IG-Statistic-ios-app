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
    var presenter: PostsCollectionPresenter! {
        didSet {
            self.collectionView.reloadData()
        }
    }
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        self.collectionView!.register(UINib.init(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.refreshControl = refreshControl
    }
    
    @objc func refresh() {
        collectionView.reloadData()
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
        let post = presenter.post(at: indexPath.row)
        let postView = presenter.postView(at: indexPath.row)
        presenter.getPostInfo(post, indexPath: indexPath)
        (cell as! PostCollectionViewCell).configure(with: postView)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCollectionViewCell
        cell.configure(with: presenter.postView(at: indexPath.row))
        return cell
    }
}

extension PostsCollectionViewController {
    func transferData(_ profile: Profile, _ credentials: Credentials) {
        presenter = PostsCollectionPresenter(profile, credentials,self)
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
    
    func reloadItem(with index: Int) {
        let index: IndexPath = IndexPath(row: index, section: 0)
        self.collectionView.reloadItems(at: [index])
    }
    
    func postsWithIDdidLoaded() {
        self.collectionView.reloadData()
    }
}

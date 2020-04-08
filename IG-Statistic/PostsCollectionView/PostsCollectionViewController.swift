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
    
    let networkHelper = NetworkHelper(reachability: FakeReachability())
    var postsViews: [PostView] = []
    var postsPresenter: PostsCollectionPresenter? {
        didSet {
            self.postsPresenter?.getPosts() { posts in
                self.posts = posts!
            }
        }
    }

    var posts: [Post]? {
        didSet {
            guard let posts = self.posts else {
                return
            }
            let postsViews: [PostView] = posts.map { p in
                let result = PostView(with: p)
                result.delegate = self
                return result
            }
            self.postsViews = postsViews
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
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
        guard let count = posts?.count else {
            return 0
        }
        return count
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let post = posts?[indexPath.row] else {
            return
        }
        postsPresenter?.getPostInfo(post) { result in
            guard let post = result else { return }
            self.postsViews[indexPath.row].setAllInfo(with: post)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCollectionViewCell
        if posts?.count == 0 {
            return cell
        }
        
        cell.config(with: postsViews[indexPath.row])
        return cell
    }
}

extension PostsCollectionViewController {
    func didLoadedPosts(_ posts: [Post]) {
        self.posts = posts
    }
    
    func transferData(_ profile: Profile, _ credentials: Credentials) {
        postsPresenter = PostsCollectionPresenter(profile, credentials)
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

extension PostsCollectionViewController: PostViewDelegate {
    func iconDidLoaded(for post: PostView) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func urlDidLoaded(for post: PostView) {
        
    }
}

//
//  PostsCollectionPresenter.swift
//  IG-Statistic
//
//  Created by Бадый Шагаалан on 29.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation
import ResourceNetworking

protocol PostListViewProtocol: AnyObject {
    func reloadData()
    func reloadItem(with index: Int)
    func postsWithIDdidLoaded()
}

class PostsCollectionPresenter {
    weak var view: PostListViewProtocol?
    private var profile: Profile!
    private var credentials: Credentials!
    private var postService: PostService!
    
    var posts: [Post] = [] {
        didSet {
            let postsViews: [PostView] = posts.map { p in
                let result = PostView(with: p)
                result.delegate = self
                return result
            }
            self.postsViews = postsViews
            DispatchQueue.main.async {
                self.view?.postsWithIDdidLoaded()            
            }
        }
    }
    
    var postsViews: [PostView] = []
    
    init(_ profile: Profile,_ credentials: Credentials, _ view: PostListViewProtocol) {
        self.profile = profile
        self.credentials = credentials
        postService = PostService()
        self.view = view
    }
    
    func getPosts() {
        postService.getAllPostsIDList(credentials){ result in
            switch result {
            case let .success(posts):
                let posts: [Post] = posts
                self.posts = posts
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func postsCount() -> Int {
        posts.count
    }
    
    func post(at index: Int) -> Post {
        posts[index]
    }
    
    func postView(at index: Int) -> PostView {
        postsViews[index]
    }
    
    func getPostInfo (_ post: Post, indexPath: IndexPath) {
        postService.getPostInfo(credentials, post) { result in
            switch result {
            case let .success(post):
                let post: Post = post
                self.postView(at: indexPath.row).setAllInfo(with: post)
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension PostsCollectionPresenter: PostViewDelegate {
    func iconDidLoaded(for post: PostView) {
        DispatchQueue.main.async {
            guard let index = self.postsViews.firstIndex(of: post) else { return }
            self.view?.reloadItem(with: index)
        }
    }
    
    func urlDidLoaded(for post: PostView) {
        
    }
}

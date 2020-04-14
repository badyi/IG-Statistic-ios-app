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
    private var shInsights: Bool = false
    let semaphore = DispatchSemaphore(value: 1)
    
    var posts: [Post] = [] {
        didSet {
            let postsViews: [PostView] = posts.map { p in
                let result = PostView(with: p)
                result.delegate = self
                return result
            }
            self.postsViews = postsViews
        }
    }
    
    var postsViews: [PostView] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view?.postsWithIDdidLoaded()
            }
        }
    }
    
    init(_ profile: Profile,_ credentials: Credentials, _ view: PostListViewProtocol) {
        self.profile = profile
        self.credentials = credentials
        postService = PostService()
        self.view = view
    }
    
    func getPosts() {
        postService.getAllPostsIDList(credentials) { result in
            switch result {
            case let .success(posts):
                let posts: [Post] = posts
                self.posts = posts
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func setInsightsState(with flag: Bool){
        shInsights = flag
    }
    
    func showInsights() -> Bool {
        shInsights
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
    
    func getPostInfo (_ post: Post, index: Int) {
        if post.date != nil {
            return
        }
        postService.getPostInfo(credentials, post) {[weak self] result in
            switch result {
            case let .success(post):
                let post: Post = post
                self?.postView(at: index).setAllInfo(with: post)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getInsights(post: PostView, index: Int) {
        if post.insights != nil {
            return
        }
        postService.getPostInsights(credentials, post) {[weak self] result in
            switch result {
            case let .success(insights):
                let insights: Insights = insights
                self?.postView(at: index).insights = insights
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension PostsCollectionPresenter: PostViewDelegate {
    func loadInsights(for post: PostView) {
        let index = postsViews.firstIndex(of: post)
        getInsights(post: post, index: index!)
    }
    
    func insightsDidLoaded(for post: PostView) {
        DispatchQueue.main.async { [weak self] in
            guard let index = self?.postsViews.firstIndex(of: post) else { return }
            self?.view?.reloadItem(with: index)
        }
    }
    
    func iconDidLoaded(for post: PostView) {
        DispatchQueue.main.async { [weak self] in
            guard let index = self?.postsViews.firstIndex(of: post) else { return }
            self?.view?.reloadItem(with: index)
        }
    }
    
    func urlDidLoaded(for post: PostView) {
        
    }
}

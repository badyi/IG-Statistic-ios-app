//
//  PostListModel.swift
//  IG-Statistic
//
//  Created by и on 04.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation

protocol PostListModelProtocol {
    var postsCount: Int { get }
    
    func postView(at index: Int) -> PostView
    func post(at index: Int) -> Post
}

protocol PostListModelDelegate: AnyObject {
    func postViewsLoaded()
    func postViewDidChange(at index: Int)
}

final class PostListModel: PostListModelProtocol {
    
    var profile: Profile!
    var postsCount: Int {
        posts.count
    }
    
    private var postService: PostService!
    weak var delegate: PostListModelDelegate?
    
    var posts: [Post] = [] {
        didSet {
            let postsViews: [PostView] = posts.map { p in
                let result = PostView(with: p)
                result.delegate = self
                return result
            }
            self.postViews = postsViews
        }
    }
    
    var postViews: [PostView] = [] {
        didSet {
            delegate?.postViewsLoaded()
        }
    }
    
    init(with profile: Profile, delegat: PostListModelDelegate) {
        self.profile = profile
        self.delegate = delegat
        postService = PostService()
    }
    
    func postView(at index: Int) -> PostView {
        postViews[index]
    }
    
    func post(at index: Int) -> Post {
        posts[index]
    }
    

    func getPosts() {
        postService.getAllPostsIDList(profile.credentials) { [weak self] result in
            switch result {
            case let .success(posts):
                let posts: [Post] = posts
                self?.posts = posts
            case let .failure(error):
                print(error)
            }
        }
    }
       
    func getPostInfo (at index: Int) {
        let post = posts[index]
        if post.date != nil {
            return
        }
        postService.getPostInfo(profile.credentials, post) { [weak self] result in
            switch result {
            case let .success(post):
                let post: Post = post
                self?.postView(at: index).setAllInfo(with: post)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getInsights(at index: Int) {
        let post = postView(at: index)
        if post.insights != nil {
            return
        }
        postService.getPostInsights(profile.credentials, post) { [weak self] result in
            switch result {
            case let .success(insights):
                let insights: Insights = insights
                self?.postView(at: index).insights = insights
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func setInsightsState(with flag: Bool) {
        profile.showInsightsOnPosts = flag
    }
    
    func showInsightsState() -> Bool {
        profile.showInsightsOnPosts
    }
}

extension PostListModel: PostViewDelegate {
    func insightsDidLoaded(for post: PostView) {
        guard let index = postViews.firstIndex(of: post) else { return }
        delegate?.postViewDidChange(at: index)
    }
    
    func iconDidLoaded(for post: PostView) {
        guard let index = postViews.firstIndex(of: post) else { return }
        delegate?.postViewDidChange(at: index)
    }
}

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
    
    private var profile: Profile!
    var postsCount: Int {
        posts.count
    }
    
    private var postService: PostService!
    private weak var delegate: PostListModelDelegate?
    let dispatchGroup = DispatchGroup()
    var posts: [Post] = []
    
    var postViews: [PostView] = [] {
        didSet {
            delegate?.postViewsLoaded()
        }
    }
        
    var sCriterion: sortCriterion?
    var direction: sortDirection?

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
                let postsViews: [PostView] = posts.map { p in
                    let result = PostView(with: p)
                    result.delegate = self
                    return result
                }
                self?.postViews = postsViews
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

protocol ListSortingProtocol {
    func qsort(_ leftIndex: Int,_ rightIndex: Int)
    func sortBy(_ criterion: sortCriterion, _ direction: sortDirection)
    func swap (_ firstIndex: Int,_ secondIndex: Int)
    func firstCompare(_ lhs: PostView, _ rhs: PostView) -> Bool
    func secondCompare(_ lhs: PostView, _ rhs: PostView) -> Bool
}

extension PostListModel: ListSortingProtocol {
    func sortBy(_ criterion: sortCriterion, _ direction: sortDirection) {
        sCriterion = criterion
        self.direction = direction
        getCriteriaData()
    }
    func getCriteriaData() {
        for i in 0..<posts.count {
            let post = posts[i]
            dispatchGroup.enter()
            postService.getPostInfo(profile.credentials, post) { [weak self] result in
                switch result {
                case let .success(post):
                    let post: Post = post
                    self?.postView(at: i).setAllInfo(with: post)
                    self?.dispatchGroup.leave()
                case let .failure(error):
                    print(error)
                    self?.dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.qsort(0,(self?.posts.count)! - 1)
            self?.delegate?.postViewsLoaded()
        }
    }
    
    func qsort(_ leftIndex: Int,_ rightIndex: Int) {
        var l = leftIndex
        var r = rightIndex
        let pivot = postViews[(l + r) / 2]
        while l <= r {
            while firstCompare(postViews[l], pivot) {
                l += 1
            }
            while secondCompare(postViews[r], pivot) {
                r -= 1
            }
            if l<=r {
                swap(l, r)
                l += 1
                r -= 1
            }
            if leftIndex < r {
                qsort(leftIndex, r)
            }
            if rightIndex > l {
                qsort(l, rightIndex)
            }
        }
    }

    func swap (_ firstIndex: Int,_ secondIndex: Int) {
        let temp1 = posts[firstIndex]
        let temp2 = postViews[firstIndex]
        
        posts[firstIndex] = posts[secondIndex]
        postViews[firstIndex] = postViews[secondIndex]
        
        posts[secondIndex] = temp1
        postViews[secondIndex] = temp2
    }
    
    func firstCompare(_ lhs: PostView, _ rhs: PostView) -> Bool {
        if direction == .ascending {
            switch sCriterion {
            case .date:
                let date1 = Date(with: lhs.date!)
                let date2 = Date(with: rhs.date!)
                return date1 < date2
            case .likes:
                return lhs.likesCount! < rhs.likesCount!
            default:
                return false
            }
        } else {
            switch sCriterion {
            case .date:
                let date1 = Date(with: lhs.date!)
                let date2 = Date(with: rhs.date!)
                return date1 > date2
            case .likes:
                return lhs.likesCount! > rhs.likesCount!
            default:
                return false
            }
        }
    }
    
    func secondCompare(_ lhs: PostView, _ rhs: PostView) -> Bool {
        if direction == .ascending {
            switch sCriterion {
            case .date:
                let date1 = Date(with: lhs.date!)
                let date2 = Date(with: rhs.date!)
                return date1 > date2
            case .likes:
                return lhs.likesCount! > rhs.likesCount!
            default:
                return false
            }
        } else {
            switch sCriterion {
            case .date:
                let date1 = Date(with: lhs.date!)
                let date2 = Date(with: rhs.date!)
                return date1 < date2
            case .likes:
                return lhs.likesCount! < rhs.likesCount!
            default:
                return false
            }
        }
    }
}

enum sortCriterion {
    case date, likes
}

enum sortDirection {
    case descending, ascending
}

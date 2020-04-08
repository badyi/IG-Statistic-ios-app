//
//  PostsCollectionPresenter.swift
//  IG-Statistic
//
//  Created by Бадый Шагаалан on 29.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation
import ResourceNetworking

class PostsCollectionPresenter {
    let networkHelper = NetworkHelper(reachability: FakeReachability())
    var profile: Profile
    var credentials: Credentials
    var postService: PostService
    
    init(_ profile: Profile,_ credentials: Credentials) {
        self.profile = profile
        self.credentials = credentials
        postService = PostService()
    }
    
    func getPosts(completionBlock: @escaping(_ posts: [Post]?) -> ()) {
        postService.getAllPostsWithID(credentials) { posts in
            completionBlock(posts)
        }
    }
    
    func getPostInfo (_ post: Post,completionBlock: @escaping(_ posts: Post?) -> ()) {
        _ = networkHelper.load(resource: postService.getPostInfoResource(credentials, post)) { result in
            switch result {
            case let .success(jsonResponse):
                var post = Post(with: post.id)
                post.caption = jsonResponse.caption
                post.mediaURL = jsonResponse.media_url
                post.mediaType = jsonResponse.media_type
                post.date = jsonResponse.timestamp
                post.likesCount = jsonResponse.like_count
                post.isCommentEnabled = jsonResponse.is_comment_enabled
                post.username = jsonResponse.username
                post.ownerID = jsonResponse.owner.id
                completionBlock(post)
            default:
                
                break
            }
        }
    }
}

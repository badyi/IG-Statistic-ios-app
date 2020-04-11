//
//  PostService.swift
//  IG-Statistic
//
//  Created by Бадый Шагаалан on 28.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation
import ResourceNetworking

fileprivate struct PostsResponse: Codable {
    let media: Media
    let id: String
}

struct Media: Codable {
    fileprivate let data: [Data]
    let paging: Paging
}

fileprivate struct Data: Codable {
    let id: String
}

fileprivate struct PostResponse: Codable {
    let id: String
    let media_type: String
    let media_url: String
    let owner: Owner
    let timestamp: String
    let caption: String?
    let is_comment_enabled: Bool
    let like_count: Int
    let username: String
}

struct Owner: Codable {
    let id: String
}

fileprivate final class PostResourceFactory {
    func createPostsListResource(with credentials: Credentials) -> Resource<PostsResponse>? {
        guard let instID = credentials.instUserID else {
            print("smt went wrong. invalid inst user id")
            return nil
        }
        guard var urlComponents = URLComponents(string: "https://graph.facebook.com/\(instID)") else {
            print("smt went wrong. invalid url components")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "fields", value: "media"),
            URLQueryItem(name: "access_token", value: credentials.fbAccessToken)
        ]
        guard let url = urlComponents.url else {
            print("smt went wrong. invalid url")
            return nil
        }
        return Resource(url: url, headers: nil)
    }
    
    func createPostInfoResource(with credentials: Credentials,_ post: Post) -> Resource<PostResponse>? {
        guard var urlComponents = URLComponents(string: "https://graph.facebook.com/\(post.id)") else {
            print("smt went wrong. invalid url components")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "fields", value: "id,media_type,media_url,owner,timestamp,caption,is_comment_enabled,like_count,username"),
            URLQueryItem(name: "access_token", value: credentials.fbAccessToken)
        ]
        guard let url = urlComponents.url else {
            print("smt went wrong. invalid url")
            return nil
        }
        return Resource(url: url, headers: nil)
    }
}

final class PostService {
    let networkHelper = NetworkHelper(reachability: FakeReachability())

    func getAllPostsIDList(_ credentials: Credentials, completionBlock: @escaping(OperationCompletion<[Post]>) -> ()) {
        guard let resource = PostResourceFactory().createPostsListResource(with: credentials) else {
            let error = Error.self
            completionBlock(.failure(error as! Error))
            return
        }
        _ = networkHelper.load(resource: resource) { result in
            switch result {
            case let .success(postsResponse):
                let postsResponse: PostsResponse = postsResponse
                let posts = postsResponse.media.data.map { Post(with: $0.id) }
                completionBlock(.success(posts))
            case let .failure(error):
                completionBlock(.failure(error))
            }
        }
    }
    
    func getPostInfo(_ credentials: Credentials,_ post: Post ,completionBlock: @escaping(OperationCompletion<Post>) -> ()) {
        guard let resource = PostResourceFactory().createPostInfoResource(with: credentials, post) else {
            let error = Error.self
            completionBlock(.failure(error as! Error))
            return
        }
        _ = networkHelper.load(resource: resource) { result in
            switch result {
            case let .success(postInfo):
                let postResponse: PostResponse = postInfo
                var post: Post = Post(with: post.id)
                post.caption = postResponse.caption
                post.date = postResponse.timestamp
                post.mediaURL = postResponse.media_url
                post.mediaType = postResponse.media_type
                post.likesCount = postResponse.like_count
                post.username = postResponse.username
                post.ownerID = postResponse.owner.id
                completionBlock(.success(post))
            case let .failure(error):
                completionBlock(.failure(error))
            }
        }
    }
}
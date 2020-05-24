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
struct TaggedPostsResponse: Codable {
    let data: [TaggedData]
}

struct TaggedData: Codable {
    let media_type: String
    let caption: String?
    let comments_count: Int
    let media_url: String
    let like_count: Int
    let id: String
}

fileprivate struct Media: Codable {
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
    let username: String?
    let thumbnail_url: String?
    let comments_count: Int
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
    
    func createPostInfoResource(with credentials: Credentials, _ post: Post, _ fields: String) -> Resource<PostResponse>? {
        guard var urlComponents = URLComponents(string: "https://graph.facebook.com/\(post.id)") else {
            print("smt went wrong. invalid url components")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "fields", value: fields),
            URLQueryItem(name: "access_token", value: credentials.fbAccessToken)
        ]
        guard let url = urlComponents.url else {
            print("smt went wrong. invalid url")
            return nil
        }
        return Resource(url: url, headers: nil)
    }
    
    func createTaggedPostsListResource(with credentials: Credentials) -> Resource<TaggedPostsResponse>? {
        guard let instID = credentials.instUserID else {
            print("smt went wrong. invalid inst user id")
            return nil
        }
        guard var urlComponents = URLComponents(string: "https://graph.facebook.com/\(instID)/tags") else {
            print("smt went wrong. invalid url components")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "fields", value: "media_type,owner,caption,comments_count,media_url,like_count"),
            URLQueryItem(name: "access_token", value: credentials.fbAccessToken)
        ]
        guard let url = urlComponents.url else {
            print("smt went wrong. invalid url")
            return nil
        }
        return Resource(url: url, headers: nil)
    }
    
    func createInsightsResource(with credentials: Credentials,_ post: PostView) -> Resource<InsightsResonse>? {
        guard var urlComponents = URLComponents(string: "https://graph.facebook.com/\(post.id)/insights") else {
            print("smt went wrong. invalid url components")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "metric", value: "engagement,impressions,reach,saved"),
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
            let error = NSError(domain: "cant get all posts list with id", code: 1, userInfo: nil)
            completionBlock(.failure(error))
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
    
    func getAllTaggedPostsIDList(_ credentials: Credentials, completionBlock: @escaping(OperationCompletion<[Post]>) -> ()) {
        guard let resource = PostResourceFactory().createTaggedPostsListResource(with: credentials) else {
            let error = NSError(domain: "cant get all posts list with id", code: 1, userInfo: nil)
            completionBlock(.failure(error))
            return
        }
        _ = networkHelper.load(resource: resource) { result in
            switch result {
            case let .success(postsResponse):
                let postsResponse: TaggedPostsResponse = postsResponse
                let posts = postsResponse.data.map { (i: TaggedData) -> Post in
                        var post = Post(with: i.id)
                        post.mediaURL = i.media_url
                        post.mediaType = i.media_type
                        post.thumbnail_url = i.media_url
                        post.likesCount = i.like_count
                        post.caption = i.caption
                        post.commentesCount = i.comments_count
                        return post
                }
                completionBlock(.success(posts))
            case let .failure(error):
                completionBlock(.failure(error))
            }
        }
    }
    
    func getPostInfo(_ credentials: Credentials,_ post: Post ,completionBlock: @escaping(OperationCompletion<Post>) -> ()) {
        let fields = "id,media_type,media_url,owner,timestamp,caption,is_comment_enabled,like_count,username,thumbnail_url,comments_count"
        guard let resource = PostResourceFactory().createPostInfoResource(with: credentials, post, fields) else {
            let error = NSError(domain: "cant get post info", code: 1, userInfo: nil)
            completionBlock(.failure(error))
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
                post.thumbnail_url = postResponse.thumbnail_url
                post.commentesCount = postResponse.comments_count
                completionBlock(.success(post))
            case let .failure(error):
                completionBlock(.failure(error))
            }
        }
    }
    
    func getPostInsights(_ credentials: Credentials, _ post: PostView, completionBlock: @escaping(OperationCompletion<Insights>) -> ()) {
        guard let resource = PostResourceFactory().createInsightsResource(with: credentials, post) else {
            let error = NSError(domain: "cant get posts Insights", code: 1, userInfo: nil)
            completionBlock(.failure(error))
            return
        }
        _ = networkHelper.load(resource: resource) { result in
            switch result {
            case let .success(postInsights):
                var insights = Insights()
                insights.enable = true
                insights.engagement = postInsights.data[0].values[0].value
                insights.impressions = postInsights.data[1].values[0].value
                insights.reach = postInsights.data[2].values[0].value
                insights.saved = postInsights.data[3].values[0].value
                completionBlock(.success(insights))
            case .failure(_):
                let insights = Insights()
                completionBlock(.success(insights))
            }
        }
    }
}

fileprivate struct InsightsResonse: Codable {
    let data: [Datum]
}

fileprivate struct Datum: Codable {
    let name, period: String
    let values: [Value]
    let title, datumDescription, id: String

    enum CodingKeys: String, CodingKey {
        case name, period, values, title
        case datumDescription = "description"
        case id
    }
}

fileprivate struct Value: Codable {
    let value: Int
}


//
//  PostService.swift
//  IG-Statistic
//
//  Created by Бадый Шагаалан on 28.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation
import ResourceNetworking

struct PostsResponse: Codable {
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

struct PostResponse: Codable {
    let id: String
    let media_type: String
    let media_url: String
    let owner: Owner
    let timestamp: String
    let caption: String
    let is_comment_enabled: Bool
    let like_count: Int
    let username: String
}

struct Owner: Codable {
    let id: String
}

class PostService {
    func getAllPostsWithID(_ credentials: Credentials, completionBlock: @escaping(_ posts: [Post]?) -> ()) {
        guard let instID = credentials.instUserID else {
            return
        }
        guard var urlComponents = URLComponents(string: "https://graph.facebook.com/\(instID)") else {
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "fields", value: "media"),
            URLQueryItem(name: "access_token", value: credentials.fbAccessToken)
        ]
        guard let url = urlComponents.url else {
            return
        }
        let session = URLSession.shared
        session.dataTask(with: url){ (data, response, error) in
            if error != nil {
                completionBlock(nil)
                return
            }
            guard response != nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                let jsonResponse = try JSONDecoder().decode(PostsResponse.self, from: data)
                let posts = jsonResponse.media.data.map { Post(with: $0.id) }
                completionBlock(posts)
            } catch {
                completionBlock(nil)
            }
        }.resume()
    }
    
    func getPostInfo(_ credentials: Credentials,_ post: Post ,completionBlock: @escaping(_ post: Post?) -> ()) {
        guard var urlComponents = URLComponents(string: "https://graph.facebook.com/\(post.id)") else {
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "fields", value: "id,media_type,media_url,owner,timestamp,caption,is_comment_enabled,like_count,username"),
            URLQueryItem(name: "access_token", value: credentials.fbAccessToken)
        ]
        guard let url = urlComponents.url else {
            return
        }
        let session = URLSession.shared
        session.dataTask(with: url){ (data, response, error) in
            if error != nil {
                completionBlock(nil)
                return
            }
            guard response != nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                let jsonResponse = try JSONDecoder().decode(PostResponse.self, from: data)
//                post.caption = jsonResponse.caption
//                post.mediaURL = jsonResponse.mediaURL
//                post.mediaType = jsonResponse.mediaType
//                post.date = jsonResponse.timestamp
//                post.likesCount = jsonResponse.likeCount
//                                post.isCommentEnabled = jsonResponse.isCommentEnabled
//                post.username = jsonResponse.username
//                post.ownerID = jsonResponse.owner.id
//                post.commentesCount = jsonResponse
                completionBlock(post)
            } catch {
                completionBlock(nil)
            }
        }.resume()
    }
    
    func getPostInfoResource(_ credentials: Credentials, _ post: Post) -> Resource<PostResponse> {
        let str = "https://graph.facebook.com/\(post.id)"
        guard var urlComponents = URLComponents(string: "\(str)") else {
            fatalError("urlCmpsError")
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "fields", value: "id,media_type,media_url,owner,timestamp,caption,is_comment_enabled,like_count,username"),
            URLQueryItem(name: "access_token", value: credentials.fbAccessToken)
        ]
        guard let url = urlComponents.url else {
            fatalError("urlError")
        }
        return Resource(url: url, headers: nil)
     }
}

//,owner,timestamp,caption,is_comment_enabled,like_count,username

//struct ServerPost: Codable {
//    let id: String
//    let media_type: String
//    let media_url: String
//    let owner: Owner
//    let timestamp: String
//    let caption: String
//    let is_comment_enabled: Bool
//    let like_count: Int
//}

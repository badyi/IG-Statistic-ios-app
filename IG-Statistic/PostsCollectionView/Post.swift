//
//  Post.swift
//  IG-Statistic
//
//  Created by Бадый Шагаалан on 28.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation
import UIKit
import ResourceNetworking

protocol PostViewDelegate: AnyObject {
    func iconDidLoaded(for post: PostView)
    func urlDidLoaded(for post: PostView)
}

class PostView {
    let uid = UUID().uuidString
    var id: String
    var caption: String?
    var mediaType: String?
    var date: String?
    var likesCount: Int?
    var isCommentEnabled: Bool?
    var commentesCount: Int?
    var location: String?
    var username: String?
    var ownerID: String?
    
    
    private var cancel: Cancellation?
    
    private(set) var mediaURL: String? {
        didSet{
            loadImageIfNeeded()
        }
    }
    
    private(set) var image: UIImage? {
        didSet {
            delegate?.iconDidLoaded(for: self)
        }
    }
    
    let networkHelper = NetworkHelper(reachability: FakeReachability())

    init(with post: Post) {
        id = post.id
    }
    
    func setAllInfo(with post: Post) {
        id = post.id
        caption = post.caption
        mediaType = post.mediaType
        mediaURL = post.mediaURL
        date = post.date
        likesCount = post.likesCount
        isCommentEnabled = post.isCommentEnabled
        commentesCount = post.commentesCount
        username = post.username
        ownerID = post.ownerID
    }

    weak var delegate: PostViewDelegate?
}

extension PostView: Equatable {
    static func == (lhs: PostView, rhs: PostView) -> Bool {
        lhs.uid == rhs.uid
    }
}

extension PostView {
    func loadImageIfNeeded() {
        if image != nil || cancel != nil { return }
        guard let urlString = mediaURL else {
            return
        }
        guard let resourse = ResourseFactory().createImageResource(for: urlString) else {
            return
        }
        _ = networkHelper.load(resource: resourse) { result in
            switch result {
            case let .success(image):
                self.image = image
            case let .failure(error):
                print(error)
            }
        }
    }
}

fileprivate final class ResourseFactory {
    func createImageResource(for urlString: String) -> Resource<UIImage>? {
        guard let url = URL(string: urlString) else { return nil }
        let parse: (Data) throws -> UIImage = { data in
            guard let image = UIImage(data: data) else {
                throw NSError(domain: "some_domain", code: 129, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("My string", comment: "My comment")])
            }
            return image
        }
        return Resource<UIImage>(url: url, method: .get, parse: parse)
    }
}

struct Post: Codable {
    var id: String
    var caption: String?
    var mediaType: String?
    var mediaURL: String?
    var date: String?
    var likesCount: Int?
    var isCommentEnabled: Bool?
    var commentesCount: Int?
    var location: String?
    var username: String?
    var ownerID: String?
    
    init(with id: String) {
        self.id = id
    }
}

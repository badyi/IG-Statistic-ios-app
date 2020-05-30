//
//  Service.swift
//  IG-Statistic widget
//
//  Created by и on 28.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit
import ResourceNetworking

struct MainInfoResponse: Codable {
    let id: String
    let username: String
    let media_count: Int
    let followers_count: Int
    let follows_count: Int
    let profile_picture_url: String?
}

final class ProfileResourceFactory {
    func createMainProfileInfoResource(with credentials: Credentials) -> Resource<MainInfoResponse>? {
        let instID = credentials.instUserID 
        guard var urlComponents = URLComponents(string: "https://graph.facebook.com/v3.2/\(instID)") else {
            print("smt went wrong. invalid url components")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "fields", value: "id,username,name,media_count,followers_count,follows_count,profile_picture_url"),
            URLQueryItem(name: "access_token", value: credentials.fbToken)
        ]
        guard let url = urlComponents.url else {
            print("smt went wrong. invalid url")
            return nil
        }
        return Resource(url: url, headers: nil)
    }
    
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

final class Service {
    let networkHelper = NetworkHelper(reachability: FakeReachability(isReachable: true))

    func getMainProfileInfo (_ credentials: Credentials, completionBlock: @escaping(OperationCompletion<Profile>) -> ()) {
        guard let resource = ProfileResourceFactory().createMainProfileInfoResource(with: credentials) else {
            let error = NSError(domain: "cant get main profile info", code: 1, userInfo: nil)
            completionBlock(.failure(error))
            return
        }
        _ = networkHelper.load(resource: resource) { result in
            switch result {
            case let .success(mainInfo):
                let mainInfo: MainInfoResponse = mainInfo
                let profile = Profile(with: credentials,and: mainInfo.id)
                profile.setInfo(mainInfo)
                completionBlock(.success(profile))
            case let .failure(error):
                completionBlock(.failure(error))
            }
        }
    }
    
    func getImage(_ imageURL: String, completionBlock: @escaping(OperationCompletion<UIImage>) -> ()) {
        guard let resource = ProfileResourceFactory().createImageResource(for: imageURL) else {
            let error = NSError(domain: "cant get image", code: 1, userInfo: nil)
            completionBlock(.failure(error))
            return
        }
        _ = networkHelper.load(resource: resource) { result in
            switch result {
                case let .success(image):
                    let image = image
                    completionBlock(.success(image))
                case let .failure(error):
                    completionBlock(.failure(error))
            }
        }
    }
}


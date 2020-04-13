//
//  ProfileService.swift
//  IG-Statistic
//
//  Created by Бадый Шагаалан on 23.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit
import ResourceNetworking

struct MainInfoResponse: Codable {
    let biography: String
    let id: String
    let username: String
    let name: String
    let media_count: Int
    let followers_count: Int
    let follows_count: Int
    let profile_picture_url: String
}



fileprivate final class ProfileResourceFactory {
    func createMainProfileInfoResource(with credentials: Credentials) -> Resource<MainInfoResponse>? {
        guard let instID = credentials.instUserID else {
            print("smt went wrong. invalid inst user id")
            return nil
        }
        guard var urlComponents = URLComponents(string: "https://graph.facebook.com/v3.2/\(instID)") else {
            print("smt went wrong. invalid url components")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "fields", value: "biography,id,username,name,website,media_count,followers_count,follows_count,profile_picture_url"),
            URLQueryItem(name: "access_token", value: credentials.fbAccessToken)
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

final class ProfileService {
    let networkHelper = NetworkHelper(reachability: FakeReachability())

    func getMainProfileInfo (_ credentials: Credentials, completionBlock: @escaping(OperationCompletion<Profile>) -> ()) {
        guard let resource = ProfileResourceFactory().createMainProfileInfoResource(with: credentials) else {
            let error = Error.self
            completionBlock(.failure(error as! Error))
            return
        }
        _ = networkHelper.load(resource: resource) { result in
            switch result {
            case let .success(mainInfo):
                let mainInfo: MainInfoResponse = mainInfo
                let profile = Profile(with: mainInfo.id)
                profile.setInfo(mainInfo)
                completionBlock(.success(profile))
            case let .failure(error):
                completionBlock(.failure(error))
            }
        }
    }
    
    func getImage(_ imageURL: String, completionBlock: @escaping(OperationCompletion<UIImage>) -> ()) {
        guard let resource = ProfileResourceFactory().createImageResource(for: imageURL) else {
            let error = Error.self
            completionBlock(.failure(error as! Error))
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


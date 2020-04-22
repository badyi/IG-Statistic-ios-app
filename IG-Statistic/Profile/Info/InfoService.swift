//
//  InfoService.swift
//  IG-Statistic
//
//  Created by и on 21.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation
import ResourceNetworking
import UIKit

fileprivate struct NameResponse: Codable {
    let name: String
    let id: String
}

fileprivate struct FBLinkResponse: Codable {
    let link: String?
    let id: String
}

fileprivate final class InfoResourceFactory {
    func createFBLinkResoutce(with credentials: Credentials) -> Resource<FBLinkResponse>? {
        guard let fbID = credentials.fbUserId else {
            print("id is missing.")
            return nil
        }
        guard var urlComponents = URLComponents(string: "https://graph.facebook.com/v6.0/\(fbID)/") else {
            print("Wrong url. couldnt create resource")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "fields", value: "link"),
            URLQueryItem(name: "access_token", value: credentials.fbAccessToken)
        ]
        guard let url = urlComponents.url else {
            print("Wrong url. couldnt create resource")
            return nil
        }
        return Resource(url: url, headers: nil)
    }
    
    func createFBnameResource(with credentials: Credentials) -> Resource<NameResponse>? {
        guard var urlComponents = URLComponents(string: "https://graph.facebook.com/v6.0/me") else {
            print("Wrong url. couldnt create user page resource")
            return nil
        }
        urlComponents.queryItems = [ URLQueryItem(name: "access_token", value: credentials.fbAccessToken) ]
        guard let url = urlComponents.url else {
            print("Wrong url. couldnt create correct FB name resource")
            return nil
        }
        return Resource(url: url, headers: nil)
    }
    
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

final class InfoService {
    let networkHelper = NetworkHelper(reachability: FakeReachability())
    
    func getFBLink(_ credentials: Credentials, completionBlock: @escaping(OperationCompletion<String?>) -> ()) {
        guard let resource = InfoResourceFactory().createFBLinkResoutce(with: credentials) else {
            let error = Error.self
            completionBlock(.failure(error as! Error))
            return
        }
        _ = networkHelper.load(resource: resource) { result in
            switch result {
            case let .success(response):
                let resp: FBLinkResponse = response
                completionBlock(.success(resp.link))
            case let .failure(error):
                completionBlock(.failure(error))
            }
        }
    }
    
    func getFBname(_ credentials: Credentials, completionBlock: @escaping(OperationCompletion<String>) -> ()) {
        guard let resource = InfoResourceFactory().createFBnameResource(with: credentials) else {
            let error = Error.self
            completionBlock(.failure(error as! Error))
            return
        }
        _ = networkHelper.load(resource: resource) {result in
            switch result {
            case let .success(nameResponse):
                let response: NameResponse = nameResponse
                completionBlock(.success(response.name))
            case let .failure(error):
                completionBlock(.failure(error))
            }
        }
    }
    
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
    }}

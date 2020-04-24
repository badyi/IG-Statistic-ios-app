//
//  AuthService.swift
//  IG-Statistic
//
//  Created by Бадый Шагаалан on 24.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation
import ResourceNetworking

struct CategoryList: Codable {
    let id: String
    let name: String
}

struct Cursors: Codable {
    let before: String
    let after: String
}

struct Paging: Codable {
    let cursors: Cursors
}

fileprivate struct Data: Codable {
    let access_token: String
    let category: String
    let category_list: [CategoryList]
    let name: String
    let id: String
    let tasks: [String]
}

fileprivate struct usersPagesResponse: Codable {
    fileprivate let data: [Data]
    let paging: Paging
}

fileprivate struct InstBusinessAccountResponse: Codable {
    let instagram_business_account: InstagramBusinessAccount
    let category: String?
    let id: String
}

fileprivate struct InstagramBusinessAccount: Codable {
    let id: String
}

struct FBID: Codable {
    let name: String;
    let id: String;
}

fileprivate final class AuthResourceFactory {
    func createFBIDResource(with credentials: Credentials) -> Resource<FBID>? {
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
    
    func createUserPagesResource(with credentials: Credentials) -> Resource<usersPagesResponse>? {
        guard var urlComponents = URLComponents(string: "https://graph.facebook.com/v6.0/me/accounts/") else {
            print("Wrong url. couldnt create user page resource")
            return nil
        }
        urlComponents.queryItems = [ URLQueryItem(name: "access_token", value: credentials.fbAccessToken) ]
        guard let url = urlComponents.url else {
            print("Wrong url. couldnt create correct user page resource")
            return nil
        }
        return Resource(url: url, headers: nil)
    }
    
    func createPagesInstagramBusinessAccountResource(with credentials: Credentials) -> Resource<InstBusinessAccountResponse>? {
        guard let pageID = credentials.pageID else {
            print("page id is missing.")
            return nil
        }
        guard var urlComponents = URLComponents(string: "https://graph.facebook.com/v6.0/\(pageID)/") else {
            print("Wrong url. couldnt create Pages IGBA resource")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "fields", value: "instagram_business_account,category"),
            URLQueryItem(name: "access_token", value: credentials.fbAccessToken)
        ]
        guard let url = urlComponents.url else {
            print("Wrong url. couldnt create Pages IGBA resource")
            return nil
        }
        return Resource(url: url, headers: nil)
    }
}

final class AuthService {
    let networkHelper = NetworkHelper(reachability: FakeReachability())
    
    func getFBID_(_ credentials: Credentials, completionBlock: @escaping(OperationCompletion<FBID>) -> ()){
        guard let resource = AuthResourceFactory().createFBIDResource(with: credentials) else {
            let error = Error.self
            completionBlock(.failure(error as! Error))
            return
        }
        _ = networkHelper.load(resource: resource) {result in
            switch result {
            case let .success(Response):
                let response: FBID = Response
                completionBlock(.success(response))
            case let .failure(error):
                completionBlock(.failure(error))
            }
        }
    }
    
    func getUserPages(_ credentials: Credentials, completionBlock: @escaping(OperationCompletion<[String:String]>) -> ()) {
        guard let resource = AuthResourceFactory().createUserPagesResource(with: credentials) else {
            let error = Error.self
            completionBlock(.failure(error as! Error))
            return
        }
        _ = networkHelper.load(resource: resource) { result in
            switch result {
            case let .success(pages):
                let pagesResponse: usersPagesResponse = pages
                let pages: [String:String] = pagesResponse.data.reduce([String: String]()) { (dict, item) -> [String: String] in
                    var dict = dict
                    dict[item.id] = item.name
                    return dict
                }
                //credentials.fbUserId = pagesResponse.data.
                completionBlock(.success(pages))
            case let .failure(error):
                completionBlock(.failure(error))
            }
        }
    }
    
    func getPagesInstagramBusinessAccount(_ credentials: Credentials, completionBlock: @escaping(OperationCompletion<Credentials>) -> ()) {
        guard let resource = AuthResourceFactory().createPagesInstagramBusinessAccountResource(with: credentials) else {
            let error = Error.self
            completionBlock(.failure(error as! Error))
            return
        }
        _ = networkHelper.load(resource: resource) { result in
            switch result {
            case let .success(pagesIBA):
                let pagesIBA: InstBusinessAccountResponse = pagesIBA
                credentials.instUserID = pagesIBA.instagram_business_account.id
                credentials.category = pagesIBA.category
                completionBlock(.success(credentials))
            case let .failure(error):
                completionBlock(.failure(error))
            }
        }
    }
}

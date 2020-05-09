//
//  InsightsService.swift
//  IG-Statistic
//
//  Created by и on 25.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation
import ResourceNetworking

fileprivate struct ActivityResponse: Codable {
    let data: [Datum]
    let paging: PagingR
}

fileprivate struct Datum: Codable {
    let name, period: String
    let values: [Value]
    let title, description, id: String
}

fileprivate struct Value: Codable {
    let value: Int
    let end_time: String
}

fileprivate struct PagingR: Codable{
    let previous: String
    let next: String
}

fileprivate struct AudienceResponse: Codable {
    let data: [Data]
}

fileprivate struct Data: Codable {
    let name, period: String
    let values: [dataValue]
    let title, datumDescription, id: String

    enum CodingKeys: String, CodingKey {
        case name, period, values, title
        case datumDescription = "description"
        case id
    }
}

fileprivate struct dataValue: Codable {
    let value: [String: Int]
    let endTime: Date
}

fileprivate final class InsightsResourceFactory {
    func createActivityResource(with credentials: Credentials, _ beginDate: Int64, _ endDate: Int64, _ period: String) -> Resource<ActivityResponse>? {
        guard let instID = credentials.instUserID else {
            print("smt went wrong. invalid inst user id")
            return nil
        }
        guard var urlComponents = URLComponents(string: "https://graph.facebook.com/v6.0/\(instID)/insights") else {
            print("smt went wrong. invalid url components")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "until"	, value: "\(endDate)"),
            URLQueryItem(name: "since", value: "\(beginDate)"),
            URLQueryItem(name: "period", value: period),
            URLQueryItem(name: "metric", value: "impressions,reach,profile_views,follower_count"),
            URLQueryItem(name: "access_token", value: credentials.fbAccessToken)
        ]
        guard let url = urlComponents.url else {
            print("smt went wrong. invalid url")
            return nil
        }
        return Resource(url: url, headers: nil)
    }
    
    func createAudienceResource(with credentials: Credentials, _ beginDate: Int64, _ endDate: Int64) -> Resource<AudienceResponse>? {
         guard let instID = credentials.instUserID else {
             print("smt went wrong. invalid inst user id")
             return nil
         }
         guard var urlComponents = URLComponents(string: "https://graph.facebook.com/v6.0/\(instID)/insights") else {
             print("smt went wrong. invalid url components")
             return nil
         }
         urlComponents.queryItems = [
             URLQueryItem(name: "period", value: "lifetime"),
             URLQueryItem(name: "metric", value: "audience_city,audience_country ,audience_gender_age,audience_locale"),
             URLQueryItem(name: "access_token", value: credentials.fbAccessToken)
         ]
         guard let url = urlComponents.url else {
             print("smt went wrong. invalid url")
             return nil
         }
         return Resource(url: url, headers: nil)
     }
}

final class InsightsService {
    let networkHelper = NetworkHelper(reachability: FakeReachability())

    func getActivity (_ credentials: Credentials,_ beginDate: Int64, _ endDate: Int64, _ period: String ,completionBlock: @escaping(OperationCompletion<Activity>) -> ()) {
        guard let resource = InsightsResourceFactory().createActivityResource(with: credentials, beginDate, endDate, period) else {
            let error = NSError(domain: "cant get activity data", code: 1, userInfo: nil)
            completionBlock(.failure(error))
            return
        }
        _ = networkHelper.load(resource: resource) { result in
            switch result {
            case let .success(response):
                let response = response
                let impressions = response.data[0].values.map { $0.value }
                let reaches = response.data[1].values.map { $0.value }
                let postViews = response.data[2].values.map { $0.value }
                let followerCount = response.data[3].values.map { $0.value }
                let activity = Activity(impressions, reaches, postViews, followerCount, beginDate, endDate)
                completionBlock(.success(activity))
            case let .failure(error):
                completionBlock(.failure(error))
            }
        }
    }
    
    func getAudience (_ credentials: Credentials,_ beginDate: Int64, _ endDate: Int64, completionBlock: @escaping(OperationCompletion<Audience>) -> ()) {
        guard let resource = InsightsResourceFactory().createAudienceResource(with: credentials, beginDate, endDate) else {
            let error = NSError(domain: "cant get audience data", code: 1, userInfo: nil)
            completionBlock(.failure(error))
            return
        }
        _ = networkHelper.load(resource: resource) { result in
            switch result {
            case let .success(response):
                print(0)
                //completionBlock(.success(activity))
            case let .failure(error):
                completionBlock(.failure(error))
            }
        }
    }
}

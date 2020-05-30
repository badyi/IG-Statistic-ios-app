//
//  InsightsModels.swift
//  IG-Statistic
//
//  Created by и on 25.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation

enum typeInsights {
    case followsCount, impressions, reach, profileViews, locations, followersCount, gender
}

enum insightsCellType {
    case audience, activity
}

protocol InsightsListDelegate: AnyObject {
    func acivityUPD()
    func audienceUPD()
}

final class InsightsList {
    let insightsNames = ["activity", "audience"]
    private var credentials: Credentials
    private var activity: Activity? {
        didSet {
            delegate?.acivityUPD()
        }
    }
    
    private var audience: Audience? {
        didSet {
            if let count = followersCount {
                audience?.setFollowersCount(count)
                delegate?.audienceUPD()
            }
        }
    }
    
    var followersCount: Int? {
        didSet {
            if audience != nil, let count = followersCount {
                audience?.setFollowersCount(count)
                delegate?.audienceUPD()
            }
        }
    }
    
    weak var delegate: InsightsListDelegate?
    
    init(with credentials: Credentials,_ delegat: InsightsListDelegate) {
        self.credentials = credentials
        self.delegate = delegat
    }
    
    func setActivity(_ activity: Activity) {
        self.activity = activity
    }
    
    func setAudience(_ audience: Audience) {
        self.audience = audience
    }
    
    func getCredentials() -> Credentials {
        credentials
    }
    
    func getActivity() -> Activity? {
        activity
    }
    
    func getAudience() -> Audience? {
        audience
    }
    
    func setFollowersCount(_ count: Int) {
        followersCount = count
    }
}

final class Activity {
    let beginDate: Int64
    let endDate: Int64
    let impressions: [Int]
    let reaches: [Int]
    let profileViews: [Int]
    let followerCount: [Int]
    let cellsCount = 4
    
    init(_ impressions: [Int], _ reaches: [Int], _ profileViews: [Int], _ followerCount: [Int], _ beginDate: Int64, _ endDate: Int64) {
        self.impressions = impressions
        self.reaches = reaches
        self.profileViews = profileViews
        self.followerCount = followerCount
        self.beginDate = beginDate
        self.endDate = endDate
    }
}

final class Audience {
    var cities: [String: Int]
    var countries: [String: Int]
    var genderAges: [String: Int]
    var countryCodes: [String: Int]
    var followersCount: Int?
    let cellsCount = 4
    
    init(_ cities: [String: Int],_ countries: [String: Int],_ genderAges: [String: Int],_ countryCodes: [String: Int]) {
        self.cities = cities
        self.countries = countries
        self.genderAges = genderAges
        self.countryCodes = countryCodes
    }
    
    func setFollowersCount(_ count: Int) {
        followersCount = count
    }
}

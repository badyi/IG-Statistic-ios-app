//
//  InsightsModels.swift
//  IG-Statistic
//
//  Created by и on 25.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation

enum typeInsights {
    case followerCount
    case impressions
    case reach
    case profileViews
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
            delegate?.audienceUPD()
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
    //let beginDate: Int64
    //let endDate: Int64
}

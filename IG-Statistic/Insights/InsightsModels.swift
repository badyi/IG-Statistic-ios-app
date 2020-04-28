//
//  InsightsModels.swift
//  IG-Statistic
//
//  Created by и on 25.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation

final class Activity {
    let beginDate: Int64
    let endDate: Int64
    let impressions: [Int]
    let reaches: [Int]
    let profileViews: [Int]
    let followerCount: [Int]
    
    init(_ impressions: [Int], _ reaches: [Int], _ profileViews: [Int], _ followerCount: [Int], _ beginDate: Int64, _ endDate:Int64) {
        self.impressions = impressions
        self.reaches = reaches
        self.profileViews = profileViews
        self.followerCount = followerCount
        self.beginDate = beginDate
        self.endDate = endDate
    }
}

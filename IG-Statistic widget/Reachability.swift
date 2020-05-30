//
//  Reachability.swift
//  IG-Statistic widget
//
//  Created by и on 28.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//
import ResourceNetworking
import Foundation

final class FakeReachability: ReachabilityProtocol {
    var isReachable: Bool
    
    init(isReachable: Bool) {
        self.isReachable = isReachable
    }
}

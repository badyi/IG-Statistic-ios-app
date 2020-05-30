//
//  DateExtension.swift
//  IG-Statistic
//
//  Created by и on 28.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation

extension Date {
    init (seconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(seconds))
    }
    
    init(with str: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        self = formatter.date(from: str)!
    }
    
    func toSec() ->Int64! {
        return Int64(self.timeIntervalSince1970 )
    }
    
    func nDaysAgoInSec(_ n: Int) -> Int64 {
        return toSec() - 86400 * Int64(n);
    }
    
    func weekday() -> Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        return weekday
    }
    
    func getDDMMMformatStr() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        let dateStr = formatter.string(from: self)
        return dateStr
    }
}

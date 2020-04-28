//
//  InsightsPresenter.swift
//  IG-Statistic
//
//  Created by и on 25.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation

protocol InsightsViewProtocol: AnyObject {
    func insightsDidLoaded(_ activity: Activity)
    func reloadItem(at index: Int)
}
protocol InsightsPresenterProtocol {
    func getActivityInsights(_ beginDate: Int64,_ endDate: Int64, _ period: String)
}

final class InsightsPresenter: InsightsPresenterProtocol {
    weak var view: InsightsViewProtocol?
    private var insightsService: InsightsService!
    let credentials: Credentials!
    var activity: Activity?
    
    init(view: InsightsViewProtocol, credentials: Credentials) {
        self.view = view
        insightsService = InsightsService()
        self.credentials = credentials
    }
    
    func getActivityInsights(_ beginDate: Int64,_ endDate: Int64,_ period: String) {
        insightsService.getActivity(credentials, beginDate, endDate, period ) { result in
            switch (result) {
            case let .success(activity):
                DispatchQueue.main.async {                    
                    self.activity = activity
                    self.view?.insightsDidLoaded(activity)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}

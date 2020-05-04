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
    func loadActivityInsights(_ beginDate: Int64,_ endDate: Int64, _ period: String)
    func getActivityInsights() -> Activity?
    func getAudienceInsights() -> Audience?
    func getSectionNames() -> [String]
}

final class InsightsPresenter: InsightsPresenterProtocol {
    weak var view: InsightsViewProtocol?
    private var insightsService: InsightsService!
    var insights: InsightsList!
    
    init(view: InsightsViewProtocol, credentials: Credentials) {
        self.view = view
        insightsService = InsightsService()
        insights = InsightsList(with: credentials, self)
    }
    
    func loadActivityInsights(_ beginDate: Int64,_ endDate: Int64,_ period: String) {
        insightsService.getActivity(insights.getCredentials(), beginDate, endDate, period ) { [weak self] result in
            switch (result) {
            case let .success(activity):
                self?.insights.setActivity(activity)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getActivityInsights() -> Activity? {
        insights.getActivity()
    }
    
    func getAudienceInsights() -> Audience? {
        insights.getAudience()
    }
    
    func insightsCount() -> Int {
        insights.insightsNames.count
    }
    
    func getSectionNames() -> [String] {
        insights.insightsNames
    }
}

extension InsightsPresenter: InsightsListDelegate {
    func acivityUPD() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.reloadItem(at: 0)
        }
    }
    
    func audienceUPD() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.reloadItem(at: 1)
        }
    }
}

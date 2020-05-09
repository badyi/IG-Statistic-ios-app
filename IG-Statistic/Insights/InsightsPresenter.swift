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
    func cellType(at index: IndexPath) -> insightsCellType?
    func cellID(at index: IndexPath) -> String
}

final class InsightsPresenter: InsightsPresenterProtocol {
    weak var view: InsightsViewProtocol?
    private var insightsService: InsightsService!
    var insights: InsightsList!
    var cellIDs = ["activityCellId", "audienceCellId"]
    
    init(view: InsightsViewProtocol, credentials: Credentials) {
        self.view = view
        insightsService = InsightsService()
        insights = InsightsList(with: credentials, self)
    }
    
    func loadActivityInsights(_ beginDate: Int64,_ endDate: Int64,_ period: String) {
        insightsService.getActivity(insights.getCredentials(), beginDate, endDate, period) { [weak self] result in
            switch (result) {
            case let .success(activity):
                self?.insights.setActivity(activity)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func loadAudienceInsights(_ beginDate: Int64,_ endDate: Int64) {
        insightsService.getAudience(insights.getCredentials(), beginDate, endDate) { [weak self] result in
//switch (result) {
  //          case let .success(audience):
                //sefl?.insights.
    //        }
            
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
    
    func cellID(at index: IndexPath) -> String {
        switch index.row {
        case 0:
            return cellIDs[0]
        case 1:
            return cellIDs[1]
        default:
            return "cellId"
        }
    }
    
    func cellType(at index: IndexPath) -> insightsCellType? {
        switch index.row {
        case 0:
            return .activity
        case 1:
            return .audience
        default:
            return nil
        }
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




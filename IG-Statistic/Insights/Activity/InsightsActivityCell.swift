//
//  IsightsActivityCell.swift
//  IG-Statistic
//
//  Created by и on 25.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit
import Charts

class InsightsActivityCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var descriptionLabel1: UILabel!
    @IBOutlet weak var graphic: BarChartView!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var descriptionLabel2: UILabel!
    var beginDate: Int64?
    var endDate: Int64?
    
    var graphData: [Int]?
    var days = ["mon", "tues", "wed", "thurs","fri","sat","sun"]
    var insightsType: typeInsights?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        let backgroundColor = ThemeManager.currentTheme().backgroundColor
        let titleTextColor = ThemeManager.currentTheme().titleTextColor
        backView.backgroundColor = backgroundColor
        typeLabel.textColor = titleTextColor
        countLabel.textColor = titleTextColor
        descriptionLabel1.textColor = UIColor.systemGray
        graphic.backgroundColor = backgroundColor
        averageLabel.textColor = titleTextColor
        descriptionLabel2.textColor = titleTextColor
        graphic.tintColor = .green
        graphic.xAxis.labelTextColor = titleTextColor
        configViewOfChart()
    }
    
    func config(type: typeInsights, data: [Int], beginDate: Int64, endDate: Int64) {
        insightsType = type
        self.beginDate = beginDate
        self.endDate = endDate
        switch insightsType {
        case .followsCount:
            configFC(data)
        case .profileViews:
            configPV(data)
        case .impressions:
            configImps(data)
        case .reach:
            configReach(data)
        default:
            print("unsupported type")
        }
        customizeChart(dataPoints: days, values: data.map { Double($0)})
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries)
        chartDataSet.colors = [ThemeManager.currentTheme().barsColor.withAlphaComponent(0.8)]
        chartDataSet.valueTextColor = ThemeManager.currentTheme().titleTextColor
        let chartData = BarChartData(dataSet: chartDataSet)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
        graphic.xAxis.valueFormatter = IndexAxisValueFormatter(values: days) ; #warning("fix weekday")
        graphic.data = chartData
    }
    
    func configViewOfChart() {
        graphic.backgroundColor = ThemeManager.currentTheme().backgroundColor
        graphic.xAxis.drawAxisLineEnabled = false
        graphic.xAxis.drawGridLinesEnabled = false
        graphic.leftAxis.drawGridLinesEnabled = false
        graphic.leftAxis.drawAxisLineEnabled = false
        graphic.leftAxis.drawLabelsEnabled = false
        graphic.rightAxis.drawGridLinesEnabled = false
        graphic.rightAxis.drawAxisLineEnabled = false
        graphic.rightAxis.drawLabelsEnabled = false
        graphic.xAxis.labelPosition = XAxis.LabelPosition.bottom
        graphic.legend.enabled = false
        graphic.isUserInteractionEnabled = false
        graphic.rightAxis.axisMinimum = 0.0
        graphic.leftAxis.axisMinimum = 0.0
    }
    
    func configFC(_ data: [Int]) {
        typeLabel.text = "Follower Count"
        let sum = data.reduce(0, +)
        countLabel.text = "\(sum)"
        let bDate = Date(seconds: beginDate!).getDDMMMformatStr()
        let eDate = Date(seconds: endDate!).getDDMMMformatStr()
        
        descriptionLabel1.text = "Accounts following profile from \(bDate) - \(eDate)"
        descriptionLabel2.text = "Average"
        averageLabel.text = String(format:"%.2f", Float(sum)/Float(7))
    }
    
    func configPV(_ data: [Int]) {
        typeLabel.text = "Profile Views"
        let sum = data.reduce(0, +)
        countLabel.text = "\(sum)"
        let bDate = Date(seconds: beginDate!).getDDMMMformatStr()
        let eDate = Date(seconds: endDate!).getDDMMMformatStr()
        
        descriptionLabel1.text = "Users who have viewed profile from \(bDate) - \(eDate)"
        descriptionLabel2.text = "Average"
        averageLabel.text = String(format:"%.2f", Float(sum)/Float(7))
    }
    
    func configImps(_ data: [Int]) {
        typeLabel.text = "Impressions"
        let sum = data.reduce(0, +)
        countLabel.text = "\(sum)"
        let bDate = Date(seconds: beginDate!).getDDMMMformatStr()
        let eDate = Date(seconds: endDate!).getDDMMMformatStr()
        
        descriptionLabel1.text = "The total number of times that all of your posts have been seen from \(bDate) - \(eDate)"
        descriptionLabel2.text = "Average"
        averageLabel.text = String(format:"%.2f", Float(sum)/Float(7))
    }
    
    func configReach(_ data: [Int]) {
        typeLabel.text = "Reach"
        let sum = data.reduce(0, +)
        countLabel.text = "\(sum)"
        let bDate = Date(seconds: beginDate!).getDDMMMformatStr()
        let eDate = Date(seconds: endDate!).getDDMMMformatStr()
        
        descriptionLabel1.text = "The total number of unique accounts that have seen any of your posts from \(bDate) - \(eDate)"
        descriptionLabel2.text = "Average"
        averageLabel.text = String(format:"%.2f", Float(sum)/Float(7))
    }
}

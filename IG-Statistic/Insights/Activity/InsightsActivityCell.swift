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
    
    var graphData: [Int]?
    var days = ["mon", "tues", "wed", "thurs","fri","sat","sun"]
    
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
        descriptionLabel1.textColor = titleTextColor
        graphic.backgroundColor = backgroundColor
        averageLabel.textColor = titleTextColor
        descriptionLabel2.textColor = titleTextColor
        graphic.tintColor = .green
        graphic.xAxis.labelTextColor = titleTextColor
    }
    
    func config(type: String, data: [Int], beginDate: Int64, endDate: Int64) {
        configViewOfChart()
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
        graphic.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        graphic.data = chartData
    }
    
    func configViewOfChart() {
        graphic.xAxis.drawAxisLineEnabled = false
        graphic.xAxis.drawGridLinesEnabled = false
        graphic.leftAxis.drawGridLinesEnabled = false
        graphic.leftAxis.drawAxisLineEnabled = false
        graphic.leftAxis.drawLabelsEnabled = false
        graphic.rightAxis.drawGridLinesEnabled = false
        graphic.rightAxis.drawAxisLineEnabled = false
        graphic.rightAxis.drawLabelsEnabled = false
        graphic.xAxis.labelPosition = XAxis.LabelPosition.bottomInside
        graphic.legend.enabled = false
        
        graphic.isUserInteractionEnabled = false
    }
}

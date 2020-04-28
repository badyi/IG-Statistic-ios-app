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
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var descriptionLabel1: UILabel!
    @IBOutlet weak var graphic: BarChartView!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var descriptionLabel2: UILabel!
    
    var graphData: [Int]?
    var days = ["Mon", "Tues", "Wed", "Thurs","Fri","Sat","Sun"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(type: String, data: [Int], beginDate: Int64, endDate: Int64) {
        customizeChart(dataPoints: days, values: data.map { Double($0)})
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries)
        let chartData = BarChartData(dataSet: chartDataSet)
        
        graphic.data = chartData
    }
}

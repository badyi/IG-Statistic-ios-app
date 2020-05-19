//
//  AudienceHorizontalChartTableViewCell.swift
//  IG-Statistic
//
//  Created by и on 10.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit
import Charts

protocol cellDelegate: AnyObject {
    func showAlert(_ description: String)
}

class AudienceHorizontalChartViewCell: UICollectionViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var horizontalChart: HorizontalBarChartView!
    
    weak var delegate: cellDelegate?
    var show = showInfo.first
    var dataForChart1: [String: Int] = [:]
    var dataForChart2: [String: Int] = [:]
    var count = 0
    
    var type: typeInsights? {
        didSet {
            switch type {
            case .locations:
                descriptionLabel.text = "Locations"
            default:
                descriptionLabel.text = "None"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        configViewOfChart()
    }
    
    @IBAction func button1Tapped(_ sender: Any) {
        buttonLeft.tintColor = ThemeManager.currentTheme().buttonSelectedColor
        buttonRight.tintColor = ThemeManager.currentTheme().buttonColor
        if dataForChart1.count > 0 {
            configChart(dataForChart1)
        }
    }
    
    @IBAction func button2Tapped(_ sender: Any) {
        buttonRight.tintColor = ThemeManager.currentTheme().buttonSelectedColor
        buttonLeft.tintColor = ThemeManager.currentTheme().buttonColor
        if dataForChart2.count > 0 {
            configChart(dataForChart2)
        }
    }
    
    @IBAction func info(_ sender: Any) {
        switch type {
        case .locations:
            delegate?.showAlert("The places where your followers are concentrated")
        default:
            print("wrong type")
        }
    }
    
    func setupView() {
        let backgroundColor = ThemeManager.currentTheme().backgroundColor
        let titleColor = ThemeManager.currentTheme().titleTextColor
        descriptionLabel.textColor = titleColor
        self.backgroundColor = backgroundColor
        infoButton.backgroundColor = backgroundColor
        infoButton.tintColor = ThemeManager.currentTheme().buttonColor
        buttonLeft.tintColor = ThemeManager.currentTheme().buttonSelectedColor
        buttonRight.tintColor = ThemeManager.currentTheme().buttonColor
        buttonLeft.setTitle("Cities", for: .normal)
        buttonRight.setTitle("Contries", for: .normal)
    }
    
    func configViewOfChart() {
        horizontalChart.backgroundColor = ThemeManager.currentTheme().backgroundColor
        horizontalChart.xAxis.granularity = 1.0
        horizontalChart.rightAxis.granularity = 1.0
        horizontalChart.xAxis.drawAxisLineEnabled = false
        horizontalChart.xAxis.drawGridLinesEnabled = false
        horizontalChart.leftAxis.drawGridLinesEnabled = false
        horizontalChart.leftAxis.drawAxisLineEnabled = false
        horizontalChart.leftAxis.drawLabelsEnabled = false
        horizontalChart.rightAxis.drawGridLinesEnabled = false
        horizontalChart.rightAxis.drawAxisLineEnabled = false
        horizontalChart.rightAxis.drawLabelsEnabled = false
        horizontalChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        horizontalChart.xAxis.labelTextColor = 	ThemeManager.currentTheme().titleTextColor
        horizontalChart.legend.enabled = false
        horizontalChart.isUserInteractionEnabled = false
        horizontalChart.rightAxis.axisMinimum = 0.0
        horizontalChart.leftAxis.axisMinimum = 0.0
    }
    
    func configChartData(_ type: typeInsights,_ data1: [String: Int],_ data2: [String: Int]) {
        dataForChart1 = data1
        dataForChart2 = data2
        self.type = type
        switch show {
        case .first:
            configChart(data1)
        case .second:
            configChart(data2)
        }
    }
    
    func configChart(_ data: [String: Int]) {
        let dict = data.sorted(by: { $0.value > $1.value })
        let first5 = dict.prefix(5).sorted(by: { $0.value < $1.value })
        let barNames: [String] = first5.map { String($0.key.split(separator: ",")[0]) }
        let count = data.map { $0.value }.reduce(0,+)
        let values = first5.map { Double($0.value) /  Double(Double(count)/Double(100)) }
        customizeChart(dataPoints: barNames, values: values)
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        let chartDataSet = BarChartDataSet(entries: dataEntries)
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
        chartDataSet.colors = [ThemeManager.currentTheme().barsColor.withAlphaComponent(0.8)]
        chartDataSet.valueTextColor = ThemeManager.currentTheme().titleTextColor
        let chartData = BarChartData(dataSet: chartDataSet)
        horizontalChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints);
        horizontalChart.data = chartData
    }
}

enum showInfo {
    case first, second
}

//
//  AudienceGenderCollectionViewCell.swift
//  IG-Statistic
//
//  Created by и on 19.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit
import Charts

class AudienceAgeRangeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var buttonCenter: UIButton!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var horizontalChart: HorizontalBarChartView!
    
    weak var delegate: cellDelegate?
    fileprivate var show = showInfo.first
    var all: [(key: String, value: Int)] = []
    var male: [(key: String, value: Int)] = []
    var female: [(key: String, value: Int)] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    @IBAction func firstButtonTapped(_ sender: Any) {
        buttonLeft.tintColor = ThemeManager.currentTheme().buttonSelectedColor
        buttonCenter.tintColor = ThemeManager.currentTheme().buttonColor
        buttonRight.tintColor = ThemeManager.currentTheme().buttonColor
        if all.count > 0 {
            customizeChart(dataPoints: all.map { $0.key }, values: all.map { Double($0.value) })
        }
    }
    
    @IBAction func secondButtonTapped(_ sender: Any) {
        buttonLeft.tintColor = ThemeManager.currentTheme().buttonColor
        buttonCenter.tintColor = ThemeManager.currentTheme().buttonSelectedColor
        buttonRight.tintColor = ThemeManager.currentTheme().buttonColor
        if male.count > 0 {
            customizeChart(dataPoints: self.male.map { $0.key }, values: self.male.map { Double($0.value) })
        }
    }
    
    @IBAction func thirdButtonTapped(_ sender: Any) {
        buttonLeft.tintColor = ThemeManager.currentTheme().buttonColor
        buttonCenter.tintColor = ThemeManager.currentTheme().buttonColor
        buttonRight.tintColor = ThemeManager.currentTheme().buttonSelectedColor
        if female.count > 0 {
            customizeChart(dataPoints: self.female.map { $0.key }, values: self.female.map { Double($0.value) })
        }
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        delegate?.showAlert("Age","The age distribution of your followers")
    }
    
    func setupView() {
        let backgroundColor = ThemeManager.currentTheme().backgroundColor
        let titleColor = ThemeManager.currentTheme().titleTextColor
        descriptionLabel.textColor = titleColor
        self.backgroundColor = backgroundColor
        view.backgroundColor = backgroundColor
        infoButton.backgroundColor = backgroundColor
        infoButton.tintColor = ThemeManager.currentTheme().buttonColor
        buttonLeft.tintColor = ThemeManager.currentTheme().buttonSelectedColor
        buttonCenter.tintColor = ThemeManager.currentTheme().buttonColor
        buttonRight.tintColor = ThemeManager.currentTheme().buttonColor
        buttonLeft.setTitle("All", for: .normal)
        buttonCenter.setTitle("Male", for: .normal)
        buttonRight.setTitle("Female", for: .normal)
        descriptionLabel.text = "Age range"
        configViewOfChart()
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
        horizontalChart.xAxis.labelTextColor =     ThemeManager.currentTheme().titleTextColor
        horizontalChart.legend.enabled = false
        horizontalChart.isUserInteractionEnabled = false
        horizontalChart.rightAxis.axisMinimum = 0.0
        horizontalChart.leftAxis.axisMinimum = 0.0
    }
    
    func configChartData(_ data: [String: Int]) {
        male = []
        female = []
        all = []
        let male: [String:Int] = (data.filter { $0.key.prefix(1) == "M" })
        self.male = male.sorted(by: {$0.key > $1.key})
        for i in 0..<self.male.count {
            self.male[i].key = String(self.male[i].key.dropFirst(2))
        }
        
        let female = (data.filter { $0.key.prefix(1) == "F" })
        self.female = female.sorted(by: {$0.key > $1.key})
        
        for i in 0..<self.female.count {
            self.female[i].key = String(self.female[i].key.dropFirst(2))
        }
        
        for i in 0..<self.male.count {
            all.append((key: String(self.male[i].key),value: self.male[i].value + self.female[i].value))
        }
        
        switch show {
        case .first:
            customizeChart(dataPoints: all.map { $0.key }, values: all.map { Double($0.value) })
        case .second:
            customizeChart(dataPoints: self.male.map { $0.key }, values: self.male.map { Double($0.value) })
        case .third:
            customizeChart(dataPoints: self.female.map { $0.key }, values: self.female.map { Double($0.value) })
        }
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
        let count = values.reduce(0, +)
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i])/(Double(count)/Double(100)))
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

fileprivate enum showInfo {
    case first,second,third
}

//
//  AudienceGenderCollectionViewCell.swift
//  IG-Statistic
//
//  Created by и on 19.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit
import Charts

class AudienceGenderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var view: UIView!
    weak var delegate: cellDelegate?
    @IBOutlet weak var menPercentageLabel: UILabel!
    @IBOutlet weak var menLabel: UILabel!
    @IBOutlet weak var womenPercentageLabel: UILabel!
    @IBOutlet weak var womenLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    @IBAction func infoButtonTapped(_ sender: Any) {
        delegate?.showAlert("Gender","The gender distribution of your followers")
    }
    
    func setupView() {
        let backgroundColor = ThemeManager.currentTheme().backgroundColor
        let titleColor = ThemeManager.currentTheme().titleTextColor
        descriptionLabel.textColor = titleColor
        self.backgroundColor = backgroundColor
        view.backgroundColor = backgroundColor
        infoButton.backgroundColor = backgroundColor
        infoButton.tintColor = ThemeManager.currentTheme().buttonColor
        descriptionLabel.text = "Gender"
        pieChart.highlightPerTapEnabled = false
        pieChart.usePercentValuesEnabled = false
        pieChart.drawEntryLabelsEnabled = false
        pieChart.legend.enabled = false
        pieChart.holeColor = UIColor.clear
    }
    
    func configChartData(_ data: [String: Int]) {
        let male: [String:Int] = (data.filter { $0.key.prefix(1) == "M" })
        let female = (data.filter { $0.key.prefix(1) == "F" })
        let count = (data.map { $0.value }).reduce(0,+)
        let maleCount: Int = (male.map { $0.value }).reduce(0,+)
        let femaleCount: Int = (female.map { $0.value }).reduce(0,+)
        let malePercentage = Double(maleCount)/(Double(count)/Double(100))
        let femalePercentage = Double(femaleCount)/(Double(count)/Double(100))
        customizeChart(dataPoints: ["Men", "Women"], values: [femalePercentage, malePercentage])
        menPercentageLabel.text = String(format:"%.2f", malePercentage)
        womenPercentageLabel.text = String(format:"%.2f", femalePercentage)
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
        let menColor = ThemeManager.currentTheme().systemBlue
        let womenColor = ThemeManager.currentTheme().lightCoral
        menPercentageLabel.textColor = menColor
        womenPercentageLabel.textColor = womenColor
        menLabel.textColor = menColor
        womenLabel.textColor = womenColor
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = [womenColor, menColor]
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartData.setValueTextColor(NSUIColor.clear)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        pieChartDataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
        pieChart.data = pieChartData
    }
}

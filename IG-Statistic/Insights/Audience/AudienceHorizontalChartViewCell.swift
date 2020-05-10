//
//  AudienceHorizontalChartTableViewCell.swift
//  IG-Statistic
//
//  Created by и on 10.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit
import Charts

class AudienceHorizontalChartViewCell: UICollectionViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var horizontalChart: HorizontalBarChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        configViewOfChart()
    }
    
    func setupView() {
        isSelected = true
        layer.borderWidth = 1
        layer.borderColor = ThemeManager.currentTheme().collectionCellBorderColor.cgColor
        let backgroundColor = ThemeManager.currentTheme().backgroundColor
        let titleColor = ThemeManager.currentTheme().titleTextColor
        descriptionLabel.textColor = titleColor
        self.backgroundColor = backgroundColor
        infoButton.backgroundColor = backgroundColor
        infoButton.tintColor = ThemeManager.currentTheme().buttonColor
        buttonLeft.tintColor = ThemeManager.currentTheme().buttonSelectedColor
        buttonRight.tintColor = ThemeManager.currentTheme().buttonColor
    }
    
    func configViewOfChart() {
        horizontalChart.backgroundColor = ThemeManager.currentTheme().backgroundColor
        horizontalChart.xAxis.drawAxisLineEnabled = false
        horizontalChart.xAxis.drawGridLinesEnabled = false
        horizontalChart.leftAxis.drawGridLinesEnabled = false
        horizontalChart.leftAxis.drawAxisLineEnabled = false
        horizontalChart.leftAxis.drawLabelsEnabled = false
        horizontalChart.rightAxis.drawGridLinesEnabled = false
        horizontalChart.rightAxis.drawAxisLineEnabled = false
        horizontalChart.rightAxis.drawLabelsEnabled = false
        horizontalChart.xAxis.labelPosition = XAxis.LabelPosition.bottomInside
        horizontalChart.legend.enabled = false
        horizontalChart.isUserInteractionEnabled = false
    }
    
    func config(type: typeInsights) {
        
    }
}

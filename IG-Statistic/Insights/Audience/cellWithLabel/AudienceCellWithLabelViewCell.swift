//
//  AudienceCellWithLabelTableViewCell.swift
//  IG-Statistic
//
//  Created by и on 10.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

class AudienceCellWithLabelViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.label.textColor = ThemeManager.currentTheme().titleTextColor
    }
    
    func config(_ str: String, _ fontSize: Int) {
        label.text = str
        label.font = label.font.withSize(CGFloat(fontSize))
    }
}

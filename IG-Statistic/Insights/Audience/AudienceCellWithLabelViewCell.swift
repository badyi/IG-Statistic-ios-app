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
        layer.borderWidth = 1
        layer.borderColor = ThemeManager.currentTheme().collectionCellBorderColor.cgColor
        self.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.label.textColor = ThemeManager.currentTheme().titleTextColor
    }
    
    func config(_ str: String) {
        label.text = str
    }
}

//
//  SettingsTableViewCell.swift
//  IG-Statistic
//
//  Created by и on 05.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        super.setSelected(false, animated: true)
    }
    
    func config(with title: String) {
        label.text = title
    }
    
    func setupView() {
        self.icon.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.label.textColor = ThemeManager.currentTheme().titleTextColor
    }
}

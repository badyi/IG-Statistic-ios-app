//
//  InfoTableViewCell.swift
//  IG-Statistic
//
//  Created by и on 16.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descr: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupView() {
        let titleColor = ThemeManager.currentTheme().titleTextColor
        let backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.backgroundColor = backgroundColor
        name.textColor = titleColor
        descr.textColor = titleColor
    }
    
    func config(with name: String,_ descr: String?) {
        self.name.text = name
        if descr == nil {
            self.descr.text = ""
            return
        }
        self.descr.text = descr
    }
}

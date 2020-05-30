//
//  InfoHeaderView.swift
//  IG-Statistic
//
//  Created by и on 16.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit


class InfoHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var prfoilePicture: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var backView: UIView!
    
    func setupView() {
        let titleColor = ThemeManager.currentTheme().titleTextColor
        let backgroundColor = ThemeManager.currentTheme().backgroundColor
        let tintColor = ThemeManager.currentTheme().tintColor
        label.textColor = titleColor
        backView.backgroundColor = backgroundColor
        backView.tintColor = tintColor
        backView.alpha = 0.75
    }
    
    func setImage(with img: UIImage?) {
        prfoilePicture.image = img
        prfoilePicture.layer.cornerRadius = self.prfoilePicture.frame.width / 2
        prfoilePicture.clipsToBounds = true
    }
    
    func setNickname(with nickname: String) {
        self.label.text = nickname
    }
}

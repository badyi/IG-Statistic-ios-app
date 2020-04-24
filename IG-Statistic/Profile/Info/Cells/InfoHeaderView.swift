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
    
    func setImage(with img: UIImage?) {
        prfoilePicture.image = img
        prfoilePicture.layer.cornerRadius = self.prfoilePicture.frame.width / 2
        prfoilePicture.clipsToBounds = true
    }
    
    func setNickname(with nickname: String) {
        self.label.text = nickname
    }
}

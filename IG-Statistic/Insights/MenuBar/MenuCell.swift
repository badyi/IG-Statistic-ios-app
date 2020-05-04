//
//  MenuCell.swift
//  IG-Statistic
//
//  Created by и on 01.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
        return iv
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? ThemeManager.currentTheme().menuBarHighlightColor : ThemeManager.currentTheme().menuBarTintColor
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? ThemeManager.currentTheme().menuBarHighlightColor : ThemeManager.currentTheme().menuBarTintColor
        }
    }
    
    func setupViews() {
        addSubview(imageView)
        addConstraintsWithFormat("H:[v0(26)]", views: imageView)
        addConstraintsWithFormat("V:[v0(26)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}

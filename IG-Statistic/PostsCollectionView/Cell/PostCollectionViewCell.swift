//
//  PostCollectionViewCell.swift
//  IG-Statistic
//
//  Created by Бадый Шагаалан on 29.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var insightsView: UIView!
    @IBOutlet weak var viewsCount: UILabel!
    @IBOutlet weak var viewsImage: UIImageView!
    @IBOutlet weak var uniqueAccountsCount: UILabel!
    @IBOutlet weak var uaccountsImage: UIImageView!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var likesImage: UIImageView!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var commentsImage: UIImageView!
    @IBOutlet weak var bookmarksCount: UILabel!
    @IBOutlet weak var savedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        insightsView.isHidden = true
        insightsView.layer.cornerRadius = 7
        setColors()
        insightsView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        let secondColor = ThemeManager.currentTheme().secondaryColor
        image.backgroundColor = ThemeManager.currentTheme().backgroundColor
        viewsCount.textColor = secondColor
        viewsImage.tintColor = secondColor
        uniqueAccountsCount.textColor = secondColor
        uaccountsImage.tintColor = secondColor
        likesCount.textColor = secondColor
        likesImage.tintColor = secondColor
        commentsCount.textColor = secondColor
        commentsImage.tintColor = secondColor
        bookmarksCount.textColor = secondColor
        savedImage.tintColor = secondColor
    }
    
    func configure(with postV: PostView, _ flag: Bool) {
        guard let _ = postV.image  else {
            return
        }
        image.image = postV.image
        if  flag == true {
            insightsView.isHidden = false
            likesCount.text = String(postV.likesCount!)
            commentsCount.text = String(postV.commentesCount!)
            if let insights = postV.insights {
                if insights.enable == true {
                    viewsCount.isHidden = false
                    uniqueAccountsCount.isHidden = false
                    bookmarksCount.isHidden = false
                    viewsCount.text = String(insights.impressions)
                    uniqueAccountsCount.text = String(insights.reach)
                    bookmarksCount.text = String(insights.saved)
                } else {
                    viewsCount.isHidden = true
                    uniqueAccountsCount.isHidden = true
                    bookmarksCount.isHidden = true
                }
            }
        }
        else {
            insightsView.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        image.image = nil
    }
    
    func setColors() {
        insightsView.tintColor = UIColor(hexString: "FF6347")
        
    }
}

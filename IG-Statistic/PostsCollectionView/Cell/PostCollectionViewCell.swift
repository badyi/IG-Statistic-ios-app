//
//  PostCollectionViewCell.swift
//  IG-Statistic
//
//  Created by Бадый Шагаалан on 29.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iamge: UIImageView!
    @IBOutlet weak var insightsView: UIView!
    @IBOutlet weak var viewsCount: UILabel!
    
    @IBOutlet weak var uniqueAccountsCount: UILabel!
    
    @IBOutlet weak var likesCount: UILabel!
    
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var bookmarksCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        insightsView.isHidden = true
        insightsView.layer.cornerRadius = 7
    }
    
    func configure(with postV: PostView, _ flag: Bool) {
        iamge.image = postV.image
        if  flag == true {
            insightsView.isHidden = false
            if let insights = postV.insights {
                viewsCount.text = String(insights.impressions)
                uniqueAccountsCount.text = String(insights.reach)
                likesCount.text = String(postV.likesCount!)
                commentsCount.text = String(postV.commentesCount!)
                bookmarksCount.text = String(insights.saved)
            }
        }
        else {
            insightsView.isHidden = true
        }
    }
}

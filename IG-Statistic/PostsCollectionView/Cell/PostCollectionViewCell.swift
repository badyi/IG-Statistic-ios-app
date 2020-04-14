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
        guard let imge = postV.image  else {
            return
        }
        iamge.image = postV.image
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
        iamge.image = nil
    }
}

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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var indicator = UIActivityIndicatorView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with postV: PostView) {
        iamge.image = postV.image
    }
}

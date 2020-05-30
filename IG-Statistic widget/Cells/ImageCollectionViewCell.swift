//
//  ImageCollectionViewCell.swift
//  IG-Statistic widget
//
//  Created by и on 28.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        backgroundColor = UIColor.clear
    }

    func setImage(_ img: UIImage?) {
        image.image = img;
        image.layer.cornerRadius = 10//image.frame.size.width / 2
        image.clipsToBounds = true
        activity.stopAnimating()
    }
}

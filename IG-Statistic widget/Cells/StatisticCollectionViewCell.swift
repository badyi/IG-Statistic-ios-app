//
//  StatisticCollectionViewCell.swift
//  IG-Statistic widget
//
//  Created by и on 28.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

final class StatisticCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var descripitionLabel: UILabel!
    @IBOutlet weak var bView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        bView.backgroundColor = UIColor.clear
        //bView.layer.cornerRadius = bView.frame.size.width / 2
        //bView.clipsToBounds = true
        //backgroundColor = UIColor.clear
    }
    
    func config(_ stat: Int?, _ descr: String) {
        guard let statNum = stat else {
            return
        }
        count.text = "\(statNum)"
        descripitionLabel.text = descr
    }
}

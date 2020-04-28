//
//  ActivityViewCell.swift
//  IG-Statistic
//
//  Created by и on 25.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

class ActivityCollectionViewCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    var activity: Activity?

    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .brown
        
        collectionView.contentInset = .init(top: 100, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = .init(top: 50, left: 0, bottom: 0, right: 0)
        
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
        collectionView.register(UINib(nibName: "InsightsActivityCell", bundle: nil), forCellWithReuseIdentifier: cellId)
    }
    
    func config(with activity: Activity?) {
        self.activity = activity
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InsightsActivityCell
        cell.backgroundColor = UIColor.purple

        switch indexPath.row {
        case 0:
            guard let ac = activity else { break }
            cell.config(type: "follows count", data: ac.followerCount, beginDate: ac.beginDate, endDate: ac.endDate)
        default:
            break
        }
        if indexPath.row == 4 {
            cell.isHidden = true
        }
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = (frame.width ) * 9 / 16
        if indexPath.row == 4 {
            return .init(width: frame.width, height: 125)
        }
        return .init(width: frame.width, height: height + 16 + 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}


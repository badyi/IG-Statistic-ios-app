//
//  ActivityViewCell.swift
//  IG-Statistic
//
//  Created by и on 25.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

class ActivityCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func setupViews() {
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
        guard let ac = activity else { return 0 }
        return ac.cellsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InsightsActivityCell
        cell.backgroundColor = UIColor.purple
        guard let ac = activity else { return cell }
        switch indexPath.row {
        case 0:
            cell.config(type: .followerCount, data: ac.followerCount, beginDate: ac.beginDate, endDate: ac.endDate)
        case 1:
            cell.config(type: .profileViews, data: ac.profileViews, beginDate: ac.beginDate, endDate: ac.endDate)
        case 2:
            cell.config(type: .impressions, data: ac.impressions, beginDate: ac.beginDate, endDate: ac.endDate)
        case 3:
            cell.config(type: .reach, data: ac.reaches, beginDate: ac.beginDate, endDate: ac.endDate)
        default:
            break
        }
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (frame.width ) * 9 / 16 + 120
        if indexPath.row == 4 {
            return .init(width: frame.width, height: 125)
        }
        return .init(width: frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}


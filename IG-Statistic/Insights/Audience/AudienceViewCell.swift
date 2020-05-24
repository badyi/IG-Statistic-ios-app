//
//  AudienceViewCell.swift
//  IG-Statistic
//
//  Created by и on 08.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

class AudienceCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    weak var delegate: cellDelegate?
    
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
        cv.backgroundColor = ThemeManager.currentTheme().backgroundColor
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    let cellIdHorizontal = "AudienceHorizontalChartCollectionViewCell"
    let cellIdLabel = "AudienceCellWithLabelCollectionViewCell"
    let cellAgeRangeID = "AudienceAgeRangeCollectionViewCel"
    let cellGenderID = "AudienceGenderCollectionViewCell"
    var audience: Audience?
    
    func setupViews() {
        backgroundColor = ThemeManager.currentTheme().backgroundColor
        collectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        collectionView.contentInset = .init(top: 100, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = .init(top: 50, left: 0, bottom: 0, right: 0)
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
        collectionView.register(UINib(nibName: "InsightsActivityCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        collectionView.register(UINib(nibName: "AudienceHorizontalChartViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdHorizontal)
        collectionView.register(UINib(nibName: "AudienceCellWithLabelViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdLabel)
        collectionView.register(UINib(nibName: "AudienceAgeRangeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellAgeRangeID)
        collectionView.register(UINib(nibName: "AudienceGenderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellGenderID)
    }
    
    func config(with audience: Audience?) {
        self.audience = audience
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let audience = audience else { return 1 }
        return audience.cellsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InsightsActivityCell
        cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
        guard let audience = audience, let fCount = audience.followersCount else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdLabel, for: indexPath) as! AudienceCellWithLabelViewCell
            cell.config("You can learn more about who's following you when you have at least 100 followers",14)
            return cell
        }
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdLabel, for: indexPath) as! AudienceCellWithLabelViewCell
            cell.config("\(String(describing: fCount)) followers", 25)
            cell.setupView()
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdHorizontal, for: indexPath) as! AudienceHorizontalChartViewCell
            cell.configChartData(.locations, audience.cities, audience.countries)
            cell.delegate = self
            cell.setupView()
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellAgeRangeID, for: indexPath) as! AudienceAgeRangeCollectionViewCell
            cell.configChartData(audience.genderAges)
            cell.delegate = self
            cell.setupView()
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellGenderID, for: indexPath) as! AudienceGenderCollectionViewCell
            cell.configChartData(audience.genderAges)
            cell.setupView()
            cell.delegate = self
            return cell
        default:
            break
        } 
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = (frame.width ) * 9 / 16 + 120
        if indexPath.row == 0 {
            height /= 4;
        }
        return .init(width: frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension AudienceCollectionViewCell: cellDelegate {
    func showAlert(_ title: String,_ description: String) {
        delegate?.showAlert(title, description)
    }
}


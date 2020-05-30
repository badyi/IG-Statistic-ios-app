//
//  TodayViewController.swift
//  IG-Statistic widget
//
//  Created by и on 27.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit
import NotificationCenter

final class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var collectionView: UICollectionView!
    var presenter: TodayVCPresenter!
    let cellID = "CellID"
    let cellImgID = "CellIDImg"
    let statCellID = "StatCellID"
    
    override func viewWillAppear(_ animated: Bool) {
        if presenter == nil {
            setupPresenter()
        }
        presenter.getMainProfileInfo()
    }
    
    func setupPresenter() {
        super.viewDidLoad()
        let defaults = UserDefaults(suiteName: "group.badyi7.IGStatisticApp")
        if let id = defaults?.value(forKey: "instID") as? String, let token = defaults?.value(forKey: "FBtoken") as? String {
            presenter = TodayVCPresenter(Credentials(id, token), self)
            presenter.getMainProfileInfo()
        }
    }
    
    override func viewDidLoad() {
        if presenter == nil {
            setupPresenter()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView!.register(UINib.init(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellImgID)
        collectionView!.register(UINib.init(nibName: "StatisticCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: statCellID)
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
        
    @IBAction func update(_ sender: Any) {
        if presenter == nil {
            setupPresenter()
        }
        presenter.getMainProfileInfo()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 75)
        } else if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 200)
        }
    }
}

extension TodayViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let _ = presenter else {
            return 0
        }
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) 
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellImgID, for: indexPath) as! ImageCollectionViewCell
            cell.setImage(presenter.getImage())
            return cell
        case 1...3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: statCellID, for: indexPath) as! StatisticCollectionViewCell
            if indexPath.row == 1 {
                cell.config(presenter?.model.profile?.postsCount, "Posts")
            } else if indexPath.row == 2 {
                cell.config(presenter?.model.profile?.followersCount, "Followers count")
            } else if indexPath.row == 3 {
                cell.config(presenter?.model.profile?.followingsCount, "Following")
            }
            return cell
        default:
            return cell
        }
    }
}

extension TodayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 4) / 4
        return CGSize(width: width, height: width)
    }
}

extension TodayViewController: TodayVCPdelegate {
    func reloadAt(index: Int) {
        collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
}

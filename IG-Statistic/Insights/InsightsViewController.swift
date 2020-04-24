//
//  InsightsViewController.swift
//  IG-Statistic
//
//  Created by и on 24.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

class InsightsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
        let cellId = "cellId"
    
        private func setupMenuBar() {
            navigationController?.hidesBarsOnSwipe = true
            
            let redView = UIView()
            redView.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
            view.addSubview(redView)
            view.addConstraintsWithFormat("H:|[v0]|", views: redView)
            view.addConstraintsWithFormat("V:[v0(50)]", views: redView)
            
            view.addSubview(menuBar)
            view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
            view.addConstraintsWithFormat("V:[v0(50)]", views: menuBar)
            
            menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupMenuBar()
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
            titleLabel.text = "Home"
            titleLabel.textColor = .white
            titleLabel.font = UIFont.systemFont(ofSize: 20)
            collectionView?.backgroundColor = .white
            
            collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
            collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
            
            setupMenuBar()
            setupNavBarButtons()
            
            setupCollectionView()
        }
        
        func setupCollectionView() {
            if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.scrollDirection = .horizontal
                flowLayout.minimumLineSpacing = 0
            }
            
            collectionView?.backgroundColor = UIColor.white
            
            //        collectionView?.registerClass(VideoCell.self, forCellWithReuseIdentifier: "cellId")
            collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
            
            collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
            collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
            
            collectionView?.isPagingEnabled = true
        }
        
        func setupNavBarButtons() {
            //let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
            //let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
            
           // let moreButton = UIBarButtonItem(image: UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
            
           // navigationItem.rightBarButtonItems = [moreButton, searchBarButtonItem]
        }
        

        
        func scrollToMenuIndex(menuIndex: Int) {
            let indexPath = IndexPath(item: menuIndex, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        lazy var menuBar: MenuBar = {
            let mb = MenuBar()
            mb.homeController = self
            return mb
        }()
        
        override func scrollViewDidScroll(_ scrollView: UIScrollView) {
            menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 3
        }
        
        override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            let index = Int(targetContentOffset.pointee.x / view.frame.width)
            let indexPath = IndexPath(item: index, section: 0)
            menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
        
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 3
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            
            let colors: [UIColor] = [.blue, .green, UIColor.gray, .purple]
            
            cell.backgroundColor = colors[indexPath.item]
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: view.frame.width, height: view.frame.height)
        }
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
    
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

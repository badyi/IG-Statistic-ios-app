//
//  InfoHeaderView.swift
//  IG-Statistic
//
//  Created by и on 16.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit


class InfoHeaderView: UITableViewHeaderFooterView {
    //static let reuseIdentifier: String = String(describing: self)
    @IBOutlet weak var prfoilePicture: UIImageView!
    @IBOutlet weak var label: UILabel!
    
   // override init(reuseIdentifier: String?) {
     //   super.init(reuseIdentifier: reuseIdentifier)

   //     imageView = UIImageView()
     //   nickname = UILabel()
   //     contentView.backgroundColor = .systemBlue
       // contentView.addSubview(imageView)
       // contentView.addSubview(nickname)

        //imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.widthAnchor.constraint(equalToConstant: 125.0).isActive = true
        //imageView.heightAnchor.constraint(equalToConstant: 125.0).isActive = true
//        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
    //    nickname.translatesAutoresizingMaskIntoConstraints = false
  //      nickname.topAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.bottomAnchor, constant: 5).isActive = true
      //  nickname.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        //nickname.heightAnchor.constraint(equalToConstant: 15).isActive = true */
  //  }
    
  //  required init?(coder aDecoder: NSCoder) {
   //     super.init(coder: aDecoder)
    //}
    
    func setImage(with img: UIImage) {
        prfoilePicture.image = img
        prfoilePicture.layer.cornerRadius = self.prfoilePicture.frame.width / 2
        prfoilePicture.clipsToBounds = true
    }
    
    func setNickname(with nickname: String) {
        self.label.text = nickname
    }
}

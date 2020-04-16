//
//  InfoHeaderView.swift
//  IG-Statistic
//
//  Created by и on 16.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit


final class InfoHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier: String = String(describing: self)
    @IBOutlet var imageView: UIImageView! //= UIImageView()
    @IBOutlet var nickname: UILabel! //= UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        imageView = UIImageView()
        //imageView.layer.cornerRadius = imageView.frame.width / 2
        //imageView.clipsToBounds = true
        nickname = UILabel()
        contentView.backgroundColor = .systemBlue
        contentView.addSubview(imageView)
        contentView.addSubview(nickname)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 125.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 125.0).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
        nickname.translatesAutoresizingMaskIntoConstraints = false
        nickname.topAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.bottomAnchor, constant: 5).isActive = true
        nickname.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        nickname.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setImage(with img: UIImage) {
        imageView.image = img
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
    }
    
    func setNickname(with nickname: String) {
        self.nickname.text = nickname
    }
}

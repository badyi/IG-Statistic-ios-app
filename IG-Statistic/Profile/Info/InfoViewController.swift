//
//  InfoViewController.swift
//  IG-Statistic
//
//  Created by и on 16.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    private let tableview: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let cellID = "infoCell"
    private var presenter: InfoPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

extension InfoViewController: InfoViewProtocol {
    func setInfo(with profile: Profile, _ image: UIImage) {
        presenter = InfoPresenter(profile: profile, image: image)
        reloadData()
    }
    
    func reloadData() {
        self.tableview.reloadData()
    }
}

extension InfoViewController {
    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        tableview.register(InfoHeaderView.self, forHeaderFooterViewReuseIdentifier: InfoHeaderView.reuseIdentifier)
        
        view.addSubview(tableview)
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
}

extension InfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = presenter?.infoCount() else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! InfoTableViewCell
        cell.config(with: (presenter?.getInfoName(at: indexPath.row))!, presenter?.getInfo(at: indexPath.row))
        return cell
    }
}

extension InfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(175)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(175)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableview.dequeueReusableHeaderFooterView(withIdentifier: InfoHeaderView.reuseIdentifier) as? InfoHeaderView else {
            return nil
        }
        guard let nick = presenter?.getNickname(),let image = presenter?.getProfileImage() else {
            return nil
        }
        view.setNickname(with: nick)
        view.setImage(with: image)
        return view
    }
}
